//
//  KIChatMessageSectionHeaderViewModel.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/20/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIChatMessageSectionHeaderViewModel: KISizeAwareViewModel {
    
    public static var textFont: UIFont = .systemFont(ofSize: 12)
    
    public var text: String
    private(set) var textFrame: CGRect = .zero
    
    public init(width: CGFloat, text: String) {
        self.text = text
        super.init(width: width, height: 40)
    }
    
    public override func updateFrames() {
        let size = KIActionMessageViewModel.textFont.size(ofSingleLineString: text)
        textFrame = .init(origin: .init(x: (width - size.width - 4)/2, y: (height - size.height - 4)/2), size: .init(width: size.width + 4, height: size.height + 4))
    }
    
    
}
