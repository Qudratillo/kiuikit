//
//  MessageActionsToolBar.swift
//  KIUIKit
//
//  Created by Macbook on 2/22/20.
//  Copyright © 2020 Kudratillo Ismatov. All rights reserved.
//

import Foundation
import UIKit

public protocol MessageActionsToolBarDelegate: class {
    func closeSelectionModeHandler()
    func replySelectionModeHandler()
    func forwardSelectionModeHandler()
    func copySelectionModeHandler()
    func deleteSelectionModeHandler()
    func easySelectMessageSelectionModeHandler()
    func editSelectionModeHandler()
}

public class MessageActionsToolBar: UIToolbar {
    
    var flexibleSpace: UIBarButtonItem!
    var replyToolBarItem: UIBarButtonItem!
    var forwardToolBarItem: UIBarButtonItem!
    var copyToolBarItem: UIBarButtonItem!
    var deleteToolBarItem: UIBarButtonItem!
    var messageCounterToolBarItem: UIBarButtonItem!
    var easySelectMessageToolBarItem: UIBarButtonItem!
    var editToolBarItem: UIBarButtonItem!
    
    public var messageActionsToolBarDelegate: MessageActionsToolBarDelegate?
    public var isGroup: Bool = false
    
    public required init(isGroup: Bool) {
        self.isGroup = isGroup
        super.init(frame: .zero)
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        flexibleSpace.tag = -1
        deleteToolBarItem = UIBarButtonItem(image: UIImage.resourceImage(for: self, named: "icon_trash"),
                                                   style: .plain, target: self,
                                                   action: #selector(deleteSelectionModeHandler))
        deleteToolBarItem.tag = 0
        messageCounterToolBarItem = UIBarButtonItem(title: "0", style: .done, target: self, action: nil)
        messageCounterToolBarItem.tag = 1
        replyToolBarItem = UIBarButtonItem(image: UIImage.resourceImage(for: self, named: "icon_reply"),
                                           style: .plain, target: self,
                                           action: #selector(replySelectionModeHandler))
        replyToolBarItem.tag = 2
        forwardToolBarItem = UIBarButtonItem(image: UIImage.resourceImage(for: self, named: "icon_forward"),
                                             style: .plain, target: self,
                                             action: #selector(forwardSelectionModeHandler))
        forwardToolBarItem.tag = 3
        copyToolBarItem = UIBarButtonItem(image: UIImage.resourceImage(for: self, named: "icon_copy"),
                                          style: .plain, target: self,
                                          action: #selector(copySelectionModeHandler))
        copyToolBarItem.tag = 4
        easySelectMessageToolBarItem = UIBarButtonItem(image: UIImage.resourceImage(for: self, named: "icon_check_list"),
                                                       style: .plain, target: self,
                                                       action: #selector(easySelectMessageSelectionModeHandler))
        easySelectMessageToolBarItem.tag = 5
        editToolBarItem = UIBarButtonItem(image: UIImage.resourceImage(for: self, named: "icon_check_list"),
                                          style: .plain, target: self,
                                          action: #selector(editSelectionModeHandler))
        editToolBarItem.tag = 6
        
        items = [deleteToolBarItem, messageCounterToolBarItem,
                 flexibleSpace, flexibleSpace,
                 replyToolBarItem, flexibleSpace,
                 copyToolBarItem, flexibleSpace,
                 forwardToolBarItem]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func selectedMessageItemHandler(_ countOfSelectedMessageItems: Int) {
        messageCounterToolBarItem.title = "\(countOfSelectedMessageItems)"
        if countOfSelectedMessageItems > 1 {
            items = [deleteToolBarItem, messageCounterToolBarItem,
                     flexibleSpace, flexibleSpace,
                     flexibleSpace, flexibleSpace,
                     copyToolBarItem, flexibleSpace,
                     forwardToolBarItem]
        } else {
            items = [deleteToolBarItem, messageCounterToolBarItem,
                     flexibleSpace, flexibleSpace,
                     replyToolBarItem, flexibleSpace,
                     copyToolBarItem, flexibleSpace,
                     forwardToolBarItem]
        }
        items?.forEach({ $0.isEnabled = countOfSelectedMessageItems != 0 })
    }
    
    public func showEasySelectMessageToolBarItem(isShown: Bool) {
        if isShown {
            items?.insert(easySelectMessageToolBarItem, at: 5)
            items?.insert(flexibleSpace, at: 6)
        } else {
            var index: Int? = nil
            items = items?.enumerated().compactMap({ (item) -> UIBarButtonItem? in
                
                let (offset, element) = item
                if element.tag == easySelectMessageToolBarItem.tag {
                    index = offset
                    return nil
                }
                return element
            })
            if let i = index {
                items?.remove(at: i)
            }
        }
    }
    
    @objc func closeSelectionModeHandler() {
        messageActionsToolBarDelegate?.closeSelectionModeHandler()
    }
    
    @objc func replySelectionModeHandler() {
        messageActionsToolBarDelegate?.replySelectionModeHandler()
    }
    
    @objc func forwardSelectionModeHandler() {
        messageActionsToolBarDelegate?.forwardSelectionModeHandler()
    }
    
    @objc func copySelectionModeHandler() {
        messageActionsToolBarDelegate?.copySelectionModeHandler()
    }
    
    @objc func deleteSelectionModeHandler() {
        messageActionsToolBarDelegate?.deleteSelectionModeHandler()
    }
    
    @objc func easySelectMessageSelectionModeHandler() {
        messageActionsToolBarDelegate?.easySelectMessageSelectionModeHandler()
    }
    
    @objc func editSelectionModeHandler() {
        messageActionsToolBarDelegate?.editSelectionModeHandler()
    }
    
}
