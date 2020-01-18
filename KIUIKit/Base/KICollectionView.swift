//
//  KICollectionView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 1/18/20.
//  Copyright © 2020 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KICollectionViewItem {
    public var id: Int
    public var viewModel: KISizeAwareViewModel
    weak var view: (UIView & KIUpdateable)?
    
    var needsFlash: Bool = false
    
    public init(id: Int, viewModel: KISizeAwareViewModel) {
        self.id = id
        self.viewModel = viewModel
    }
    
    public init() {
        self.id = 0
        self.viewModel = KIEmptyMessageViewModel()
    }
    
    public init(contentsOf item: KICollectionViewItem) {
        self.id = item.id
        self.viewModel = item.viewModel
    }
        
    
    public func set(contentsOf item: KICollectionViewItem) {
        self.id = item.id
        self.viewModel = item.viewModel
    }
    
    public func updateView() {
        view?.updateUI()
    }
    
    public func updateViewModel() {
        view?.update(model: self.viewModel)
    }
    
    public func flash() {
        self.needsFlash = true
        self.flashItem()
    }
    func flashItem() {
    }
}


public class KICollectionViewSection<Item: KICollectionViewItem> {
    public var viewModel: KISizeAwareViewModel
    public var items: [Item] = []
    
    public init(width: CGFloat, height: CGFloat) {
        viewModel = .init(width: width, height: height)
    }
    
}

