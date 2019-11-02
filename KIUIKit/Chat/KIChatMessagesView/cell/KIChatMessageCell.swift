//
//  KIChatTextMessageCell.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/17/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

class KIChatMessageCell<View: KIView<ViewModel>, ViewModel: KISizeAwareViewModel>: UICollectionViewCell, KIUpdateable {
    weak var item: KIChatMessageItem?
    
    private let view: View = .init()
    public weak var viewModel: ViewModel? {
        didSet {
            self.updateUI()
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
