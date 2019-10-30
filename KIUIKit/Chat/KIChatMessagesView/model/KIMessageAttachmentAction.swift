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

extension KIMessageAttachmentAction: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        var lhv: Int
        switch lhs {
        case .download:
            lhv = 1
        case .play:
            lhv = 2
        case .pause:
            lhv = 3
        case .cancel:
            lhv = 4
        case .action(let image):
            if case let .action(rImage) = rhs, image == rImage {
                return true
            } else {
                return false
            }
        case .loading:
            lhv = 5
        case .none:
            lhv = 0
        }
        
        switch rhs {
        case .download:
            return lhv == 1
        case .play:
            return lhv == 2
        case .pause:
            return lhv == 3
        case .cancel:
            return lhv == 4
        case .action(let image):
            if case let .action(rImage) = rhs, image == rImage {
                return true
            } else {
                return false
            }
        case .loading:
            return lhv == 5
        case .none:
            return lhv == 0
        }
    }
}
