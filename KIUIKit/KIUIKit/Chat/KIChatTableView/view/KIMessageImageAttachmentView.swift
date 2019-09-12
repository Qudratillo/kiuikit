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
    private let actionImageView: UIImageView = .init()
    private let loadingIndicator: UIActivityIndicatorView = .init(style: .white)
    private let metaTextContainer: UIView = .init()
    private let metaTextLabel: KIPaddingLabel = .init()
    
    
    override func initView() {
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        actionWrap.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        actionWrap.clipsToBounds = true
        
        actionImageView.clipsToBounds = true
        actionWrap.addSubview(actionImageView)
        
        actionWrap.addSubview(loadingIndicator)

        addSubview(actionWrap)
        
        metaTextLabel.layer.cornerRadius = 2
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
            
            actionImageView.frame = viewModel.actionFrame
            loadingIndicator.frame = viewModel.actionFrame
            self.updateUI(with: viewModel.action)
        
            metaTextLabel.text = viewModel.metaText
            metaTextLabel.frame = viewModel.metaTextFrame
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
