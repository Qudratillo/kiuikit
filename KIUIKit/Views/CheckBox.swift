//
//  CheckBox.swift
//  KIUIKit
//
//  Created by Macbook on 1/18/20.
//  Copyright © 2020 Kudratillo Ismatov. All rights reserved.
//

import Foundation
import UIKit

public class CheckBox: UIView {
    public var borderWidth: CGFloat = 1.75
    
    public var checkmarkSize: CGFloat = 0.5
    
    var checkboxBackgroundColor: UIColor! = .white
    var checkmarkColor: UIColor =  #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    
    private(set) var isChecked: Bool = false {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.borderWidth = borderWidth
        layer.borderColor = checkmarkColor.cgColor
        layer.cornerRadius = frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        let newRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        let shapePath = UIBezierPath.init(ovalIn: newRect)
        let layer = CAShapeLayer()
        layer.anchorPoint = CGPoint.zero
        layer.path = shapePath.cgPath
        layer.bounds = (layer.path?.boundingBox)!
        layer.fillColor = checkboxBackgroundColor.cgColor
        layer.addSublayer(layer)
        drawCheckMark(frame: newRect)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        isChecked = !isChecked
        guard let point = touch?.location(in: self) else { return }
        guard let sublayers = self.layer.sublayers as? [CAShapeLayer] else { return }

        for layer in sublayers {
            if let path = layer.path, path.contains(point) {
                layer.fillColor = isChecked ? UIColor.clear.cgColor : checkboxBackgroundColor.cgColor
            }
        }
    }
    
    private func drawCheckMark(frame: CGRect) {
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.26000 * frame.width,
                                    y: frame.minY + 0.50000 * frame.height))
        
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42000 * frame.width,
                                        y: frame.minY + 0.62000 * frame.height),
                            controlPoint1: CGPoint(x: frame.minX + 0.38000 * frame.width,
                                                   y: frame.minY + 0.60000 * frame.height),
                            controlPoint2: CGPoint(x: frame.minX + 0.42000 * frame.width,
                                                   y: frame.minY + 0.62000 * frame.height))
        
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70000 * frame.width, y: frame.minY + 0.24000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.78000 * frame.width, y: frame.minY + 0.30000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height))
        
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.20000 * frame.width, y: frame.minY + 0.58000 * frame.height),
                            controlPoint1: CGPoint(x: frame.minX + 0.44000 * frame.width,
                                                   y: frame.minY + 0.76000 * frame.height),
                            controlPoint2: CGPoint(x: frame.minX + 0.26000 * frame.width,
                                                   y: frame.minY + 0.62000 * frame.height))
        checkmarkColor.setFill()
        bezierPath.fill()
    }
    
}
