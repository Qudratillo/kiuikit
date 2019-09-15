//
//  KIMessageDetailAttachmentView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/12/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIMessageDetailAttachmentView: KIView<KIMessageDetailAttachmentViewModel>  {
    private let imageView: KIAvatarImageView = .init()
    private let actionWrap: UIView = .init()
    private let actionImageView: UIImageView = .init()
    private let loadingIndicator: UIActivityIndicatorView = .init(style: .white)
    private let topTextLabel: UILabel = .init()
    private let bottomTextLabel: UILabel = .init()
    private let slider: UISlider = .init()
    
    override func initView() {
        imageView.frame = .init(x: KIMessageDetailAttachmentViewModel.leftPadding, y: 0, width: 40, height: 40)
        addSubview(imageView)
        
        
        actionWrap.backgroundColor = KIConfig.accentColor
        actionWrap.clipsToBounds = true
        actionWrap.layer.cornerRadius = 20
        actionWrap.frame = .init(x: KIMessageDetailAttachmentViewModel.leftPadding, y: 0, width: 40, height: 40)
        
        actionImageView.frame = .init(x: 8, y: 8, width: 24, height: 24)
        actionImageView.clipsToBounds = true
        actionWrap.addSubview(actionImageView)
        
        loadingIndicator.frame = .init(x: 0, y: 0, width: 40, height: 40)
        actionWrap.addSubview(loadingIndicator)
        
        addSubview(actionWrap)
        
        topTextLabel.font = KIMessageDetailAttachmentViewModel.topTextFont
        topTextLabel.numberOfLines = 1
        addSubview(topTextLabel)
        
        bottomTextLabel.font = KIMessageDetailAttachmentViewModel.bottomTextFont
        bottomTextLabel.numberOfLines = 1
        bottomTextLabel.textColor = KIConfig.secondaryTextColor
        addSubview(bottomTextLabel)
        
        slider.clipsToBounds = true
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        addSubview(slider)
    }
    
    override func updateUI(with viewModel: KIMessageDetailAttachmentViewModel) {
        KIConfig.set(imageView: imageView, with: viewModel.imageData)
        imageView.gradientBase = viewModel.imageGradientBase
        imageView.initialsText = viewModel.imageInitialsText
        self.updateUI(with: viewModel.action)
        
        topTextLabel.text = viewModel.topText
        topTextLabel.frame = viewModel.topTextFrame
        
        bottomTextLabel.text = viewModel.bottomText
        bottomTextLabel.frame = viewModel.bottomeTextFrame
        
        slider.frame = viewModel.sliderFrame
        slider.value = viewModel.sliderValue
    }
    
    public func updateUI(with action: KIMessageAttachmentAction) {
        switch action {
        case .download:
            actionImageView.image = UIImage(named: "action_download")
            actionImageView.isHidden = false
            loadingIndicator.stopAnimating()
        case .play:
            actionImageView.image = UIImage(named: "action_play")
            actionImageView.isHidden = false
            loadingIndicator.stopAnimating()
        case .action(let image):
            actionImageView.image = image
            actionImageView.isHidden = false
            loadingIndicator.stopAnimating()
        case .loading:
            actionImageView.isHidden = true
            loadingIndicator.startAnimating()
            
        case .none:
            actionWrap.isHidden = true
        }
        
    }
}
