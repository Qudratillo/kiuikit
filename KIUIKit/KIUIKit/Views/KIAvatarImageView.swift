//
//  AvatarImageView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/9/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

class KIAvatarImageView: KICircleImageView {
    
    public static var colors: [UIColor] = [#colorLiteral(red: 1, green: 0.3300932944, blue: 0.2421161532, alpha: 1), #colorLiteral(red: 1, green: 0.6498119235, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1), #colorLiteral(red: 0.3430494666, green: 0.8636034131, blue: 0.467017293, alpha: 1), #colorLiteral(red: 0.4119389951, green: 0.8247622848, blue: 0.9853010774, alpha: 1), #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1), #colorLiteral(red: 0.4212433696, green: 0.4374559522, blue: 0.8710277677, alpha: 1), #colorLiteral(red: 1, green: 0.2842617035, blue: 0.4058894515, alpha: 1)] {
        didSet {
            KIAvatarImageView.gradientColors = KIAvatarImageView.makeGradientColors(colors: KIAvatarImageView.colors)
        }
    }
    private static var gradientColors: [[CGColor]] = KIAvatarImageView.makeGradientColors(colors: KIAvatarImageView.colors)
    
    private static func makeGradientColors(colors: [UIColor]) -> [[CGColor]] {
        return colors.compactMap({ (color) -> [CGColor] in
            return [color.withAlphaComponent(0.59).cgColor, color.cgColor]
        })
    }
    
    public var color: UIColor {
        if let gradientBase = gradientBase {
            return KIAvatarImageView.colors[gradientBase.remainderReportingOverflow(dividingBy: KIAvatarImageView.colors.count).partialValue]
        }
        return .black
    }
    
    public var gradientBase: Int? {
        didSet {
            OperationQueue.main.addOperation {
                if let gradientBase = self.gradientBase {
                    let colors = KIAvatarImageView.gradientColors[gradientBase.remainderReportingOverflow(dividingBy: KIAvatarImageView.gradientColors.count).partialValue]
                    if let gradientLayer = self.gradientLayer {
                        gradientLayer.colors = colors
                    }
                    else {
                        self.addGradientLayer(colors: colors)
                    }
                }
                else {
                    self.gradientLayer?.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
                }
                self.layer.layoutSublayers()
            }
        }
    }
    
    public var initialsText: String? {
        didSet {
            OperationQueue.main.addOperation {
                if let initialsText = self.initialsText {
                    var initials = ""
                    var isFirstEnd = false
                    for c in initialsText {
                        if c.isWhitespace {
                            if !initials.isEmpty {
                                isFirstEnd = true
                            }
                        }
                        else {
                            if initials.isEmpty {
                                initials.append(c)
                            }
                            else if isFirstEnd {
                                initials.append(c)
                                break
                            }
                        }
                    }
                    if let label = self.label {
                        label.text = initials
                    }
                    else {
                        self.addLabel(text: initials)
                    }
                }
                else {
                    self.label?.text = nil
                }
            }
        }
    }
    
    public override var image: UIImage? {
        didSet {
            if let _ = self.image {
                self.label?.isHidden = true
                self.gradientLayer?.isHidden = true
            }
            else {
                self.label?.isHidden = false
                self.gradientLayer?.isHidden = false
            }
        }
    }
    
    private var gradientLayer: CAGradientLayer?
    private var label: UILabel?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        self.initView()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.initView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.clipsToBounds = true
        self.updateSelfFrames()
        self.backgroundColor = .white
    }
    
    private func addGradientLayer(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 1]
        self.updateFrame(of: gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
    
    private func addLabel(text: String) {
        let label = UILabel()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.text = text
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        self.updateFrame(of: label)
        self.addSubview(label)
        self.label = label
    }
    
    
    private func updateFrame(of gradientLayer: CAGradientLayer) {
        gradientLayer.frame = self.bounds
    
    }
    
    private func updateFrame(of label: UILabel) {
        label.frame = self.bounds
        label.font = label.font.withSize(self.bounds.height * 0.4)
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = self.gradientLayer {
            self.updateFrame(of: gradientLayer)
        }
        if let label = self.label {
            self.updateFrame(of: label)
        }
        self.updateSelfFrames()
    }
    
    private func updateSelfFrames() {
        self.layer.cornerRadius = self.bounds.height/2
    }
}
