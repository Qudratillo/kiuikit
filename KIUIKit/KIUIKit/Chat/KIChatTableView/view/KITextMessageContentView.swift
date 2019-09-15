//
//  KITextMessageContentView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/14/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KITextMessageContentView: KIView<KITextMessageContentViewModel> {
    private let nameTextView: UILabel = .init()
    private let forwardedFromTextLabel: UILabel = .init()
    private let replyMessageView: KIReplyMessageView = .init()
    private let imageAttachmentView: KIMessageImageAttachmentView = .init()
    private let detailAttachmentView: KIMessageDetailAttachmentView = .init()
    private let textLabel: UILabel = .init()
    private let timeView: UIView = .init()
    private let messageStatusImageView: UIImageView = .init()
    private let timeTextLabel: UILabel = .init()
    
    override func initView() {
        nameTextView.font = KITextMessageContentViewModel.nameTextFont
        nameTextView.textColor = KIConfig.primaryColor
        addSubview(nameTextView)
        
        forwardedFromTextLabel.font = KITextMessageContentViewModel.forwardedFromTextFont
        forwardedFromTextLabel.textColor = KIConfig.primaryColor
        addSubview(forwardedFromTextLabel)
        
        addSubview(replyMessageView)
        addSubview(imageAttachmentView)
        addSubview(detailAttachmentView)
        
        textLabel.font = KITextMessageContentViewModel.textFont
        addSubview(textLabel)
        
        timeView.layer.cornerRadius = 4
        addSubview(timeView)
        
        timeView.addSubview(messageStatusImageView)
        timeTextLabel.font = KITextMessageContentViewModel.timeTextFont
        timeView.addSubview(timeTextLabel)
    }
    
    override func updateUI(with viewModel: KITextMessageContentViewModel) {
        nameTextView.text = viewModel.nameText
        nameTextView.frame = viewModel.nameTextFrame
        
        forwardedFromTextLabel.text = viewModel.forwardedFromText
        forwardedFromTextLabel.frame = viewModel.forwardedFromTextFrame
        
        replyMessageView.viewModel = viewModel.replyModel
        replyMessageView.frame = viewModel.replyFrame
        
        if let attachmentModel = viewModel.attachmentModel {
            switch attachmentModel {
            case .image(let imageAttachmentViewModel):
                imageAttachmentView.viewModel = imageAttachmentViewModel
            case .detail(let detailAttachmentViewModel):
                detailAttachmentView.viewModel = detailAttachmentViewModel
            }
        }
        imageAttachmentView.frame = viewModel.imageAttachmentFrame
        detailAttachmentView.frame = viewModel.detailAttachmentFrame
        
        textLabel.text = viewModel.text
        textLabel.frame = viewModel.textFrame
        
        timeView.frame = viewModel.timeFrame
        timeView.backgroundColor = viewModel.timeBackgroundColor

        
        if let messageStatus = viewModel.messageStatus {
            switch messageStatus {
            case .seen:
                messageStatusImageView.image = UIImage(named: "icon_seen")?.withRenderingMode(.alwaysTemplate)
            case .sent:
                messageStatusImageView.image = UIImage(named: "icon_sent")?.withRenderingMode(.alwaysTemplate)
            case .pending:
                messageStatusImageView.image = nil
            }
        }
        else {
            messageStatusImageView.image = nil
        }
        
        messageStatusImageView.frame = viewModel.messageStatusFrame
        messageStatusImageView.tintColor = viewModel.messageStatusColor
        
        timeTextLabel.text = viewModel.timeText
        timeTextLabel.frame = viewModel.timeTextFrame
        timeTextLabel.textColor = viewModel.timeTextColor
    }
}
