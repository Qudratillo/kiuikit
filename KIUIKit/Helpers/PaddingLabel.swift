//
//  PaddingLabel.swift
//  KIUIKit
//
//  Created by Macbook on 9/27/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import Foundation

    @IBDesignable
    class PaddingLabel: UILabel {

        @IBInspectable var topInset: CGFloat = 4.0
        @IBInspectable var leftInset: CGFloat = 4.0
        @IBInspectable var bottomInset: CGFloat = 4.0
        @IBInspectable var rightInset: CGFloat = 4.0

        public init(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
               self.topInset = top
               self.rightInset = right
               self.bottomInset = bottom
               self.leftInset = left
               super.init(frame: .zero)
           }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var insets: UIEdgeInsets {
            get {
                return UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            }
            set {
                topInset = newValue.top
                leftInset = newValue.left
                bottomInset = newValue.bottom
                rightInset = newValue.right
            }
        }

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var adjSize = super.sizeThatFits(size)
            adjSize.width += leftInset + rightInset
            adjSize.height += topInset + bottomInset
            return adjSize
        }

        override var intrinsicContentSize: CGSize {
            let systemContentSize = super.intrinsicContentSize
            let adjustSize = CGSize(width: systemContentSize.width + leftInset + rightInset,
                                    height: systemContentSize.height + topInset +  bottomInset)
            
            if adjustSize.width > preferredMaxLayoutWidth && preferredMaxLayoutWidth != 0 {
                let constraintSize = CGSize(width: bounds.width - (leftInset + rightInset),
                                            height: .greatestFiniteMagnitude)
                let newSize = super.sizeThatFits(constraintSize)
                return CGSize(width: systemContentSize.width,
                              height: ceil(newSize.height) + topInset + bottomInset)
            } else {
                return adjustSize
            }
        }

        override func drawText(in rect: CGRect) {
            super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        }
    }
