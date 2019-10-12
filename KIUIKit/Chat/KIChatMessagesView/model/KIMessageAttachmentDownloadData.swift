//
//  KIMessageAttachmentDownloadData.swift
//  KIUIKit
//
//  Created by Mister M on 10/12/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import Foundation

public class KIMessageAttachmentDownloadData {
    public var downloadWhenDisplay: Bool
    public var thumbnailLocation: String
    public var originalLocation: String
    
    public init(
        downloadWhenDisplay: Bool,
        thumbnailLocation: String,
        originalLocation: String
    ) {
        self.downloadWhenDisplay = downloadWhenDisplay
        self.thumbnailLocation = thumbnailLocation
        self.originalLocation = originalLocation
    }
}
