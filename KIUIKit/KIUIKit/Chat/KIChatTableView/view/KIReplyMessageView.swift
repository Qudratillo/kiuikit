//
//  KIReplyMessageView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/10/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIReplyMessageView: UIView {
    
    public var viewModel: KIReplyMessageViewModel? {
        didSet {
            self.updateUI(with: self.viewModel)
        }
    }
    
    private let leftStrip: UIView = .init()
    private let imageView: UIImageView = .init()
    private let topTextLabel: UILabel = .init()
    private let bottomTextLabel: UILabel = .init()
    
    public init(frame: CGRect, viewModel: KIReplyMessageViewModel) {
        super.init(frame: frame)
        self.viewModel = viewModel
        self.initView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.leftStrip.backgroundColor = KIConfig.accentColor
        self.leftStrip.frame = CGRect(x: 0, y: KIReplyMessageViewModel.yPadding, width: 2, height: self.bounds.height - KIReplyMessageViewModel.yPadding * 2)
        self.leftStrip.layer.cornerRadius = 1
        self.addSubview(leftStrip)
        
        self.imageView.frame = CGRect(x: KIReplyMessageViewModel.leftStripSpace, y: KIReplyMessageViewModel.yPadding, width: KIReplyMessageViewModel.imageSize, height: KIReplyMessageViewModel.imageSize)
        self.imageView.layer.cornerRadius = 4
        self.imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        self.topTextLabel.font = KIReplyMessageViewModel.topTextFont
        self.topTextLabel.textColor = KIConfig.primaryColor
        self.addSubview(topTextLabel)
        
        self.bottomTextLabel.font = KIReplyMessageViewModel.bottomTextFont
        self.bottomTextLabel.textColor = KIConfig.secondaryTextColor
        self.addSubview(bottomTextLabel)
        
        self.updateUI(with: self.viewModel)
    }
    
    private func updateUI(with viewModel: KIReplyMessageViewModel?) {
        if let viewModel = viewModel {
            if let imageData = viewModel.imageData {
                KIConfig.set(imageView: self.imageView, with: imageData)
                self.imageView.isHidden = false
            }
            else {
                self.imageView.image = nil
                self.imageView.isHidden = true
            }
            
            self.topTextLabel.text = viewModel.topText
            self.topTextLabel.frame = viewModel.topTextFrame
            
            self.bottomTextLabel.text = viewModel.bottomText
            self.bottomTextLabel.frame = viewModel.bottomTextFrame
            self.bottomTextLabel.textColor = viewModel.bottomTextColor
        }
        else {
            self.isHidden = true
        }
    }
    
}
