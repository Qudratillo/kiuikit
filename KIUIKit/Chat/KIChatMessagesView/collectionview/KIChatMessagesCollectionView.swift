//
//  KIChatMessagesCollectionView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/17/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIEmptyMessageViewModel: KISizeAwareViewModel, KIMessageViewModel {
    
}

protocol SelectionModeCellDelegate {
    func setSelectionMode(isEditing: Bool)
}

public class KIChatMessageItem {
    public var id: Int
    public var date: Date
    public var viewModel: KIMessageViewModel
    weak var view: (UIView & KIUpdateable)? {
        didSet {
            if needsFlash {
                self.flashBackground()
            }
        }
    }
    var needsFlash: Bool = false
    public var replyId: Int?
    public var attachmentDownloadData: KIMessageAttachmentDownloadData?
    public var bag: Any?
    
    
    public init(id: Int, date: Date, viewModel: KIMessageViewModel, replyId: Int? = nil,
                attachmentDownloadData: KIMessageAttachmentDownloadData? = nil, bag: Any? = nil) {
        self.id = id
        self.date = date
        self.viewModel = viewModel
        self.replyId = replyId
        self.attachmentDownloadData = attachmentDownloadData
        self.bag = bag
    }
    
    public init() {
        self.id = 0
        self.date = Date()
        self.viewModel = KIEmptyMessageViewModel()
    }
    
    public init(contentsOf item: KIChatMessageItem) {
        self.id = item.id
        self.date = item.date
        self.viewModel = item.viewModel
        self.replyId = item.replyId
        self.attachmentDownloadData = item.attachmentDownloadData
        self.bag = item.bag
    }
    
    
    public func set(contentsOf item: KIChatMessageItem) {
        self.id = item.id
        self.date = item.date
        self.viewModel = item.viewModel
        self.replyId = item.replyId
        self.attachmentDownloadData = item.attachmentDownloadData
        self.bag = item.bag
    }
    
    public func updateView() {
        view?.updateUI()
    }
    
    public func updateViewModel() {
        view?.update(model: self.viewModel)
    }
    
    func flash() {
        self.needsFlash = true
        self.flashBackground()
    }
    private func flashBackground() {
        if let view = view {
            self.needsFlash = false
            view.backgroundColor = KIConfig.accentColor.withAlphaComponent(0.25)
            UIView.animate(withDuration: 1, delay: 1.5, options: [.curveEaseIn], animations: {
                view.backgroundColor = nil
            })
        }
    }
}


private class KIChatMessagesCollectionViewSection {
    public var date: Date
    public var viewModel: KIChatMessageSectionHeaderViewModel
    public var items: [KIChatMessageItem] = []
    
    public init(width: CGFloat, date: Date) {
        self.date = date
        let df = DateFormatter()
        df.dateFormat = "dd MMMM"
        viewModel = .init(width: width, text: df.string(from: date))
    }
    
}

public class KIChatMessagesCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SelectionModeCellDelegate {
    
    private let q: OperationQueue = .init()
    private let replyQ: OperationQueue = .init()
    
    private var sections: [KIChatMessagesCollectionViewSection] = []
    public var selectedMessageIds: Set<Int> = Set() {
        didSet {
            didSelectMessageItemHandler?(selectedMessageIds.count)
        }
    }
    
    public var didSelectMessageItemHandler: ((_ countOfselectedItems: Int) -> ())? = nil
    
    var contentHeight: CGFloat {
        return self.collectionViewLayout.collectionViewContentSize.height
    }
    public weak var messagesDelegate: KIChatMessagesCollectionViewMessagesDelegate?
    private(set) var isFetchingTop: Bool = false
    private(set) var isFetchingBottom: Bool = false
    private(set) var inFetchTopZone: Bool = false
    private(set) var inFetchBottomZone: Bool = false

    public private(set) var isEditing:Bool = false
    
    public var fetchThreshold: CGFloat = 500
    
