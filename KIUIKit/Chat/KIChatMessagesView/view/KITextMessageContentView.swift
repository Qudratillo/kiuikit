//
//  KITextMessageContentView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/14/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KITextMessageContentView: KIView<KITextMessageContentViewModel> {
    private let nameLabel: UILabel = .init()
    private let forwardedFromTextLabel: UILabel = .init()
    private let replyMessageView: KIReplyMessageView = .init()
    private let imageAttachmentView: KIMessageImageAttachmentView = .init()
    private let detailAttachmentView: KIMessageDetailAttachmentView = .init()
    private let textLabel: UILabel = .init()
    private let timeView: UIView = .init()
    private let messageStatusImageView: UIImageView = .init()
    private let timeTextLabel: UILabel = .init()
    
    override func initView() {
        nameLabel.font = KITextMessageContentViewModel.nameTextFont
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapName)))
        addSubview(nameLabel)
        
        forwardedFromTextLabel.font = KITextMessageContentViewModel.forwardedFromTextFont
        forwardedFromTextLabel.textColor = KIConfig.primaryColor
        forwardedFromTextLabel.isUserInteractionEnabled = true
        forwardedFromTextLabel.numberOfLines = 0
        forwardedFromTextLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapForwarder)))
        addSubview(forwardedFromTextLabel)
        
        replyMessageView.isUserInteractionEnabled = true
        replyMessageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReply)))
        addSubview(replyMessageView)
        
        imageAttachmentView.isUserInteractionEnabled = true
        imageAttachmentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAttachment)))
        addSubview(imageAttachmentView)
        
        detailAttachmentView.isUserInteractionEnabled = true
        detailAttachmentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAttachment)))
        addSubview(detailAttachmentView)
        
        textLabel.font = KITextMessageContentViewModel.textFont
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        addSubview(textLabel)
        
        timeView.layer.cornerRadius = 4
        addSubview(timeView)
        
        messageStatusImageView.contentMode = .scaleAspectFit
        timeView.addSubview(messageStatusImageView)
        timeTextLabel.font = KITextMessageContentViewModel.timeTextFont
        timeView.addSubview(timeTextLabel)
    }
    
    override func updateUI(with viewModel: KITextMessageContentViewModel) {
        nameLabel.text = viewModel.nameText
        nameLabel.textColor = viewModel.nameTextColor ?? KIConfig.primaryColor
        nameLabel.frame = viewModel.nameTextFrame
        
        
        forwardedFromTextLabel.text = viewModel.forwardedFromText
        forwardedFromTextLabel.frame = viewModel.forwardedFromTextFrame
        
        replyMessageView.viewModel = viewModel.replyModel
        replyMessageView.frame = viewModel.replyFrame
        
        if let imageAttachmentViewModel = viewModel.attachmentModel as? KIMessageImageAttachmentViewModel {
            imageAttachmentView.viewModel = imageAttachmentViewModel
        } else if let detailAttachmentViewModel = viewModel.attachmentModel as? KIMessageDetailAttachmentViewModel {
            detailAttachmentView.viewModel = detailAttachmentViewModel
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
                messageStatusImageView.image = UIImage.resourceImage(for: self, named: "icon_seen")?.withRenderingMode(.alwaysTemplate)
            case .sent:
                messageStatusImageView.image = UIImage.resourceImage(for: self, named: "icon_sent")?.withRenderingMode(.alwaysTemplate)
            case .pending:
                messageStatusImageView.image = UIImage.resourceImage(for: self, named: "icon_pending")?.withRenderingMode(.alwaysTemplate)
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
    
    
    @objc func didTapName() {
        self.viewModel?.tapName?()
    }
    @objc func didTapAttachment() {
        self.viewModel?.tapAttachment?()
    }
    @objc func didTapForwarder() {
        self.viewModel?.tapForwarder?()
    }
 
    @objc func didTapReply() {
        self.viewModel?.tapReply?()
    }
}


public enum KIMessageStatus {
    case seen
    case sent
    case pending
}

//public enum KIMessageAttachmentViewModel {
//    case image(imageAttachmentViewModel: KIMessageImageAttachmentViewModel)
//    case detail(detailAttachmentViewModel: KIMessageDetailAttachmentViewModel)
//}

public class KITextMessageContentViewModel: KISizeAwareViewModel {
    
    public static var nameTextFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .bold)
    public static var forwardedFromTextFont: UIFont = .systemFont(ofSize: 15, weight: .semibold)
    public static var textFont: UIFont = .systemFont(ofSize: 15)
    public static var timeTextFont: UIFont = .systemFont(ofSize: 12)
    public static var timeFrameHeight: CGFloat = KITextMessageContentViewModel.timeTextFont.lineHeight + 4
    public static var messageStatusY: CGFloat = (KITextMessageContentViewModel.timeFrameHeight - 10) / 2
    public static var textMarginX: CGFloat = 8
    
    public var nameText: String?
    public var nameTextColor: UIColor?
    private(set) var nameTextFrame: CGRect = .zero
    public var forwardedFromText: String?
    private(set) var forwardedFromTextFrame: CGRect = .zero
    public var replyModel: KIReplyMessageViewModel?
    private(set) var replyFrame: CGRect = .zero
    public var attachmentModel: KIMessageAttachmentViewModel?
    private(set) var imageAttachmentFrame: CGRect = .zero
    private(set) var detailAttachmentFrame: CGRect = .zero
    public var text: String?
    private(set) var textFrame: CGRect = .zero
    public var messageStatus: KIMessageStatus?
    public var timeText: String
    private(set) var timeFrame: CGRect = .zero
    private(set) var messageStatusFrame: CGRect = .zero
    private(set) var timeTextFrame: CGRect = .zero
    private(set) var timeBackgroundColor: UIColor = .clear
    private(set) var timeTextColor: UIColor = .black
    private(set) var messageStatusColor: UIColor = KIConfig.primaryColor
    
    fileprivate var tapName: (() -> Void)?
    fileprivate var tapAttachment: (() -> Void)?
    fileprivate var tapForwarder: (() -> Void)?
    fileprivate var tapReply: (() -> Void)?
    
    
    public init(
        width: CGFloat = 0,
        nameText: String?,
        nameTextColor: UIColor? = nil,
        forwardedFromText: String?,
        replyModel: KIReplyMessageViewModel?,
        attachmentModel: KIMessageAttachmentViewModel?,
        text: String?,
        messageStatus: KIMessageStatus?,
        timeText: String
        ) {
        self.nameText = nameText
        self.nameTextColor = nameTextColor
        self.forwardedFromText = forwardedFromText
        self.replyModel = replyModel
        self.attachmentModel = attachmentModel
        self.text = text
        self.messageStatus = messageStatus
        self.timeText = timeText
        super.init(width: width, height: 0)
    }
    
    public override func updateFrames() {
        super.updateFrames()
        if let imageAttachmentViewModel = attachmentModel as? KIMessageImageAttachmentViewModel {
            imageAttachmentViewModel.width = width - 4
            imageAttachmentViewModel.height = width - 4
            imageAttachmentViewModel.updateFrames()
            width = imageAttachmentViewModel.width + 4
        }
        
        var height: CGFloat = 2
        
        if let nameText = nameText {
            nameTextFrame = .init(origin: .init(x: KITextMessageContentViewModel.textMarginX, y: height + 6), size: KITextMessageContentViewModel.nameTextFont.size(ofString: nameText, constrainedToWidth: width - KITextMessageContentViewModel.textMarginX * 2))
            height = nameTextFrame.maxY
        } else {
            nameTextFrame = .zero
        }
        
        if let forwardedFromText = forwardedFromText {
            forwardedFromTextFrame = .init(origin: .init(x: KITextMessageContentViewModel.textMarginX, y: height + 6), size: KITextMessageContentViewModel.forwardedFromTextFont.size(ofString: forwardedFromText, constrainedToWidth: width - KITextMessageContentViewModel.textMarginX * 2))
            height = forwardedFromTextFrame.maxY
        } else {
            forwardedFromTextFrame = .zero
        }
        
        if let replyModel = replyModel {
            replyModel.width = width - 2 * KITextMessageContentViewModel.textMarginX
            replyModel.updateFrames()
            replyFrame = .init(x: KITextMessageContentViewModel.textMarginX, y: height + 6, width: replyModel.width, height: replyModel.height)
            height = replyFrame.maxY
        } else {
            replyFrame = .zero
        }
        
        if let imageAttachmentViewModel = attachmentModel as? KIMessageImageAttachmentViewModel {
            imageAttachmentFrame = .init(x: 2, y: height == 2 ? 2 : (height + 4), width: imageAttachmentViewModel.width, height: imageAttachmentViewModel.height)
            detailAttachmentFrame = .zero
            height = imageAttachmentFrame.maxY
        } else if let detailAttachmentViewModel = attachmentModel as? KIMessageDetailAttachmentViewModel {
            imageAttachmentFrame = .zero
            detailAttachmentViewModel.width = width
            detailAttachmentViewModel.updateFrames()
            detailAttachmentFrame = .init(x: 0, y: height + 6, width: detailAttachmentViewModel.width, height: detailAttachmentViewModel.height)
            height += detailAttachmentFrame.height + 6
        } else {
            imageAttachmentFrame = .zero
            detailAttachmentFrame = .zero
        }
        
        if let text = text {
            textFrame = .init(origin: .init(x: KITextMessageContentViewModel.textMarginX, y: height + 6), size: KITextMessageContentViewModel.textFont.size(ofString: text, constrainedToWidth: width - KITextMessageContentViewModel.textMarginX * 2))
            height = textFrame.maxY
        }
        else {
            textFrame = .zero
        }
        
        if imageAttachmentFrame.width == 0 {
            width = max(nameTextFrame.width + KITextMessageContentViewModel.textMarginX * 2, forwardedFromTextFrame.width + KITextMessageContentViewModel.textMarginX * 2, replyFrame.width + KITextMessageContentViewModel.textMarginX * 2, detailAttachmentFrame.width, textFrame.width + KITextMessageContentViewModel.textMarginX * 2, 90)
        }
        
        
        if messageStatus != nil {
            messageStatusFrame = .init(x: 8, y: KITextMessageContentViewModel.messageStatusY, width: 12, height: 12)
            timeTextFrame = .init(x: 22, y: 2, width: KITextMessageContentViewModel.timeTextFont.size(ofString: timeText, constrainedToHeight: KITextMessageContentViewModel.timeTextFont.lineHeight).width, height: KITextMessageContentViewModel.timeTextFont.lineHeight)
        } else {
            messageStatusFrame = .zero
            timeTextFrame = .init(x: 8, y: 2, width: KITextMessageContentViewModel.timeTextFont.size(ofString: timeText, constrainedToHeight: KITextMessageContentViewModel.timeTextFont.lineHeight).width, height: KITextMessageContentViewModel.timeTextFont.lineHeight)
        }
        
        let tw = messageStatusFrame.width + timeTextFrame.width + 16
        
        
        if textFrame.height == 0 && imageAttachmentFrame.height != 0 {
            setTimeDark()
            
        } else {
            setTimeLight()
            
        }
        
        if textFrame.height == 0 && imageAttachmentFrame.height != 0 {
            timeFrame = .init(x: width - tw - 6, y: height - KITextMessageContentViewModel.timeFrameHeight - 4, width: tw, height: KITextMessageContentViewModel.timeFrameHeight)
        }
        else {
            timeFrame = .init(x: width - tw - 2, y: height, width: tw, height: KITextMessageContentViewModel.timeFrameHeight)
            height += timeFrame.height
        }
        
        
        self.height = height + 2
    }
    
    private func setTimeLight() {
        timeBackgroundColor = .clear
        timeTextColor = .gray
        messageStatusColor = KIConfig.primaryColor
    }
    
    private func setTimeDark() {
        timeBackgroundColor = .init(white: 0, alpha: 0.4)
        timeTextColor = .white
        messageStatusColor = .white
    }
    
    
    func onTapName(_ tap: @escaping () -> Void) {
        self.tapName = tap
    }
    
    func onTapAttachment(_ tap: @escaping () -> Void) {
        self.tapAttachment = tap
    }
    
    func onTapForwarder(_ tap: @escaping () -> Void) {
        self.tapForwarder = tap
    }
    
    func onTapReply(_ tap: @escaping () -> Void) {
        self.tapReply = tap
    }
}
