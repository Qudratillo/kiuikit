//
//  KITextMessageView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/11/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIMessageView<ViewModel: KIMessageViewModel>: KIView<ViewModel> {
    func updateContainerFrame() {}
}

public class KITextMessageView: KIMessageView<KITextMessageViewModel> {
    private let avatar: KIAvatarImageView = .init()
    private let containerView: UIView = .init()
    private let contentView: KITextMessageContentView = .init()
    let selectionVeiw: UIView = .init()
    let checkBox: CheckBox = .init()
    
    override func initView() {
        addSubview(checkBox)
        
        addSubview(avatar)
        
        containerView.clipsToBounds = true
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 0.5
        containerView.layer.cornerRadius = 16
        addSubview(containerView)
        
        containerView.addSubview(contentView)
        
        selectionVeiw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectMessage)))
        addSubview(selectionVeiw)
    }
    
    override func updateContainerFrame() {
        if let viewModel = self.viewModel {
            containerView.frame = viewModel.containerFrame
        }
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
        
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAvatar)))
        
        checkBox.frame = viewModel.checkBoxFrame
        self.selectionVeiw.frame = viewModel.selectionViewFrame
    }
    
    @objc func selectMessage() {
        checkBox.checkMarkClicked()
    }
    
    @objc func didTapAvatar() {
        self.viewModel?.tapAvatar?()
    }
    
}


public protocol KIMessageViewModel: KISizeAwareViewModel {
    func updateContainerFrame()
}

public extension KIMessageViewModel {
    func updateContainerFrame() {}
}

public enum KIMessageContainerLocation {
    case right
    case left
}

public class KITextMessageViewModel: KISizeAwareViewModel, KIMessageViewModel {
    
    public override var isEdited: Bool {
        set {
            super.isEdited = newValue
        }
        get {
            return super.isEdited || contentModel.isEdited
        }
    }
    
    public var isEditing: Bool = false {
        didSet {
            checkBoxWidth = isEditing ? 40 : 0
            
        }
    }
    private(set) var checkBoxWidth: CGFloat = 0
    private(set) var checkBoxFrame: CGRect = .zero
    private(set) var selectionViewFrame: CGRect = .zero
    
    public static var maxContainerOffset: CGFloat = 100
    public static var maxContainerWidth: CGFloat = 400
    
    public static var leftMessageContainerColor: UIColor = .white
    public static var rightMessageContainerColor: UIColor = #colorLiteral(red: 0.9002717783, green: 0.9960784314, blue: 0.8971452887, alpha: 1)
    
    
    public var avatarImageData: KIImageData?
    public var avatarGradientBase: Int?
    public var avatarInitialsText: String?
    private(set) var avatarFrame: CGRect = .zero
    public var contentModel: KITextMessageContentViewModel
    public var containerLocation: KIMessageContainerLocation
    
    private(set) var containerFrame: CGRect = .zero
    private(set) var containerBackgroundColor: UIColor = .white
    
    fileprivate var tapAvatar: (() -> Void)?
    
    public init(
        width: CGFloat = 0,
        avatarImageData: KIImageData?,
        avatarGradientBase: Int?,
        avatarInitialsText: String?,
        contentModel: KITextMessageContentViewModel,
        containerLocation: KIMessageContainerLocation
        ) {
        self.avatarImageData = avatarImageData
        self.avatarGradientBase = avatarGradientBase
        self.avatarInitialsText = avatarInitialsText
        self.contentModel = contentModel
        self.containerLocation = containerLocation
        super.init(width: width, height: 0)
    }
    
    public func updateContainerFrame() {
        let containerWidth: CGFloat = contentModel.width
        let containerHeight: CGFloat = contentModel.height
        var xOffset: CGFloat = 0
        
        if avatarImageData != nil {
            xOffset = 44
        }
        
        switch containerLocation {
        case .right:
            containerFrame = .init(x: width - containerWidth - 12 - xOffset + checkBoxWidth,
                                   y: self.height - containerHeight - 1,
                                   width: containerWidth - checkBoxWidth,
                                   height: containerHeight)
            avatarFrame = .init(x: width - 8 - 40,
                                y: self.height - 40 - 1,
                                width: 40,
                                height: 40)
            containerBackgroundColor = KITextMessageViewModel.rightMessageContainerColor
        case .left:
            containerFrame = .init(x: 12 + xOffset + checkBoxWidth,
                                   y: self.height - containerHeight - 1,
                                   width: containerWidth - checkBoxWidth,
                                   height: containerHeight)
            avatarFrame = .init(x: 8 + checkBoxWidth,
                                y: self.height - 40 - 1,
                                width: 40,
                                height: 40)
            containerBackgroundColor = KITextMessageViewModel.leftMessageContainerColor
        }
        checkBoxFrame = isEditing ? CGRect(x: 8, y: (self.height - 26)/2, width: 26, height: 26) : .zero
        selectionViewFrame = isEditing ? CGRect(x: 0, y: 0, width: width, height: height) : .zero
    }
    
    public override func updateFrames() {
        super.updateFrames()
        contentModel.width = min(KITextMessageViewModel.maxContainerWidth, width - KITextMessageViewModel.maxContainerOffset)
        contentModel.updateFrames()
        
        self.height = max(contentModel.height, 40) + 2
        self.updateContainerFrame()
    }
    
    func onTapAvatar(_ tap: @escaping () -> Void) {
        self.tapAvatar = tap
    }
}
