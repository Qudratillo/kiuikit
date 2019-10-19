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
    case pause
    case cancel
    case action(image: UIImage?)
    case loading
    case none
}

extension KIMessageAttachmentAction {
    func image(for object: AnyObject) -> UIImage? {
        switch self {
        case .download:
            return UIImage.resourceImage(for: object, named: "action_download")
        case .play:
            return UIImage.resourceImage(for: object, named: "action_play")
        case .action(let image):
            return image
        case .loading:
            return nil
        case .none:
            return nil
        case .pause:
            return UIImage.resourceImage(for: object, named: "action_pause")
        case .cancel:
            return UIImage.resourceImage(for: object, named: "action_cancel")
        }
    }
}
