
//
//  KITextMessageViewModel.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/11/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public enum KIMessageContainerLocation {
    case right
    case left
}

public class KITextMessageViewModel: KISizeAwareViewModel {
    
    public static var maxContainerOffset: CGFloat = 100
    public static var maxContainerWidth: CGFloat = 400
    
    
    public static var leftMessageContainerColor: UIColor = .white
    public static var rightMessageContainerColor: UIColor = #colorLiteral(red: 0.9002717783, green: 0.9960784314, blue: 0.8971452887, alpha: 1)
    
    
    public var avatarImageData: KIImageData?
    public var avatarGradientBase: Int?
    public var avatarInitialsText: String?
    private(set) var avatarFrame: CGRect = .zero
    public var contentModel: KITextMessageContentViewModel
    public var containerLocation: KIMessageContainerLocation
    
    private(set) var containerFrame: CGRect = .zero
    private(set) var containerBackgroundColor: UIColor = .white
    
    
    public init(
        width: CGFloat = 0,
        avatarImageData: KIImageData?,
        avatarGradientBase: Int?,
        avatarInitialsText: String?,
        contentModel: KITextMessageContentViewModel,
        containerLocation: KIMessageContainerLocation
        ) {
        self.avatarImageData = avatarImageData
        self.avatarGradientBase = avatarGradientBase
        self.avatarInitialsText = avatarInitialsText
        self.contentModel = contentModel
        self.containerLocation = containerLocation
        super.init(width: width, height: 0)
    }
    
    public override func updateFrames() {
        contentModel.width = min(KITextMessageViewModel.maxContainerWidth, width - KITextMessageViewModel.maxContainerOffset)
        contentModel.updateFrames()
        let containerWidth: CGFloat = contentModel.width
        let containerHeight: CGFloat = contentModel.height
        
        
        var xOffset: CGFloat = 0
        
        if avatarImageData != nil {
            xOffset = 44
        }
        
        
        switch containerLocation {
        case .right:
            containerFrame = .init(x: width - containerWidth - 12 - xOffset, y: 0, width: containerWidth, height: containerHeight)
            containerBackgroundColor = KITextMessageViewModel.rightMessageContainerColor
            avatarFrame = .init(x: width - 8 - 40, y: containerHeight - 40, width: 40, height: 40)
        case .left:
            containerFrame = .init(x: 12 + xOffset, y: 0, width: containerWidth, height: containerHeight)
            avatarFrame = .init(x: 8, y: containerHeight - 40, width: 40, height: 40)
            containerBackgroundColor = KITextMessageViewModel.leftMessageContainerColor
        }
        
        self.height = containerHeight
    }
    
}
