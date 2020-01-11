//
//  KIChatTextMessageCell.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/17/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

class KIChatMessageCell<View: KIMessageView<ViewModel>, ViewModel: KIMessageViewModel>: UICollectionViewCell, KIUpdateable {
    weak var item: KIChatMessageItem?
    
    private let view: View = .init()
    private let selectionView: UIImageView = .init()
    weak var viewModel: ViewModel? {
        didSet {
            self.updateUI()
        }
    }
    
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
        contentView.addSubview(view)
        
        selectionView.contentMode = .center
        selectionView.layer.cornerRadius = 15
        selectionView.clipsToBounds = true
        selectionView.layer.borderWidth = 2
        selectionView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.addSubview(selectionView)
    }

    func updateUI() {
        view.viewModel = viewModel
//        print("ki updateui", viewModel ?? "nil")
        view.frame = .init(origin: .zero, size: viewModel?.size ?? .zero)
    }
    
    func update(model: Any?) {
//        print("ki updatemodel", model ?? "nil")
        if model == nil {
            self.viewModel = nil
        }
        else if let model = model as? ViewModel {
            self.viewModel = model
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
