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
