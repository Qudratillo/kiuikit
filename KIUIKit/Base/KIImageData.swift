//
//  KIImageData.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/10/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public enum KIImageData {
    case image(image: UIImage?)
    case url(url: URL)
    case urlString(urlString: String)
    case other(object: Any)
    case empty
}
