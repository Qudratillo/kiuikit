//
//  KIConfig.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/10/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public struct KIConfig {
    public static var imageSetter: KIImageViewSetter = { imageView, imageData in
        switch imageData {
        case .image(let image):
            imageView.image = image
        case .url(let url):
            URLSession.shared.dataTask(with: url, completionHandler: { (data, resp, error) in
                OperationQueue.main.addOperation {
                    if let data = data {
                        imageView.image = UIImage(data: data)
                    }
                }
            }).resume()
            
        case .urlString(let urlString):
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, resp, error) in
                    OperationQueue.main.addOperation {
                        if let data = data {
                            imageView.image = UIImage(data: data)
                        }
                    }
                }).resume()
            }
        case .other(let object):
            break
        case .empty:
            imageView.image = nil
        }
    }
    
    public static func set(imageView: UIImageView, with imageData: KIImageData) {
        self.imageSetter(imageView, imageData)
    }
    
    public static var primaryColor: UIColor = #colorLiteral(red: 0, green: 0.5558522344, blue: 1, alpha: 1)
    public static var accentColor: UIColor = #colorLiteral(red: 0.3430494666, green: 0.8636034131, blue: 0.467017293, alpha: 1)
    public static var primaryTextColor: UIColor = .black
    public static var secondaryTextColor: UIColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
}
