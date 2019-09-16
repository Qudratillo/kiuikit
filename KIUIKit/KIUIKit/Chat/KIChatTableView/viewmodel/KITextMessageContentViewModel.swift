//
//  KITextMessageContentViewModel.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/11/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public enum KIMessageStatus {
    case seen
    case sent
    case pending
}

public enum KIMessageAttachmentViewModel {
    case image(imageAttachmentViewModel: KIMessageImageAttachmentViewModel)
    case detail(detailAttachmentViewModel: KIMessageDetailAttachmentViewModel)
}

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
        if case .image(let imageAttachmentViewModel)? = attachmentModel {
            imageAttachmentViewModel.width = width - 4
            imageAttachmentViewModel.updateFrames()
            width = imageAttachmentViewModel.width + 4
        }
        
        var height: CGFloat = 2
        
        if nameText == nil {
            nameTextFrame = .zero
        } else {
            nameTextFrame = .init(x: KITextMessageContentViewModel.textMarginX, y: height + 6, width: width - KITextMessageContentViewModel.textMarginX * 2, height: KITextMessageContentViewModel.nameTextFont.lineHeight)
            height = nameTextFrame.maxY
        }
        
        if forwardedFromText == nil {
            forwardedFromTextFrame = .zero
        } else {
            forwardedFromTextFrame = .init(x: KITextMessageContentViewModel.textMarginX, y: height + 6, width: width - KITextMessageContentViewModel.textMarginX * 2, height: KITextMessageContentViewModel.forwardedFromTextFont.lineHeight)
            height = forwardedFromTextFrame.maxY
        }
        
        if let replyModel = replyModel {
            replyModel.width = width - 2 * KITextMessageContentViewModel.textMarginX
            replyModel.updateFrames()
            replyFrame = .init(x: KITextMessageContentViewModel.textMarginX, y: height + 6, width: replyModel.width, height: replyModel.height)
            height = replyFrame.maxY
        } else {
            replyFrame = .zero
        }
        
        if let attachmentModel = attachmentModel {
            switch attachmentModel {
            case .image(let imageAttachmentViewModel):
                imageAttachmentFrame = .init(x: 2, y: height == 2 ? 2 : (height + 4), width: imageAttachmentViewModel.width, height: imageAttachmentViewModel.height)
                detailAttachmentFrame = .zero
                height = imageAttachmentFrame.maxY
            case .detail(let detailAttachmentViewModel):
                imageAttachmentFrame = .zero
                detailAttachmentViewModel.width = width
                detailAttachmentViewModel.updateFrames()
                detailAttachmentFrame = .init(x: 0, y: height + 6, width: detailAttachmentViewModel.width, height: detailAttachmentViewModel.height)
                height += detailAttachmentFrame.height + 6
            }
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
        
        
        if messageStatus != nil {
            messageStatusFrame = .init(x: 8, y: KITextMessageContentViewModel.messageStatusY, width: 14, height: 10)
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
        
        if textFrame.height == 0 {
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
}
