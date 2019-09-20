//
//  KIView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/11/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIView<ViewModel>: UIView {
    public var viewModel: ViewModel? {
        didSet {
           updateUI()
        }
    }
    
    public required init() {
        super.init(frame: .zero)
        self.clipsToBounds = true
        self.initView()
    }
    
    public init(frame: CGRect, viewModel: ViewModel?) {
        super.init(frame: frame)
        self.viewModel = viewModel
        self.clipsToBounds = true
        self.initView()
        self.updateUI()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        
    }
    
    public func updateUI() {
        if let viewModel = viewModel {
            self.isHidden = false
            self.updateUI(with: viewModel)
        }
        else {
            self.isHidden = true
        }
    }
    
    func updateUI(with viewModel: ViewModel) {
        
    }
    
    
}
