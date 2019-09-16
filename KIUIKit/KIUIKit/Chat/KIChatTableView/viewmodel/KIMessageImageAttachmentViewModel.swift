//
//  KIImageAttachmentViewModel.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/11/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public enum KIMessageAttachmentAction {
    case download
    case play
    case action(image: UIImage)
    case loading
    case none
}

public class KIMessageImageAttachmentViewModel: KISizeAwareViewModel {
    
    public static var minWidth: CGFloat = 100
    public static var minHeight: CGFloat = 100
    
    
    public static var actionSize: CGFloat = 40
    public static var metaTextFont: UIFont = .systemFont(ofSize: 12)
    
    public var whRatio: CGFloat
    public var imageData: KIImageData
    public var action: KIMessageAttachmentAction
    public var actionWrapFrame: CGRect = .zero
    public var actionFrame: CGRect = .zero
    public var metaText: String?
    private(set) var metaTextFrame: CGRect = .zero
    
    public init(width: CGFloat = 0,
                         height: CGFloat = 0,
                         whRatio: CGFloat,
                         imageData: KIImageData,
                         action: KIMessageAttachmentAction,
                         metaText: String?
                         ) {
        self.whRatio = whRatio
        self.imageData = imageData
        self.action = action
        self.metaText = metaText
        
        super.init(width: width, height: height)
    }
    
    public override func updateFrames() {
        if self.whRatio > 1 {
            self.height = max(self.width / self.whRatio, KIMessageImageAttachmentViewModel.minHeight)
        } else {
            self.width = max(self.height * self.whRatio, KIMessageImageAttachmentViewModel.minWidth)
        }
        
        actionWrapFrame = .init(x: (width - KIMessageImageAttachmentViewModel.actionSize)/2, y: (height - KIMessageImageAttachmentViewModel.actionSize)/2, width: KIMessageImageAttachmentViewModel.actionSize, height: KIMessageImageAttachmentViewModel.actionSize)
        actionFrame = .init(x: 8, y: 8, width: actionWrapFrame.width - 16, height: actionWrapFrame.height - 16)
        if let metaText = metaText {
            let h = KIMessageImageAttachmentViewModel.metaTextFont.lineHeight
            let w = KIMessageImageAttachmentViewModel.metaTextFont.size(ofString: metaText, constrainedToHeight: h).width + 12
            metaTextFrame = .init(x: 6, y: 4, width: min(w, width - 20) , height: h + 8)
        } else {
            metaTextFrame = .zero
        }
    }
    
    
    
    
    
}


