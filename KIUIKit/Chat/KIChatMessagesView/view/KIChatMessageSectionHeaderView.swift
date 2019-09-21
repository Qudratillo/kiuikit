//
//  KIChatMessagesCollectionViewSectionHeader.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/20/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit
public class KIChatMessageSectionHeaderView: UICollectionReusableView {
    
    private let textLabel: UILabel = .init()
    
    public var viewModel: KIChatMessageSectionHeaderViewModel? {
        didSet {
            updateUI()
        }
    }
    
    public required init() {
        super.init(frame: .zero)
        self.clipsToBounds = true
        self.initView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.initView()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        textLabel.clipsToBounds = true
        textLabel.textAlignment = .center
        textLabel.baselineAdjustment = .alignCenters
        textLabel.backgroundColor = .init(white: 0, alpha: 0.6)
        textLabel.textColor = .white
        textLabel.font = KIChatMessageSectionHeaderViewModel.textFont
        textLabel.layer.cornerRadius = KIChatMessageSectionHeaderViewModel.textFont.lineHeight / 2 + 2
        addSubview(textLabel)
        
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
    
    func updateUI(with viewModel: KIChatMessageSectionHeaderViewModel) {
        textLabel.text = viewModel.text
        textLabel.frame = viewModel.textFrame
    }
    
    
}
