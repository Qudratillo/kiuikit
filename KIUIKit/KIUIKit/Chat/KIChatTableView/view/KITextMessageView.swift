//
//  KITextMessageView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/11/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KITextMessageView: KIView<KITextMessageViewModel> {
    private let avatar: KIAvatarImageView = .init()
    private let containerView: UIView = .init()
    private let contentView: KITextMessageContentView = .init()
    
    
    
    override func initView() {
        addSubview(avatar)
        
        containerView.clipsToBounds = true
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 0.2
        containerView.layer.cornerRadius = 16
        addSubview(containerView)
        
        containerView.addSubview(contentView)
    }
    
    override func updateUI(with viewModel: KITextMessageViewModel) {
        if let avatarImageData = viewModel.avatarImageData {
            KIConfig.set(imageView: avatar, with: avatarImageData)
            avatar.isHidden = false
            avatar.frame = viewModel.avatarFrame
            avatar.initialsText = viewModel.avatarInitialsText
            avatar.gradientBase = viewModel.avatarGradientBase
        }
        else {
            avatar.isHidden = true
        }
        
        containerView.frame = viewModel.containerFrame
        containerView.backgroundColor = viewModel.containerBackgroundColor
        
        viewModel.contentModel.nameTextColor = avatar.color?.darker(by: 10.0)
        
        contentView.viewModel = viewModel.contentModel
        contentView.frame = .init(origin: .init(x: 0, y: 0), size: viewModel.contentModel.size)
        
        
    }
    
    
}
