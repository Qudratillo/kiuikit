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
    
    public static var actionSize: CGFloat = 40
    public static var metaTextFont: UIFont = .systemFont(ofSize: 12)
    
    public var whRatio: CGFloat
    public var imageData: KIImageData
    public var action: KIMessageAttachmentAction
    public var actionWrapFrame: CGRect = .zero
    public var actionFrame: CGRect = .zero
    public var metaText: String?
    public var metaTextFrame: CGRect = .zero
    public var isMetaTextHidden: Bool
    public var minWidth: CGFloat
    public var minHeight: CGFloat
    
    public init(width: CGFloat,
                         height: CGFloat,
                         minWidth: CGFloat,
                         minHeight: CGFloat,
                         whRatio: CGFloat,
                         imageData: KIImageData,
                         action: KIMessageAttachmentAction,
                         metaText: String?,
                         isMetaTextHidden: Bool
                         ) {
        self.whRatio = whRatio
        self.imageData = imageData
        self.action = action
        self.metaText = metaText
        self.isMetaTextHidden = isMetaTextHidden
        self.minWidth = minWidth
        self.minHeight = minHeight
        super.init(width: width, height: height)
        
        self.updateFrames()
    }
    
    public override func updateFrames() {
        if self.whRatio > 1 {
            self.height = max(self.width / self.whRatio, self.minHeight)
        } else {
          self.width = max(self.height * self.whRatio, self.minWidth)
        }
        
        actionWrapFrame = .init(x: (width - KIMessageImageAttachmentViewModel.actionSize)/2, y: (height - KIMessageImageAttachmentViewModel.actionSize)/2, width: KIMessageImageAttachmentViewModel.actionSize, height: KIMessageImageAttachmentViewModel.actionSize)
        actionFrame = .init(x: 8, y: 8, width: actionWrapFrame.width - 16, height: actionWrapFrame.height - 16)
        if let metaText = metaText {
            let h = KIMessageImageAttachmentViewModel.metaTextFont.lineHeight
            let w = KIMessageImageAttachmentViewModel.metaTextFont.size(ofString: metaText, constrainedToHeight: h).width + 12
            metaTextFrame = .init(x: 4, y: 4, width: min(w, width - 20) , height: h + 8)
        }
    }
    
    
    
    
    
}


