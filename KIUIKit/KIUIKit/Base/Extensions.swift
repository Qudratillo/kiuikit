//
//  Extensions.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/11/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

extension UIFont {
    func size (ofString string: String, constrainedToWidth width: CGFloat) -> CGSize {
        let attributes = [NSAttributedString.Key.font: self]
        let attString = NSAttributedString(string: string,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: 0), nil, CGSize(width: width, height: .greatestFiniteMagnitude), nil)
    }
    
    func size (ofString string: String, constrainedToHeight height: CGFloat) -> CGSize {
        let attributes = [NSAttributedString.Key.font: self]
        let attString = NSAttributedString(string: string,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: 0), nil, CGSize(width: .greatestFiniteMagnitude, height: height), nil)
    }
}
