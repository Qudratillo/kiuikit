//
//  KIChatMessagesCollectionView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/17/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public typealias KIChatTextMessageCellModel<MessageData> = KIChatMessageCellModel<MessageData, KITextMessageViewModel>
public typealias KIChatActionMessageCellModel<MessageData> = KIChatMessageCellModel<MessageData, KIActionMessageViewModel>

public class KIChatMessageItem {
    public var id: Int
    public var date: Date
    public var viewModel: KIMessageViewModel
    
    public init(id: Int, date: Date, viewModel: KIMessageViewModel) {
        self.id = id
        self.date = date
        self.viewModel = viewModel
    }
    
}


private class KIChatMessagesCollectionViewSection {
    public var date: Date
    public var viewModel: KIChatMessageSectionHeaderViewModel;
    public var items: [KIChatMessageItem] = []
    
    public init(width: CGFloat, date: Date) {
        self.date = date
        let df = DateFormatter()
        df.dateFormat = "dd MMMM"
        viewModel = .init(width: width, text: df.string(from: date))
    }
    
}

public class KIChatMessagesCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var q: OperationQueue = .init()
    
    private var sections: [KIChatMessagesCollectionViewSection] = []
    
    private var isScrolling: Bool = false
    
    var contentHeight: CGFloat {
        return self.collectionViewLayout.collectionViewContentSize.height
    }
    public weak var messagesDelegate: KIChatMessagesCollectionViewMessagesDelegate?
    private(set) var isFetchingTop: Bool = false
    private(set) var isFetchingBottom: Bool = false
    
    private let flowLayout: UICollectionViewFlowLayout = .init()
    
    public init(frame: CGRect) {
        
        flowLayout.headerReferenceSize = .init(width: frame.width, height: 40)
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        
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
            return .init()
        }
        
        if let viewModel = item.viewModel as? KITextMessageViewModel {
            let cell: KIChatMessageCell<KITextMessageView, KITextMessageViewModel> = collectionView.dequeueReusableCell(withReuseIdentifier: "text-message-cell", for: indexPath) as? KIChatMessageCell<KITextMessageView, KITextMessageViewModel> ?? .init()
            cell.viewModel = viewModel
//            dump(viewModel)
            return cell
        }
        else if let viewModel = item.viewModel as? KIActionMessageViewModel {
            let cell: KIChatMessageCell<KIActionMessageView, KIActionMessageViewModel> = collectionView.dequeueReusableCell(withReuseIdentifier: "action-message-cell", for: indexPath) as? KIChatMessageCell<KIActionMessageView, KIActionMessageViewModel> ?? .init()
            cell.viewModel = viewModel
//            dump(viewModel)
            return cell
        }
        
        return .init()
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let messagesDelegate = messagesDelegate else {
            return
        }
        if !isFetchingTop && scrollView.contentOffset.y < 100 {
            if let item = sections.first?.items.first {
                isFetchingTop = true
                messagesDelegate.fetchTop(item: item) { (items) in
                    self.insert(itemsToTop: items, callback: {
                        self.isFetchingTop = false
                    })
                }
            }
        }
        
        if !isFetchingBottom && contentHeight - frame.height - scrollView.contentOffset.y < 100 {
            if let item = sections.last?.items.last {
            isFetchingBottom = true
                messagesDelegate.fetchBottom(item: item) { (items) in
                    self.insert(itemsToBottom: items, callback: {
                        self.isFetchingBottom = false
                    })
                }
            }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
        }
    }
    
}

extension KIChatMessagesCollectionView {
    
  
    public func set(items: [KIChatMessageItem], scrollToBottom: Bool) {
        
        q.addOperation {
            self.sections = self.makeSections(items: items)
            
            OperationQueue.main.addOperation {
                self.reloadData()
                
                if scrollToBottom {
                    self.scrollToBottom(animated: false)
                }
            }
        }
    }
    
    public func insert(itemsToTop items: [KIChatMessageItem], callback: @escaping () -> Void) {
        q.addOperation {
            var oldHeight: CGFloat = 0
            DispatchQueue.main.sync {
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
                self.reloadData()
                
//                if !self.isScrolling {
                self.setContentOffset(.init(x: 0, y: self.contentHeight - oldHeight), animated: false)
//                }
                
                callback()
            }
            
        }
    }
    
    public func insert(itemsToBottom items: [KIChatMessageItem], callback: @escaping () -> Void) {
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
                
                callback()
            }
            
        }
    }
    
    private func makeSections(items: [KIChatMessageItem]) -> [KIChatMessagesCollectionViewSection] {
        var width: CGFloat = 0
        
        DispatchQueue.main.sync {
            width = self.frame.width
        }
        
        let items = items.sorted(by: { (item1, item2) -> Bool in
            return item1.id < item2.id
        })
        
        var sections: [KIChatMessagesCollectionViewSection] = []
        var section: KIChatMessagesCollectionViewSection = .init(width: width, date: .init(timeIntervalSince1970: 0))
        
        for item in items {
            item.viewModel.width = width
            item.viewModel.updateFrames()
            if Calendar.current.isDate(section.date, inSameDayAs: item.date) {
                section.items.append(item)
            } else {
                section = .init(width: width, date: item.date)
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
}

public protocol KIChatMessagesCollectionViewMessagesDelegate: class {
    func fetchTop(item: KIChatMessageItem, callback: @escaping (_ items: [KIChatMessageItem]) -> Void)
    func fetchBottom(item: KIChatMessageItem, callback: @escaping (_ items: [KIChatMessageItem]) -> Void)
}
