//
//  KIMessageDetailAttachmentViewModel.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/12/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIMessageDetailAttachmentViewModel: KISizeAwareViewModel {
    
    
    public static var leftPadding: CGFloat = 10
    public static var topTextFont: UIFont = .systemFont(ofSize: 15, weight: .semibold)
    public static var bottomTextFont: UIFont = .systemFont(ofSize: 13)
    
    
    public var action: KIMessageAttachmentAction
    public var imageData: KIImageData
    public var imageGradientBase: Int?
    public var imageInitialsText: String?
    public var topText: String?
    private(set) var topTextFrame: CGRect = .zero
    public var bottomText: String?
    private(set) var bottomeTextFrame: CGRect = .zero
    public var sliderValue: Float
    private(set) var sliderFrame: CGRect = .zero
    
    public init(
        width: CGFloat,
        action: KIMessageAttachmentAction,
        imageData: KIImageData,
        imageGradientBase: Int?,
        imageInitialsText: String?,
        topText: String?,
        bottomText: String?,
        sliderValue: Float
        ) {
        self.action = action
        self.imageData = imageData
        self.imageGradientBase = imageGradientBase
        self.imageInitialsText = imageInitialsText
        self.topText = topText
        self.bottomText = bottomText
        self.sliderValue = sliderValue
        
        super.init(width: width, height: 0)
    }
    
    public override func updateFrames() {
        if topText == nil {
            topTextFrame = .zero
            sliderFrame = .init(x: 48 + KIMessageDetailAttachmentViewModel.leftPadding, y: 0, width: width - 48 - KIMessageDetailAttachmentViewModel.leftPadding, height: 20)
        } else {
            topTextFrame = .init(x: 48 + KIMessageDetailAttachmentViewModel.leftPadding, y: 0, width: width - 48 - KIMessageDetailAttachmentViewModel.leftPadding, height: 20)
            sliderFrame = .zero
        }
        
        bottomeTextFrame = .init(x: 48 + KIMessageDetailAttachmentViewModel.leftPadding, y: 20, width: width - 48 - KIMessageDetailAttachmentViewModel.leftPadding, height: 20)
        height = 40
    }
    
    
}
