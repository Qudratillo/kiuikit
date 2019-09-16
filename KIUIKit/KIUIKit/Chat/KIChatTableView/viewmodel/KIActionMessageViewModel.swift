//
//  KIActionMessageViewModel.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/16/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIActionMessageViewModel: KISizeAwareViewModel {
    
    public static var textFont: UIFont = .systemFont(ofSize: 14)
    
    public var text: String
    private(set) var textFrame: CGRect = .zero
    public var imageData: KIImageData?
    private(set) var imageFrame: CGRect = .zero
    
    public init(width: CGFloat, text: String, imageData: KIImageData?) {
        self.text = text
        self.imageData = imageData
        super.init(width: width, height: 0)
    }
    
    public override func updateFrames() {
        height = 0
        let size = KIActionMessageViewModel.textFont.size(ofString: text, constrainedToWidth: width - 32 - 16)
        textFrame = .init(origin: .init(x: (width - size.width - 16)/2, y: height), size: .init(width: size.width + 16, height: size.height + 8))
        height = textFrame.maxY
        
        if imageData == nil {
            imageFrame = .zero
        } else {
            imageFrame = .init(x: width/2 - 35, y: height + 16, width: 70, height: 70)
            height = imageFrame.maxY
        }
        
    }
    
    
}
