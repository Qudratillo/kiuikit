//
//  KIReplyMessageView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/10/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIReplyMessageView: KIView<KIReplyMessageViewModel> {
    
    private let leftStrip: UIView = .init()
    private let imageView: UIImageView = .init()
    private let topTextLabel: UILabel = .init()
    private let bottomTextLabel: UILabel = .init()
    

    
    override func initView() {
        self.leftStrip.backgroundColor = KIConfig.accentColor
        
        self.leftStrip.layer.cornerRadius = 1
        self.addSubview(leftStrip)
        
        self.imageView.frame = CGRect(x: KIReplyMessageViewModel.leftStripSpace, y: KIReplyMessageViewModel.yPadding, width: KIReplyMessageViewModel.imageSize, height: KIReplyMessageViewModel.imageSize)
        self.imageView.layer.cornerRadius = 4
        self.imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        self.topTextLabel.font = KIReplyMessageViewModel.topTextFont
        self.topTextLabel.textColor = KIConfig.primaryColor
        self.topTextLabel.numberOfLines = 1
        self.topTextLabel.lineBreakMode = .byTruncatingTail
        self.addSubview(topTextLabel)
        
        self.bottomTextLabel.font = KIReplyMessageViewModel.bottomTextFont
        self.bottomTextLabel.textColor = KIConfig.secondaryTextColor
        self.bottomTextLabel.numberOfLines = 1
        self.bottomTextLabel.lineBreakMode = .byTruncatingTail
        self.addSubview(bottomTextLabel)
    }
    
    override func updateUI(with viewModel: KIReplyMessageViewModel) {
        self.leftStrip.frame = CGRect(x: 2, y: KIReplyMessageViewModel.yPadding, width: 2, height: viewModel.height - KIReplyMessageViewModel.yPadding * 2)
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
    
}

public class KIReplyMessageViewModel: KISizeAwareViewModel {
    
    public static var replyMessageViewHeightRecommended: CGFloat = KIReplyMessageViewModel.imageSize + KIReplyMessageViewModel.yPadding * 2
    public static var leftStripSpace: CGFloat = 10
    public static var yPadding: CGFloat = 2
    public static var imageSize: CGFloat = 34
    public static var topTextFont: UIFont =  UIFont.systemFont(ofSize: 14, weight: .semibold)
    public static var bottomTextFont: UIFont = UIFont.systemFont(ofSize: 13)
    
    
    public var imageData: KIImageData?
    
    public var topText: String?
    public var topTextFrame: CGRect = .zero
    
    public var bottomText: String?
    public var bottomTextFrame: CGRect = .zero
    public var bottomTextColor: UIColor = .black
    
    
    
    public init(width: CGFloat = 0, imageData: KIImageData?, topText: String?, bottomText: String?) {
        self.imageData = imageData
        self.topText = topText
        self.bottomText = bottomText
        
        super.init(width: width, height: 0)
    }
    
    public override func updateFrames() {
        super.updateFrames()
        self.height = KIReplyMessageViewModel.replyMessageViewHeightRecommended
        var x: CGFloat = KIReplyMessageViewModel.leftStripSpace
        if self.imageData != nil {
            x += KIReplyMessageViewModel.imageSize + 4
        }
        
        let w = self.width - x
        self.topTextFrame = CGRect(x: x, y: KIReplyMessageViewModel.yPadding, width: w, height: KIReplyMessageViewModel.topTextFont.lineHeight)
        self.bottomTextFrame = CGRect(x: x, y: self.height - KIReplyMessageViewModel.yPadding - KIReplyMessageViewModel.bottomTextFont.lineHeight, width: w, height: KIReplyMessageViewModel.bottomTextFont.lineHeight)
        
        
    }
}
