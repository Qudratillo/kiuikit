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
    weak var viewModel: ViewModel? {
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
        view.frame = .init(origin: .zero, size: viewModel?.size ?? .zero)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
