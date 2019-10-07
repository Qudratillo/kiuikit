//
//  KIMessageImageAttachmentView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/11/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIMessageImageAttachmentView: KIView<KIMessageImageAttachmentViewModel> {
    
    private let imageView: UIImageView = .init()
    private let actionWrap: UIView = .init()
    let actionImageView: UIImageView = .init()
    private let loadingIndicator: UIActivityIndicatorView = .init(activityIndicatorStyle: .white)
    private let metaTextContainer: UIView = .init()
    private let metaTextLabel: KIPaddingLabel = .init()
    
    
    override func initView() {
        
        self.layer.cornerRadius = 14
        self.clipsToBounds = true
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        actionWrap.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        actionWrap.clipsToBounds = true
        
        actionImageView.clipsToBounds = true
        actionImageView.frame = .init(x: 0, y: 0, width: KIMessageImageAttachmentViewModel.actionSize, height: KIMessageImageAttachmentViewModel.actionSize)
        actionImageView.contentMode = .center
        actionImageView.isUserInteractionEnabled = true
        actionImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAction)))
        actionWrap.addSubview(actionImageView)
        
        
        loadingIndicator.frame = .init(x: 0, y: 0, width: KIMessageImageAttachmentViewModel.actionSize, height: KIMessageImageAttachmentViewModel.actionSize)
        actionWrap.addSubview(loadingIndicator)

        addSubview(actionWrap)
        
        metaTextLabel.layer.cornerRadius = 4
        metaTextLabel.clipsToBounds = true
        metaTextLabel.topInset = 4
        metaTextLabel.bottomInset = 4
        metaTextLabel.leftInset = 6
        metaTextLabel.rightInset = 6
        metaTextLabel.numberOfLines = 1
        metaTextLabel.font = KIMessageImageAttachmentViewModel.metaTextFont
        metaTextLabel.textColor = .white
        metaTextLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        addSubview(metaTextLabel)
    }
    
    override func updateUI(with viewModel: KIMessageImageAttachmentViewModel) {
        
            imageView.frame = .init(x: 0, y: 0, width: viewModel.width, height: viewModel.height)
            KIConfig.set(imageView: imageView, with: viewModel.imageData)
           
            actionWrap.frame = viewModel.actionWrapFrame
            actionWrap.layer.cornerRadius = viewModel.actionWrapFrame.width/2
        
            self.updateUI(with: viewModel.action)
        
            metaTextLabel.text = viewModel.metaText
            metaTextLabel.frame = viewModel.metaTextFrame
    }
    
    public func updateUI(with action: KIMessageAttachmentAction) {
        switch action {   
        case .download:
            actionImageView.image = UIImage.resourceImage(for: self, named: "action_download")
            actionImageView.isHidden = false
            loadingIndicator.stopAnimating()
        case .play:
            actionImageView.image = UIImage.resourceImage(for: self, named: "action_play")
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
    
    @objc func didTapAction() {
        self.viewModel?.tapAction?()
    }
    
}

public class KIMessageAttachmentViewModel: KISizeAwareViewModel {
    
    public var action: KIMessageAttachmentAction
    
    
    private(set) var tapAction: (() -> Void)?
    
    public init(width: CGFloat,
                height: CGFloat,
                action: KIMessageAttachmentAction
        ) {
        self.action = action
        
        super.init(width: width, height: height)
    }
    
    func onTapAction(_ tap: @escaping () -> Void) {
        self.tapAction = tap
    }
}


public class KIMessageImageAttachmentViewModel: KIMessageAttachmentViewModel {
    
    public static var minWidth: CGFloat = 100
    public static var minHeight: CGFloat = 100
    
    
    public var imageData: KIImageData
    public static var actionSize: CGFloat = 40
    public static var metaTextFont: UIFont = .systemFont(ofSize: 12)
    
    private(set) var actionWrapFrame: CGRect = .zero
    
    public var whRatio: CGFloat
    public var metaText: String?
    private(set) var metaTextFrame: CGRect = .zero
    
    public init(width: CGFloat = 0,
                height: CGFloat = 0,
                whRatio: CGFloat,
                imageData: KIImageData,
                action: KIMessageAttachmentAction,
                metaText: String?
        ) {
        self.whRatio = whRatio
        self.imageData = imageData
        self.metaText = metaText
        
        super.init(width: width, height: height, action: action)
    }
    
    public override func updateFrames() {
        super.updateFrames()
        if self.whRatio >= 1 {
            self.height = max(self.width / self.whRatio, KIMessageImageAttachmentViewModel.minHeight)
        } else {
            self.width = max(self.height * self.whRatio, KIMessageImageAttachmentViewModel.minWidth)
        }
        
        actionWrapFrame = .init(x: (width - KIMessageImageAttachmentViewModel.actionSize)/2, y: (height - KIMessageImageAttachmentViewModel.actionSize)/2, width: KIMessageImageAttachmentViewModel.actionSize, height: KIMessageImageAttachmentViewModel.actionSize)
        if let metaText = metaText {
            let h = KIMessageImageAttachmentViewModel.metaTextFont.lineHeight
            let w = KIMessageImageAttachmentViewModel.metaTextFont.size(ofString: metaText, constrainedToHeight: h).width + 12
            metaTextFrame = .init(x: 6, y: 4, width: min(w, width - 20) , height: h + 8)
        } else {
            metaTextFrame = .zero
        }
    }
    
    
    
}
