//
//  KIActionMessageView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/16/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIActionMessageView: KIView<KIActionMessageViewModel> {
    
    private let textLabel: KIPaddingLabel = .init()
    private let imageView: KICircleImageView = .init()
    
    override func initView() {
        textLabel.font = KIActionMessageViewModel.textFont
        textLabel.textColor = .white
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.layer.cornerRadius = (KIActionMessageViewModel.textFont.lineHeight + 8)/2
        textLabel.clipsToBounds = true
        textLabel.backgroundColor = .init(white: 0, alpha: 0.5)
        textLabel.topInset = 4
        textLabel.bottomInset = 4
        textLabel.rightInset = 8
        textLabel.leftInset = 8
        addSubview(textLabel)
        
        addSubview(imageView)
    }
    
    override func updateUI(with viewModel: KIActionMessageViewModel) {
        textLabel.text = viewModel.text
        textLabel.frame = viewModel.textFrame
        
        if let imageData = viewModel.imageData {
            imageView.isHidden = false
            KIConfig.set(imageView: imageView, with: imageData)
            imageView.frame = viewModel.imageFrame
        } else {
            imageView.isHidden = true
        }
    }
    
}

public class KIActionMessageViewModel: KISizeAwareViewModel, KIMessageViewModel  {
    
    public static var textFont: UIFont = .systemFont(ofSize: 14)
    
    public var text: String
    private(set) var textFrame: CGRect = .zero
    public var imageData: KIImageData?
    private(set) var imageFrame: CGRect = .zero
    
    public init(width: CGFloat = 0, text: String, imageData: KIImageData?) {
        self.text = text
        self.imageData = imageData
        super.init(width: width, height: 0)
    }
    
    public override func updateFrames() {
        super.updateFrames()
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
