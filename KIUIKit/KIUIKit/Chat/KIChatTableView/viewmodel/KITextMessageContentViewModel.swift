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
    
    public static var forwardedFromTextFont: UIFont = .systemFont(ofSize: 15, weight: .semibold)
    public static var textFont: UIFont = .systemFont(ofSize: 15)
    public static var timeTextFont: UIFont = .systemFont(ofSize: 12)
    public static var timeFrameHeight: CGFloat = KITextMessageContentViewModel.timeTextFont.lineHeight + 4
    public static var messageStatusY: CGFloat = (KITextMessageContentViewModel.timeFrameHeight - 10) / 2
    public static var textLeftMargin: CGFloat = 2
    
    
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
        width: CGFloat,
        forwardedFromText: String?,
        replyModel: KIReplyMessageViewModel?,
        attachmentModel: KIMessageAttachmentViewModel?,
        text: String?,
        messageStatus: KIMessageStatus?,
        timeText: String
        ) {
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
            width = imageAttachmentViewModel.width
        }
        
        var height: CGFloat = 0
        if forwardedFromText == nil {
            forwardedFromTextFrame = .zero
        } else {
            forwardedFromTextFrame = .init(x: KITextMessageContentViewModel.textLeftMargin, y: 0, width: width, height: KITextMessageContentViewModel.forwardedFromTextFont.lineHeight)
            height += KITextMessageContentViewModel.forwardedFromTextFont.lineHeight
        }
        
        if let replyModel = replyModel {
            replyFrame = .init(x: 0, y: height, width: replyModel.width, height: replyModel.height)
            height += replyFrame.height
        } else {
            replyFrame = .zero
        }
        
        if let attachmentModel = attachmentModel {
            switch attachmentModel {
            case .image(let imageAttachmentViewModel):
                imageAttachmentFrame = .init(x: 0, y: height, width: imageAttachmentViewModel.width, height: imageAttachmentViewModel.height)
                detailAttachmentFrame = .zero
                height += imageAttachmentFrame.height
            case .detail(let detailAttachmentViewModel):
                imageAttachmentFrame = .zero
                detailAttachmentFrame = .init(x: 0, y: height, width: detailAttachmentViewModel.width, height: detailAttachmentViewModel.height)
                height += detailAttachmentFrame.height
            }
        } else {
            imageAttachmentFrame = .zero
            detailAttachmentFrame = .zero
        }
        
        if let text = text {
            textFrame = .init(origin: .init(x: KITextMessageContentViewModel.textLeftMargin, y: height), size: KITextMessageContentViewModel.textFont.size(ofString: text, constrainedToWidth: width))
            height += textFrame.height
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
            timeFrame = .init(x: width - tw - 2, y: height - KITextMessageContentViewModel.timeFrameHeight - 2, width: tw, height: KITextMessageContentViewModel.timeFrameHeight)
        }
        else {
            timeFrame = .init(x: width - tw - 2, y: height, width: tw, height: KITextMessageContentViewModel.timeFrameHeight)
            height += timeFrame.height
        }
        
        
        self.height = height
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
