//
//  KIChatTextMessageCell.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/17/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

class KIChatMessageCell<View: KIMessageView<ViewModel>, ViewModel: KIMessageViewModel>: KICollectionViewCell<View, ViewModel> {
    weak var item: KIChatMessageItem?
    
    private let selectionView: UIImageView = .init()
    
    var isEditing: Bool = false {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func initView() {
        selectionView.contentMode = .center
        selectionView.layer.cornerRadius = 15
        selectionView.clipsToBounds = true
        selectionView.layer.borderWidth = 2
        selectionView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.addSubview(selectionView)
    }
}