public class KICollectionView<Item: KICollectionViewItem>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public typealias Section = KICollectionViewSection<Item>
    
    private let q: OperationQueue = .init()
    
    private var sections: [Section] = []
    
    var contentHeight: CGFloat {
        return self.collectionViewLayout.collectionViewContentSize.height
    }
    public weak var kiDelegate: KICollectionViewDelegate<Item>?
    private(set) var isFetchingTop: Bool = false
    private(set) var isFetchingBottom: Bool = false
    private(set) var inFetchTopZone: Bool = false
    private(set) var inFetchBottomZone: Bool = false
    
    
    public var fetchThreshold: CGFloat = 500
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.backgroundColor = .clear
        self.dataSource = self
        self.delegate = self
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty-cell")
        self.alwaysBounceVertical = true
        
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.element(at: section)?.items.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = sections.element(at: indexPath.section)?.items.element(at: indexPath.row),
            let cell = kiDelegate?.kiCollectionView(cellForItem: item, at: indexPath)
            else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "empty-cell", for: indexPath)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = sections.element(at: indexPath.section)?.items.element(at: indexPath.row) else {
            return .zero
        }
        return item.viewModel.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = self.sections.element(at: indexPath.section),
            let headerView = kiDelegate?.kiCollectionView(headerViewForSection: section, at: indexPath.section)
            else {
                return .init()
        }
        
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let kiDelegate = kiDelegate,
            let item = self.sections.element(at: indexPath.section)?.items.element(at: indexPath.item) {
            kiDelegate.kiCollectionView(willDisplayItem: item)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let kiDelegate = kiDelegate,
            let item = self.sections.element(at: indexPath.section)?.items.element(at: indexPath.item) {
            kiDelegate.kiCollectionView(didEndDisplayingItem: item)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = contentOffset.y
        let bottomY = self.bottomY
        
        self.kiDelegate?.kiCollectionView(didScroll: self, y: y, bottomY: bottomY)
        
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

extension KICollectionView {
    
    // MARK: replace
    public func replace(sections: [Section], updateContentOffset: Bool, callback: @escaping () -> Void) {
        q.addOperation {
            guard let firstSection = sections.first, let lastSection = sections.last else {
                callback()
                return
            }
            
            if let currentFirstSection = self.sections.first, let currentLastSection = self.sections.last {
                if self.compare(section1: currentFirstSection, section2: lastSection) == .orderedDescending {
                    self.sections.insert(contentsOf: sections, at: 0)
                } else if self.compare(section1: currentLastSection, section2: firstSection) == .orderedAscending {
                    self.sections.append(contentsOf: sections)
                } else {
                    var startIndex = 0
                    if let index = self.sections.firstIndex(where: { (section) -> Bool in
                        return self.compare(section1: section, section2: firstSection) != .orderedAscending
                    }) {
                        let startSection = self.sections[index]
                        
                        if self.compare(section1: startSection, section2: firstSection) == .orderedSame {
                            startIndex = index
                            if let itemIndex = startSection.items.firstIndex(where: { (item) -> Bool in
                                return item.id == firstSection.items[0].id
                            }) {
                                firstSection.items.insert(contentsOf: startSection.items.prefix(upTo: itemIndex), at: 0)
                            }
                        } else {
                            startIndex = max(index - 1, 0)
                        }
                    }
                    
                    var endIndex = self.sections.endIndex
                    if let index = self.sections.lastIndex(where: { (section) -> Bool in
                        return self.compare(section1: section, section2: lastSection) != .orderedDescending
                    }) {
                        let endSection = self.sections[index]
                        if self.compare(section1: endSection, section2: lastSection) == .orderedSame {
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
    public func set(sections: [Section], scrollToBottom: Bool, callback: (() -> Void)? = nil) {
        
        q.addOperation {
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
    public func insert(sectionsToTop sections: [Section], callback: @escaping () -> Void) {
        q.addOperation {
            var oldHeight: CGFloat = 0
            DispatchQueue.syncMain {
                oldHeight = self.contentHeight
            }
            
            if let lastSection = sections.last,
                let firstSection = self.sections.first,
                self.compare(section1: lastSection, section2: firstSection) == .orderedSame
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
    public func insert(sectionsToBottom sections: [Section], scrollToBottom: Bool = false, callback: @escaping () -> Void) {
        q.addOperation {
            if let lastSection = self.sections.last,
                let firstSection = sections.first,
            self.compare(section1: lastSection, section2: firstSection) == .orderedSame
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
    
    func setup(item: KIChatMessageItem, width: CGFloat) {
//        print("kiuikit setup item ", item.id)
        item.viewModel.width = width
        item.viewModel.updateFrames()
    }
    
    public func scrollToBottom(animated: Bool) {
        if let lastSection = sections.last, lastSection.items.count != 0 {
            self.scrollToItem(at: .init(item: lastSection.items.count - 1, section: sections.count - 1), at: .bottom, animated: animated)
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
        self.kiDelegate?.kiCollectionViewFetch(middleItemId: id, addPlaceholderData: { (sections) in
            if !sections.isEmpty {
                self.set(sections: sections, scrollToBottom: false) {
                    didScroll = true
                    self.scroll(toItemWithId: id)
                }
            }
        }, addData: { (sections) in
            self.replace(sections: sections, updateContentOffset: false, callback: {
                if !didScroll {
                    self.scroll(toItemWithId: id)
                }
            })
        })
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

extension KICollectionView {
    
    public func fetchTop() {
        if let item = sections.first(where: { (section) -> Bool in
            return section.items.contains { (item) -> Bool in
                return item.id > 0
            }
        })?.items.first(where: { (item) -> Bool in
            return item.id > 0
        })  {
            isFetchingTop = true
            kiDelegate?.kiCollectionViewFetchTop(item: item, addPlaceholderData: { (sections) in
                self.insert(sectionsToTop: sections, callback: {})
            }, addData: { (sections) in
                self.replace(sections: sections, updateContentOffset: true, callback: {
                    self.isFetchingTop = false
                })
            })
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
            kiDelegate?.kiCollectionViewFetchBottom(item: item, addPlaceholderData: { (sections) in
                self.insert(sectionsToBottom: sections, callback: {})
            }, addData: { (sections) in
                self.replace(sections: sections, updateContentOffset: false, callback: {
                    self.isFetchingBottom = false
                })
            })
        }
    }
}

public extension KICollectionView {
    func compare(section1: Section, section2: Section) -> ComparisonResult {
        return .orderedAscending
    }
    func compare(item1: Item, item2: Item) -> ComparisonResult {
        return item1.id < item2.id ? ComparisonResult.orderedAscending : item1.id == item2.id ? ComparisonResult.orderedSame : ComparisonResult.orderedDescending
    }
}

public class KICollectionViewDelegate<Item: KICollectionViewItem>  {
    typealias Section = KICollectionViewSection<Item>
    func kiCollectionViewFetchTop(item: Item, addPlaceholderData: @escaping (_ sections: [Section]) -> Void, addData: @escaping (_ sections: [Section]) -> Void) {}
    func kiCollectionViewFetchBottom(item: Item, addPlaceholderData: @escaping (_ sections: [Section]) -> Void, addData: @escaping (_ sections: [Section]) -> Void) {}
    func kiCollectionViewFetch(middleItemId: Int, addPlaceholderData: @escaping (_ sections: [Section]) -> Void, addData: @escaping (_ sections: [Section]) -> Void) {}
    
    func kiCollectionView(willDisplayItem item: Item) {}
    func kiCollectionView(didEndDisplayingItem item: Item) {}
    func kiCollectionView(downloadItem item: Item) {}
    func kiCollectionView(didScroll collectionView: KICollectionView<Item>, y: CGFloat, bottomY: CGFloat) {}
    func kiCollectionView(cellForItem item: Item, at indexPath: IndexPath) -> UICollectionViewCell? {return nil}
    func kiCollectionView(headerViewForSection item: KICollectionViewSection<Item>, at section: Int) -> UICollectionReusableView? {return nil}
}
