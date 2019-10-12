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
    let actionImageView: UIImageView = .init()
    private let loadingIndicator: UIActivityIndicatorView = .init(activityIndicatorStyle: .white)
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
        
        actionImageView.frame = .init(x: 0, y: 0, width: 40, height: 40)
        actionImageView.contentMode = .center
        actionImageView.clipsToBounds = true
        actionImageView.isUserInteractionEnabled = true
        actionImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAction)))
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
        slider.setThumbImage(UIImage.resourceImage(for: self, named: "slider_thumb"), for: .normal)
        addSubview(slider)
    }
    
    override func updateUI(with viewModel: KIMessageDetailAttachmentViewModel) {
        if let imageData = viewModel.imageData {
            KIConfig.set(imageView: imageView, with: imageData)
            imageView.gradientBase = viewModel.imageGradientBase
            imageView.initialsText = viewModel.imageInitialsText
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
        
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
        case .loading:
            actionImageView.isHidden = true
            loadingIndicator.startAnimating()
        case .none:
            actionWrap.isHidden = true
        default:
            actionImageView.image = action.image(for: self)
            actionImageView.isHidden = false
            loadingIndicator.stopAnimating()
            
        }
    }
    
    @objc func didTapAction() {
        if let viewModel = viewModel {
            viewModel.tapAction?(viewModel.action)
        }
    }
}

// MARK: ViewModel
public class KIMessageDetailAttachmentViewModel: KIMessageAttachmentViewModel {
    public static var leftPadding: CGFloat = 10
    public static var topTextFont: UIFont = .systemFont(ofSize: 15, weight: .semibold)
    public static var bottomTextFont: UIFont = .systemFont(ofSize: 13)
    
    
    public var imageData: KIImageData?
    public var imageGradientBase: Int?
    public var imageInitialsText: String?
    public var topText: String?
    private(set) var topTextFrame: CGRect = .zero
    public var bottomText: String?
    private(set) var bottomeTextFrame: CGRect = .zero
    public var sliderValue: Float
    private(set) var sliderFrame: CGRect = .zero
    
    
    public init(
        width: CGFloat = 0,
        action: KIMessageAttachmentAction,
        imageData: KIImageData?,
        imageGradientBase: Int?,
        imageInitialsText: String?,
        topText: String?,
        bottomText: String?,
        sliderValue: Float
        ) {
        self.imageData = imageData
        self.imageGradientBase = imageGradientBase
        self.imageInitialsText = imageInitialsText
        self.topText = topText
        self.bottomText = bottomText
        self.sliderValue = sliderValue
        
        super.init(width: width, height: 0, action: action)
    }
    
    public override func updateFrames() {
        super.updateFrames()
        if topText == nil {
            topTextFrame = .zero
            sliderFrame = .init(x: 48 + KIMessageDetailAttachmentViewModel.leftPadding, y: 0, width: width - 48 - KIMessageDetailAttachmentViewModel.leftPadding, height: 20)
        } else {
            topTextFrame = .init(x: 48 + KIMessageDetailAttachmentViewModel.leftPadding, y: 0, width: width - 48 - KIMessageDetailAttachmentViewModel.leftPadding, height: 20)
            sliderFrame = .zero
        }
        
        bottomeTextFrame = .init(x: 48 + KIMessageDetailAttachmentViewModel.leftPadding, y: 20, width: width - 48 - KIMessageDetailAttachmentViewModel.leftPadding, height: 20)
        height = 40
    }
    
}
