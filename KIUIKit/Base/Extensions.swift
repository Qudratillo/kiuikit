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
        let attributes = [NSAttributedString.Key.font: self, NSAttributedString.Key.paragraphStyle: WordWrapParagraphStyle()]
        let attString = NSAttributedString(string: string,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: 0), nil, CGSize(width: width, height: .greatestFiniteMagnitude), nil)
        return .init(width: ceil(size.width), height: round(size.height / self.lineHeight) * self.lineHeight)
    }
    
    func size (ofString string: String, constrainedToHeight height: CGFloat) -> CGSize {
        let attributes = [NSAttributedString.Key.font: self, NSAttributedString.Key.paragraphStyle: WordWrapParagraphStyle()]
        let attString = NSAttributedString.init(string: string, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: 0), nil, CGSize(width: .greatestFiniteMagnitude, height: height), nil)
    }
    
    
    func size (ofSingleLineString string: String) -> CGSize {
        let attributes = [NSAttributedString.Key.font: self, NSAttributedString.Key.paragraphStyle: WordWrapParagraphStyle()]
        let attString = NSAttributedString.init(string: string, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: 0), nil, CGSize(width: .greatestFiniteMagnitude, height: self.lineHeight), nil)
    }
}

class WordWrapParagraphStyle: NSParagraphStyle {
    open override var lineBreakMode: NSLineBreakMode {
        return .byWordWrapping
    }
}

extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

extension Array {
    func element(at index: Int) -> Element? {
        return index < 0 || index >= count ? nil : self[index]
    }
}

extension UIImage {
    static func resourceImage(for object: AnyObject, named: String) -> UIImage? {
        let bundle = Bundle(for: type(of: object))
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }
}

extension DispatchQueue {
    static func syncMain(_ task: @escaping () -> Void) {
        if Thread.isMainThread {
            task()
        } else {
            DispatchQueue.main.sync {
                task()
            }
        }
        
    }
}
