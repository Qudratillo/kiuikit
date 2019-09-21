//
//  KIFrameAwareViewModel.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/10/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KISizeAwareViewModel {
    public var width: CGFloat
    public var height: CGFloat
    
    public var size: CGSize {
        return .init(width: width, height: height)
    }
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        if width != 0 || height != 0 {
            self.updateFrames()
        }
    }
    
    public func updateFrames() {
        
    }
}
