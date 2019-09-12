//
//  ViewController.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/9/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let q = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        testMessageDetailAttachmentView()
//        testMessageImageAttachmentView()
//        testReplyMessageView()
//        testAvatarImageView()
     
        
    }
    
    func testMessageDetailAttachmentView() {
        let model = KIMessageDetailAttachmentViewModel(width: 200, action: .download, imageData: .empty, imageGradientBase: nil, imageInitialsText: nil, topText: "Johnny Dertiy - Hey ladies.mp3", bottomText: "04:21, 1.2 MB", sliderValue: 0)
        let view = KIMessageDetailAttachmentView(frame: .init(x: 20, y: 100, width: model.width, height: model.height), viewModel: model)
        
        self.view.addSubview(view)
        
        
        q.addOperation {
            sleep(1)
            model.action = .loading
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
            }
            sleep(1)
            model.action = .play
            model.width = 150
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.frame = .init(x: 20, y: 100, width: model.width, height: model.height)
                view.viewModel = model
            }
            sleep(1)
            model.topText = nil
            model.sliderValue = 0.3
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
            }
            sleep(1)
            model.topText = "Henry Coughman"
            model.bottomText = "+1 293 8329 233"
            model.action = .none
            model.imageGradientBase = 120
            model.imageInitialsText = "Henry Coughman"
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
            }
            sleep(1)
            model.imageData = .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg")
            model.width = 200
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
            }
        }
    }
    
    func testMessageImageAttachmentView() {
        let model = KIMessageImageAttachmentViewModel(width: 100, height: 200, minWidth: 170, minHeight: 150, whRatio: 0.1, imageData: .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg"), action: .download, metaText: "16:09")
        let view = KIMessageImageAttachmentView(frame: .init(x: 20, y: 100, width: model.width, height: model.height), viewModel: model)
        
        self.view.addSubview(view)
        
        
        q.addOperation {
            sleep(1)
            model.action = .loading
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
            }
            sleep(1)
            model.action = .play
            model.metaText = nil
            model.width = 200
            model.height = 400
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.frame = .init(x: 20, y: 100, width: model.width, height: model.height)
                view.viewModel = model
            }
        }
    }
    
    func testReplyMessageView() {
        var width: CGFloat = 100
        let height: CGFloat = KIReplyMessageViewModel.replyMessageViewHeightRecommended
     
        let replyMessageView = KIReplyMessageView(frame: CGRect(x: 100, y: 100, width: width, height: height), viewModel: KIReplyMessageViewModel(width: width, height: height, imageData: nil, topText: "Benjamin Jery", bottomText: "Hey ladies"))
        
        q.addOperation {
            sleep(1)
            OperationQueue.main.addOperation {
                width = 300
                replyMessageView.frame = CGRect(x: 100, y: 100, width: width, height: height)
                replyMessageView.viewModel = KIReplyMessageViewModel(width: width, height: height, imageData: .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg"), topText: "keaty floxy", bottomText: "Hey raspberry")
            }
            sleep(1)
            OperationQueue.main.addOperation {
                width = 400
                replyMessageView.frame = CGRect(x: 100, y: 100, width: width, height: height)
                replyMessageView.viewModel = KIReplyMessageViewModel(width: width, height: height, imageData: nil, topText: "keaty floxy djasnd iausda", bottomText: nil)
            }
            
            
        }
        
        self.view.addSubview(replyMessageView)
    }
    
    func testAvatarImageView() {
        let avatarImageView = KIAvatarImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        
        self.view.addSubview(avatarImageView)
        
        
        q.addOperation {
            avatarImageView.gradientBase = 10
            sleep(1)
            avatarImageView.initialsText = " Jonathan  "
            sleep(1)
            avatarImageView.initialsText = " Base  Group "
            sleep(1)
            URLSession.shared.dataTask(with: URL(string: "https://www.templatebeats.com/files/images/profile_user.jpg")!, completionHandler: { (data, resp, error) in
                OperationQueue.main.addOperation {
                    if let data = data {
                        avatarImageView.image = UIImage(data: data)
                    }
                }
            }).resume()
            
        }
    }


}

