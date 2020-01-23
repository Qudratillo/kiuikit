//
//  KIFrameAwareViewModel.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/10/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KISizeAwareViewModel: KIViewModel {
    public var width: CGFloat
    public var height: CGFloat
    
    public override var isEditing: Bool {
        didSet {
            checkBoxWidth = isEditing ? 40 : 0
        }
    }
    private(set) var checkBoxWidth: CGFloat = 0
    
    public var size: CGSize {
        return .init(width: width, height: height)
    }
    
    public init(width: CGFloat = 0, height: CGFloat = 0) {
        self.width = width
        self.height = height
        super.init()
        if width != 0 || height != 0 {
            self.updateFrames()
        }
    }
    
    public func updateFrames() {
        self.isEdited = true
    }
}


public class KIEmptyViewModel: KISizeAwareViewModel {
    
}