    public init(frame: CGRect) {
        let flowLayout: UICollectionViewFlowLayout = .init()
        flowLayout.headerReferenceSize = .init(width: frame.width, height: 40)
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.minimumLineSpacing = 2
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        initView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.backgroundColor = .clear
        self.dataSource = self
        self.delegate = self
        self.register(KIChatMessageCell<KITextMessageView, KITextMessageViewModel>.self, forCellWithReuseIdentifier: "text-message-cell")
        self.register(KIChatMessageCell<KIActionMessageView, KIActionMessageViewModel>.self, forCellWithReuseIdentifier: "action-message-cell")
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty-cell")
        self.register(KIChatMessageSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header-view")
        self.alwaysBounceVertical = true
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.element(at: section)?.items.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = sections.element(at: indexPath.section)?.items.element(at: indexPath.row) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "empty-cell", for: indexPath)
        }
        
        if let viewModel = item.viewModel as? KITextMessageViewModel {
            let cell: KIChatMessageCell<KITextMessageView, KITextMessageViewModel> = collectionView.dequeueReusableCell(withReuseIdentifier: "text-message-cell", for: indexPath) as? KIChatMessageCell<KITextMessageView, KITextMessageViewModel> ?? .init()
            if let item = cell.item, item.view == cell {
                item.view = nil
            }
            cell.selectionModeCellDelegate = self
            cell.item = item
            cell.viewModel = viewModel
            item.view = cell
            cell.selectedItemAction = selectedItemAction
            if isEditing {
                cell.checkView(isChecked: self.selectedMessageIds.contains(item.id))
            }
            
            return cell
        }
        else if let viewModel = item.viewModel as? KIActionMessageViewModel {
            let cell: KIChatMessageCell<KIActionMessageView, KIActionMessageViewModel> = collectionView.dequeueReusableCell(withReuseIdentifier: "action-message-cell", for: indexPath) as? KIChatMessageCell<KIActionMessageView, KIActionMessageViewModel> ?? .init()
            if let item = cell.item, item.view == cell {
                item.view = nil
            }
            cell.item = item
            cell.viewModel = viewModel
            item.view = cell
            if isEditing {
                cell.checkView(isChecked: self.selectedMessageIds.contains(item.id))
            }
            return cell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "empty-cell", for: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = sections.element(at: indexPath.section)?.items.element(at: indexPath.row) else {
            return .init(width: frame.width, height: 0)
        }
        return item.viewModel.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = self.sections.element(at: indexPath.section) else {
            return .init()
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header-view", for: indexPath) as! KIChatMessageSectionHeaderView
        headerView.viewModel = section.viewModel
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let messagesDelegate = messagesDelegate,
            let item = self.sections.element(at: indexPath.section)?.items.element(at: indexPath.item) {
            messagesDelegate.chatMessagesCollectionView(willDisplayItem: item)
            if let attachmentDownloadData = item.attachmentDownloadData,
                attachmentDownloadData.downloadWhenDisplay,
                let viewModel = item.viewModel as? KITextMessageViewModel,
                let attachmentModel = viewModel.contentModel.attachmentModel
            {
                attachmentDownloadData.downloadWhenDisplay = false
                attachmentModel.action = .loading
                messagesDelegate.chatMessagesCollectionView(downloadItem: item)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let messagesDelegate = messagesDelegate,
            let item = self.sections.element(at: indexPath.section)?.items.element(at: indexPath.item) {
            messagesDelegate.chatMessagesCollectionView(didEndDisplayingItem: item)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = contentOffset.y
        let bottomY = self.bottomY
        
        self.messagesDelegate?.chatMessagesCollectionView(didScroll: self, y: y, bottomY: bottomY)
        
        if !inFetchTopZone && !isFetchingTop &&  y < fetchThreshold {
            inFetchTopZone = true
            inFetchBottomZone = false
            fetchTop()
        }
        else if inFetchTopZone && y > 2 * fetchThreshold {
            inFetchTopZone = false
        }
        
        if !inFetchBottomZone && !isFetchingBottom && bottomY < fetchThreshold {
            inFetchBottomZone = true
            inFetchTopZone = false
            fetchBottom()
        }
            
        else if inFetchBottomZone && bottomY > 2 * fetchThreshold {
            inFetchBottomZone = false
        }
    }
    
    public var bottomY: CGFloat {
        return contentHeight - frame.height - contentOffset.y
    }
    
}

extension KIChatMessagesCollectionView {
    
    // MARK: replace
    public func replace(items: [KIChatMessageItem], updateContentOffset: Bool, callback: @escaping () -> Void) {
        q.addOperation {
            let sections = self.makeSections(items: items)
            
            guard let firstSection = sections.first, let lastSection = sections.last else {
                callback()
                return
            }
            
            if let currentFirstSection = self.sections.first, let currentLastSection = self.sections.last {
                if currentFirstSection.date > lastSection.date {
                    self.sections.insert(contentsOf: sections, at: 0)
                } else if currentLastSection.date < firstSection.date {
                    self.sections.append(contentsOf: sections)
                } else {
                    var startIndex = 0
                    if let index = self.sections.firstIndex(where: { (section) -> Bool in
                        return section.date > firstSection.date || Calendar.current.isDate(section.date, inSameDayAs: firstSection.date)
                    }) {
                        
                        let startSection = self.sections[index]
                        
                        if Calendar.current.isDate(startSection.date, inSameDayAs: firstSection.date) {
                            startIndex = index
                            if let itemIndex = startSection.items.firstIndex(where: { (messageItem) -> Bool in
                                return messageItem.id == firstSection.items[0].id
                            }) {
                                firstSection.items.insert(contentsOf: startSection.items.prefix(upTo: itemIndex), at: 0)
                            }
                        } else {
                            startIndex = max(index - 1, 0)
                        }
                    }
                    
                    var endIndex = self.sections.endIndex
                    if let index = self.sections.lastIndex(where: { (section) -> Bool in
                        return section.date < lastSection.date || Calendar.current.isDate(section.date, inSameDayAs: lastSection.date)
                    }) {
                        let endSection = self.sections[index]
                        if Calendar.current.isDate(endSection.date, inSameDayAs: lastSection.date) {
                            if let itemIndex = endSection.items.lastIndex(where: { (messageItem) -> Bool in
                                return messageItem.id == lastSection.items.last?.id
                            }) {
                                lastSection.items.append(contentsOf: endSection.items.suffix(from: itemIndex + 1))
                            }
                        }
                        endIndex = index + 1
                    }
                    
                    self.sections.replaceSubrange(startIndex..<endIndex, with: sections)
                }
            }
            else {
                self.sections = sections
            }
            
            OperationQueue.main.addOperation {
                if updateContentOffset {
                    let offsetY = self.contentOffset.y
                    let oldHeight = self.contentHeight
                    self.reloadData()
                    if updateContentOffset {
                        self.contentOffset = .init(x: 0, y: offsetY + self.contentHeight - oldHeight)
                    }
                } else {
                    self.reloadData()
                }
                
                callback()
            }
        }
    }
    
    // MARK: set
    public func set(items: [KIChatMessageItem], scrollToBottom: Bool, callback: (() -> Void)? = nil) {
        
        q.addOperation {
            self.sections = self.makeSections(items: items)
            
            OperationQueue.main.addOperation {
                self.reloadData()
                if self.contentHeight < self.frame.height - self.contentInset.top - self.contentInset.bottom {
                    self.fetchTop()
                }
                
                if scrollToBottom {
                    self.scrollToBottom(animated: false)
                }
                
                callback?()
            }
        }
    }
    
    // MARK: insert to top
    public func insert(itemsToTop items: [KIChatMessageItem], callback: @escaping () -> Void) {
        q.addOperation {
            var oldHeight: CGFloat = 0
            DispatchQueue.syncMain {
                oldHeight = self.contentHeight
            }
            
            let sections = self.makeSections(items: items)
            
            if let lastSection = sections.last,
                let firstSection = self.sections.first,
                Calendar.current.isDate(lastSection.date, inSameDayAs: firstSection.date)
            {
                self.sections.insert(contentsOf: sections.prefix(upTo: sections.count - 1), at: 0)
                firstSection.items.insert(contentsOf: lastSection.items, at: 0)
            }
            else {
                self.sections.insert(contentsOf: sections, at: 0)
            }
            OperationQueue.main.addOperation {
                let offsetY = self.contentOffset.y
                self.reloadData()
                
                //                if !self.isScrolling {
                self.contentOffset = .init(x: 0, y: offsetY + self.contentHeight - oldHeight)
                //                }
                
                callback()
            }
            
        }
    }
    // MARK: insert to bottom
    public func insert(itemsToBottom items: [KIChatMessageItem], scrollToBottom: Bool = false, callback: @escaping () -> Void) {
        q.addOperation {
            let sections = self.makeSections(items: items)
            
            if let lastSection = self.sections.last,
                let firstSection = sections.first,
                Calendar.current.isDate(lastSection.date, inSameDayAs: firstSection.date)
            {
                self.sections.append(contentsOf: sections.suffix(from: 1))
                lastSection.items.append(contentsOf: firstSection.items)
            } else {
                self.sections.append(contentsOf: sections)
            }
            OperationQueue.main.addOperation {
                self.reloadData()
                
                if scrollToBottom {
                    let d = self.contentHeight - (self.contentOffset.y + self.frame.height + self.contentInset.top + self.contentInset.bottom)
                    self.scrollToBottom(animated: d < 1000)
                }
                
                callback()
            }
            
        }
    }
    
    public func reload(item: KIChatMessageItem) {
        q.addOperation {
            var width: CGFloat = 0
            DispatchQueue.syncMain {
                width = self.frame.width
            }
            self.setup(item: item, width: width)
            OperationQueue.main.addOperation {
                self.reloadData()
            }
        }
    }
    
    private func setup(item: KIChatMessageItem, width: CGFloat) {
        //        print("kiuikit setup item ", item.id)
        item.viewModel.width = width
        item.viewModel.updateFrames()
        if let viewModel = item.viewModel as? KITextMessageViewModel {
            viewModel.onTapAvatar { [weak self, weak item] in
                if let item = item {
                    self?.messagesDelegate?.chatMessagesCollectionView(didTapSenderOnItem: item)
                }
            }
            
            viewModel.contentModel.onTapName { [weak self, weak item] in
                if let item = item {
                    self?.messagesDelegate?.chatMessagesCollectionView(didTapSenderOnItem: item)
                }
            }
            
            viewModel.contentModel.onTapAttachment { [weak self, weak item] in
                if let item = item {
                    self?.messagesDelegate?.chatMessagesCollectionView(didTapAttachmentOnItem: item)
                }
            }
            
            viewModel.contentModel.onTapForwarder { [weak self, weak item] in
                if let item = item {
                    self?.messagesDelegate?.chatMessagesCollectionView(didTapForwarderOnItem: item)
                }
            }
            
            viewModel.contentModel.attachmentModel?.onTapAction { [weak self, weak item] (action) in
                if let item = item, let messagesDelegate = self?.messagesDelegate {
                    if case .download = action {
                        messagesDelegate.chatMessagesCollectionView(downloadItem: item)
                    } else {
                        messagesDelegate.chatMessagesCollectionView(didTap: action, on: item)
                    }
                }
            }
            
            viewModel.contentModel.onTapReply { [weak self, weak item] in
                if let item = item {
                    self?.didTapReply(on: item)
                }
            }
            
            viewModel.contentModel.attachmentModel?.onSliderValueChanged({ [weak self, weak item] (value, event) in
                if let item = item {
                    self?.messagesDelegate?.chatMessagesCollectionView(didChangeSliderValue: value, on: item, phase: event)
                }
            })
            
        }
    }
    
    private func makeSections(items: [KIChatMessageItem]) -> [KIChatMessagesCollectionViewSection] {
        var width: CGFloat = 0
        
        DispatchQueue.syncMain {
            width = self.frame.width
        }
        
        let items = items.sorted(by: { (item1, item2) -> Bool in
            return item1.id < item2.id
        })
        
        var sections: [KIChatMessagesCollectionViewSection] = []
        var section: KIChatMessagesCollectionViewSection = .init(width: width, date: .init(timeIntervalSince1970: 0))
        
        for item in items {
            if let model = item.viewModel as? KITextMessageViewModel {
                model.isEditing = self.isEditing
            }
            setup(item: item, width: width)
            if Calendar.current.isDate(section.date, inSameDayAs: item.date) {
                section.items.append(item)
            } else {
                section = .init(width: width, date: Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: item.date)) ?? item.date)
                sections.append(section)
                section.items.append(item)
            }
        }
        return sections
    }
    
    public func scrollToBottom(animated: Bool) {
        if let lastSection = sections.last, lastSection.items.count != 0 {
            self.scrollToItem(at: .init(item: lastSection.items.count - 1, section: sections.count - 1), at: .bottom, animated: animated)
        }
    }
    
    private func didTapReply(on item: KIChatMessageItem) {
        guard let replyId = item.replyId else {
            return
        }
        
        replyQ.cancelAllOperations()
        replyQ.addOperation {
            self._show(itemWithId: replyId)
        }
    }
    
    public func show(itemWithId id: Int) {
        q.addOperation {
            self._show(itemWithId: id)
        }
    }
    
    private func _show(itemWithId id: Int) {
        if self.scroll(toItemWithId: id) {
            return
        }
        var didScroll = false
        self.messagesDelegate?.fetch(middleItemId: id, addPlaceholderItems: { (items) in
            if !items.isEmpty {
                self.set(items: items, scrollToBottom: false) {
                    didScroll = true
                    self.scroll(toItemWithId: id)
                }
            }
        }, addItems: { (items) in
            self.replace(items: items, updateContentOffset: false, callback: {
                if !didScroll {
                    self.scroll(toItemWithId: id)
                }
            })
        })
    }
    
    public func setSelectionMode(isEditing: Bool) {
        self.isEditing = isEditing
        selectionModeUpdate()
    }
    
    public func deleteMessageSectionItems() {
        
        self.sections = self.sections.compactMap({ (section) -> KIChatMessagesCollectionViewSection? in
            section.items = section.items.filter { !selectedMessageIds.contains($0.id) }
            return section.items.isEmpty ? nil : section
        })
        self.reloadData()
    }
    
    func selectedItemAction(_ messageId: Int, _ isChecked: Bool) {
        if isChecked {
            selectedMessageIds.insert(messageId)
        } else {
            selectedMessageIds.remove(messageId)
        }
    }
    
    private func selectionModeUpdate() {
        let width = self.frame.width
        DispatchQueue.global(qos: .userInteractive).sync {
            self.sections.forEach { (sections) in
                sections.items.forEach { (item) in
                    item.viewModel.isEditing = self.isEditing
                    self.setup(item: item, width: width)
                }
            }
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    @discardableResult
    public func scroll(toItemWithId itemId: Int) -> Bool {
        for (sectionIndex, section) in self.sections.enumerated() {
            for (itemIndex, sectionItem) in section.items.enumerated() {
                if sectionItem.id == itemId {
                    OperationQueue.main.addOperation {
                        sectionItem.flash()
                        self.scrollToItem(at: .init(item: itemIndex, section: sectionIndex), at: .centeredVertically, animated: true)
                    }
                    return true
                }
            }
        }
        return false
    }
    
    public func update(bottomInset: CGFloat) {
        let oldBottom = contentInset.bottom
        contentInset = .init(top: contentInset.top, left: contentInset.left, bottom: bottomInset, right: contentInset.right)
        if bottomY > oldBottom - bottomInset {
            self.contentOffset = .init(x: 0, y: contentOffset.y - oldBottom + bottomInset)
        }
        
    }
}

extension KIChatMessagesCollectionView {
    
    public func fetchTop() {
        if let item = sections.first(where: { (section) -> Bool in
            return section.items.contains { (item) -> Bool in
                return item.id > 0
            }
        })?.items.first(where: { (item) -> Bool in
            return item.id > 0
        })  {
            isFetchingTop = true
            messagesDelegate?.fetchTop(item: item, addPlaceholderItems: { (items) in
                self.insert(itemsToTop: items, callback: {
                })
            }) { (items) in
                self.replace(items: items, updateContentOffset: true, callback: {
                    self.isFetchingTop = false
                })
            }
        }
    }
    
    public func fetchBottom() {
        if let item = sections.last(where: { (section) -> Bool in
            return section.items.contains { (item) -> Bool in
                return item.id > 0
            }
        })?.items.last(where: { (item) -> Bool in
            return item.id > 0
        }) {
            isFetchingBottom = true
            messagesDelegate?.fetchBottom(item: item, addPlaceholderItems: { (items) in
                self.insert(itemsToBottom: items, callback: {})
            }) { (items) in
                self.replace(items: items, updateContentOffset: false, callback: {
                    self.isFetchingBottom = false
                })
            }
        }
    }
}


public protocol KIChatMessagesCollectionViewMessagesDelegate: class {
    func fetchTop(item: KIChatMessageItem, addPlaceholderItems: @escaping (_ items: [KIChatMessageItem]) -> Void, addItems: @escaping (_ items: [KIChatMessageItem]) -> Void)
    func fetchBottom(item: KIChatMessageItem, addPlaceholderItems: @escaping (_ items: [KIChatMessageItem]) -> Void, addItems: @escaping (_ items: [KIChatMessageItem]) -> Void)
    func fetch(middleItemId: Int, addPlaceholderItems: @escaping (_ items: [KIChatMessageItem]) -> Void, addItems: @escaping (_ items: [KIChatMessageItem]) -> Void)
    
    func chatMessagesCollectionView(willDisplayItem item: KIChatMessageItem)
    func chatMessagesCollectionView(didEndDisplayingItem item: KIChatMessageItem)
    func chatMessagesCollectionView(didTap action: KIMessageAttachmentAction, on item: KIChatMessageItem)
    func chatMessagesCollectionView(didTapAttachmentOnItem item: KIChatMessageItem)
    func chatMessagesCollectionView(didTapSenderOnItem item: KIChatMessageItem)
    func chatMessagesCollectionView(didTapForwarderOnItem item: KIChatMessageItem)
    func chatMessagesCollectionView(didChangeSliderValue value: Float, on item: KIChatMessageItem, phase: UITouch.Phase)
    func chatMessagesCollectionView(downloadItem item: KIChatMessageItem)
    func chatMessagesCollectionView(didScroll collectionView: KIChatMessagesCollectionView, y: CGFloat, bottomY: CGFloat)
}

public extension KIChatMessagesCollectionViewMessagesDelegate {
    func fetchTop(item: KIChatMessageItem, addPlaceholderItems: @escaping (_ items: [KIChatMessageItem]) -> Void, addItems: @escaping (_ items: [KIChatMessageItem]) -> Void) {}
    func fetchBottom(item: KIChatMessageItem, addPlaceholderItems: @escaping (_ items: [KIChatMessageItem]) -> Void, addItems: @escaping (_ items: [KIChatMessageItem]) -> Void) {}
    func fetch(middleItemId: Int, addPlaceholderItems: @escaping (_ items: [KIChatMessageItem]) -> Void, addItems: @escaping (_ items: [KIChatMessageItem]) -> Void) {}
    
    func chatMessagesCollectionView(willDisplayItem item: KIChatMessageItem) {}
    func chatMessagesCollectionView(didEndDisplayingItem item: KIChatMessageItem) {}
    func chatMessagesCollectionView(didTap action: KIMessageAttachmentAction, on item: KIChatMessageItem) {}
    func chatMessagesCollectionView(didTapAttachmentOnItem item: KIChatMessageItem) {}
    func chatMessagesCollectionView(didTapSenderOnItem item: KIChatMessageItem) {}
    func chatMessagesCollectionView(didTapForwarderOnItem item: KIChatMessageItem) {}
    func chatMessagesCollectionView(didChangeSliderValue value: Float, on item: KIChatMessageItem, phase: UITouch.Phase) {}
    func chatMessagesCollectionView(downloadItem item: KIChatMessageItem) {}
    
    func chatMessagesCollectionView(didScroll collectionView: KIChatMessagesCollectionView, y: CGFloat, bottomY: CGFloat) {}
}
