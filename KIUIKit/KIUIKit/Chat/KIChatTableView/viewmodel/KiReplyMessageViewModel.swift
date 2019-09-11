//
//  KiReplyMessageViewModel.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/10/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIReplyMessageViewModel: KISizeAwareViewModel {
    
    public static var replyMessageViewHeightRecommended: CGFloat = KIReplyMessageViewModel.imageSize + KIReplyMessageViewModel.yPadding*2
    public static var leftStripSpace: CGFloat = 8
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
    

    
    public init(width: CGFloat, height: CGFloat, imageData: KIImageData?, topText: String?, bottomText: String?) {
        super.init(width: width, height: height)
        
        self.imageData = imageData
        self.topText = topText
        self.bottomText = bottomText
        
        self.updateFrames()
    }
    
    public override func updateFrames() {
        var x: CGFloat = KIReplyMessageViewModel.leftStripSpace
        if self.imageData != nil {
            x += KIReplyMessageViewModel.imageSize + 4
        }
        
        let w = self.width - x
        self.topTextFrame = CGRect(x: x, y: KIReplyMessageViewModel.yPadding, width: w, height: KIReplyMessageViewModel.topTextFont.lineHeight)
        self.bottomTextFrame = CGRect(x: x, y: self.height - KIReplyMessageViewModel.yPadding - KIReplyMessageViewModel.bottomTextFont.lineHeight, width: w, height: KIReplyMessageViewModel.bottomTextFont.lineHeight)
    }
}
