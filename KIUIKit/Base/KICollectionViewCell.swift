//
//  KICollectionViewCell.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 1/18/20.
//  Copyright © 2020 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KICollectionViewCell<View: KIView<ViewModel>, ViewModel: KISizeAwareViewModel>: UICollectionViewCell, KIUpdateable {
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
    
    
    private func initView() {
        contentView.addSubview(view)
    }
    
    public func updateUI() {
        view.viewModel = viewModel
        //        print("ki updateui", viewModel ?? "nil")
        view.frame = .init(origin: .zero, size: viewModel?.size ?? .zero)
    }
    
    public func update(model: Any?) {
        if model == nil {
            self.viewModel = nil
        }
        else if let model = model as? ViewModel {
            self.viewModel = model
        }
    }
    
}
