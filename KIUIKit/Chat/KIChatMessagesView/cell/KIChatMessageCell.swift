//
//  KIChatTextMessageCell.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/17/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIChatMessageCell<View: KIView<ViewModel>, ViewModel: KISizeAwareViewModel>: UICollectionViewCell {
    
    private let view: View = .init()
    public var viewModel: ViewModel? {
        didSet {
            view.viewModel = viewModel
            view.frame = .init(origin: .zero, size: viewModel?.size ?? .zero)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView() {
        contentView.addSubview(view)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        view.updateUI()
    }
}
