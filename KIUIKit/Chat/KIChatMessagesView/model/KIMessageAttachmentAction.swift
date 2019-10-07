//
//  KIMessageAttachmentAction.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 10/5/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import Foundation

public enum KIMessageAttachmentAction {
    case download
    case play
    case action(image: UIImage)
    case loading
    case none
}
