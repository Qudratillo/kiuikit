//
//  CheckBox.swift
//  KIUIKit
//
//  Created by Macbook on 1/18/20.
//  Copyright © 2020 Kudratillo Ismatov. All rights reserved.
//

import Foundation
import UIKit

protocol CheckBoxDelegate {
    func checkBoxClicked(isChecked: Bool)
}

class CheckBox: UIView {
    public var borderWidth: CGFloat = 1.75
    
    var checkboxBackgroundColor: UIColor! = .white
    var checkmarkColor: UIColor =  #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    
    var isChecked: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                self.backgroundColor = self.isChecked ? self.checkmarkColor : self.checkboxBackgroundColor
            }, completion: nil)
            
        }
    }
    
    var checkBoxCallBack: ((_ isChecked: Bool) -> Void)?
    
    var delegate: CheckBoxDelegate?
    
    private var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.borderWidth = borderWidth
        layer.borderColor = checkmarkColor.cgColor
        layer.cornerRadius = 13
        
        addSubview(imageView)
        imageView.image = UIImage.resourceImage(for: self, named: "icons8-checkmark")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkMarkClicked)))
    }
    
    @objc func checkMarkClicked() {
        isChecked = !isChecked
        delegate?.checkBoxClicked(isChecked: isChecked)
        checkBoxCallBack?(isChecked)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
