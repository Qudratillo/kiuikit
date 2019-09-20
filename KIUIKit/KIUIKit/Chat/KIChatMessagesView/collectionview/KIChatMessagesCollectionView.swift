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
    var id: Int
    var date: Date
    var viewModel: KIMessageViewModel
    
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
    
    public init(frame: CGRect) {
        let flowLayout: UICollectionViewFlowLayout = .init()
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
        self.register(KIChatMessageSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header-view")
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
    
}

extension KIChatMessagesCollectionView {
    public func set(items: [KIChatMessageItem]) {
        let width = frame.width
        q.addOperation {
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
            self.sections = sections
            OperationQueue.main.addOperation {
                self.reloadData()
            }
        }
    }
}
