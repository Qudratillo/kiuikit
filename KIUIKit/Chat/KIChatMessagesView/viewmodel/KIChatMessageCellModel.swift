//
//  KIMessageCellModel.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/16/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KIChatMessageCellModel<MessageData, ViewModel: KISizeAwareViewModel>: KISizeAwareViewModel {
    
    public var viewModel: ViewModel
    public var messageData: MessageData
    
    public init(width: CGFloat, viewModel: ViewModel, messageData: MessageData) {
        self.viewModel = viewModel
        self.messageData = messageData
        
        super.init(width: width, height: 0)
    }
    
    public override func updateFrames() {
        super.updateFrames()
        viewModel.width = width
        viewModel.updateFrames()
        height = viewModel.height
    }
    
}
