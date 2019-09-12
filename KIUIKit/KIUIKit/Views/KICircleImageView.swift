//
//  KICircleImageView.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/11/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

public class KICircleImageView: UIImageView {
    
    private func updateSelfFrames() {
        self.layer.cornerRadius = self.bounds.height/2
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        self.initView()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.initView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.clipsToBounds = true
        self.updateSelfFrames()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSelfFrames()
    }
}
