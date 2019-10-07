//
//  KIChatMessagesCollectionViewSectionHeader.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/20/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit
public class KIChatMessageSectionHeaderView: UICollectionReusableView {
    
    private let textLabel: UILabel = .init()
    
    public var viewModel: KIChatMessageSectionHeaderViewModel? {
        didSet {
            updateUI()
        }
    }
    
    public required init() {
        super.init(frame: .zero)
        self.clipsToBounds = true
        self.initView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.initView()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        textLabel.clipsToBounds = true
        textLabel.textAlignment = .center
        textLabel.baselineAdjustment = .alignCenters
        textLabel.backgroundColor = .init(white: 0, alpha: 0.6)
        textLabel.textColor = .white
        textLabel.font = KIChatMessageSectionHeaderViewModel.textFont
        textLabel.layer.cornerRadius = KIChatMessageSectionHeaderViewModel.textFont.lineHeight / 2 + 2
        addSubview(textLabel)
        
    }
    
    public func updateUI() {
        if let viewModel = viewModel {
            self.isHidden = false
            self.updateUI(with: viewModel)
        }
        else {
            self.isHidden = true
        }
    }
    
    func updateUI(with viewModel: KIChatMessageSectionHeaderViewModel) {
        textLabel.text = viewModel.text
        textLabel.frame = viewModel.textFrame
    }
}


public class KIChatMessageSectionHeaderViewModel: KISizeAwareViewModel {
    
    public static var textFont: UIFont = .systemFont(ofSize: 12)
    
    public var text: String
    private(set) var textFrame: CGRect = .zero
    
    public init(width: CGFloat, text: String) {
        self.text = text
        super.init(width: width, height: 40)
    }
    
    public override func updateFrames() {
        super.updateFrames()
        let size = KIActionMessageViewModel.textFont.size(ofSingleLineString: text)
        textFrame = .init(origin: .init(x: (width - size.width - 4)/2, y: (height - size.height - 4)/2), size: .init(width: size.width + 4, height: size.height + 4))
    }
}
