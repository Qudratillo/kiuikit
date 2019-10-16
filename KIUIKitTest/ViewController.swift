//
//  ViewController.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 9/9/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit
import KIUIKit


class ViewController: UIViewController, KIChatMessagesCollectionViewMessagesDelegate {
    
    
    
    let q = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testChatMessagesCollectionView()
        //        testActionMessageView()
        //        testTextMessageView()
        //        testTextMessageContentView()
        //        testMessageDetailAttachmentView()
        //        testMessageImageAttachmentView()
        //        testReplyMessageView()
        //        testAvatarImageView()
        
        
    }
    
    func fetchTop(item: KIChatMessageItem, addPlaceholderItems: @escaping ([KIChatMessageItem]) -> Void, addItems: @escaping ([KIChatMessageItem]) -> Void) {
        q.addOperation {
            let items = self.makeChatMessageItems(startDate: item.date.addingTimeInterval(-10*24*3600), length: 100)
            addPlaceholderItems(items)
            addItems([])
            
        }
    }
    
    func fetchBottom(item: KIChatMessageItem, addPlaceholderItems: @escaping ([KIChatMessageItem]) -> Void, addItems: @escaping ([KIChatMessageItem]) -> Void) {
        q.addOperation {
            let items = self.makeChatMessageItems(startDate: item.date, length: 0)
            addPlaceholderItems(items)
            addItems([])
        }
    }
    
    
    func makeChatMessageItems(startDate: Date, length: Int) -> [KIChatMessageItem] {
        var items: [KIChatMessageItem] = []
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        
        
        for _ in 0..<length {
            let date = Date(timeIntervalSinceNow: TimeInterval(arc4random() % (10*24*3600)))
            var viewModel: KIMessageViewModel
            var replyId: Int?
            if arc4random()%10 == 1 {
                viewModel = KIActionMessageViewModel(text: "Chat Photo Changed", imageData: arc4random()%2 == 1 ? nil : .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg"))
            } else {
                let intialsText = "\(Unicode.Scalar.init(arc4random()%29 + UnicodeScalar("A").value) ?? UnicodeScalar("A")) \(Unicode.Scalar.init(arc4random()%29 + UnicodeScalar("A").value) ?? UnicodeScalar("A"))"
                
                var replyModel: KIReplyMessageViewModel?
                if arc4random()%2 == 1,
                    let randomItem = items.randomElement(),
                    let randomItemViewModel = randomItem.viewModel as? KITextMessageViewModel {
                    replyId = randomItem.id
                    let imageData = (randomItemViewModel.contentModel.attachmentModel as? KIMessageImageAttachmentViewModel)?.imageData
                    replyModel = KIReplyMessageViewModel(imageData: imageData, topText: randomItemViewModel.contentModel.nameText, bottomText: randomItemViewModel.contentModel.text ?? "attachment")
                }
                
                let imageAttachmentModel = arc4random()%2 == 1 ?  KIMessageImageAttachmentViewModel(whRatio: CGFloat((arc4random()%4 + 1))/CGFloat(arc4random()%4 + 1), imageData: .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg"), action: .download, metaText: nil) : nil
                let detailAttachmentModel = arc4random()%2 == 1 ?  KIMessageDetailAttachmentViewModel(action: arc4random()%2 == 1 ? .play : .none, imageData: arc4random()%2 == 1 ? .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg") : .empty, imageGradientBase: Int(arc4random()), imageInitialsText: randomAlphanumericString(length: 10), topText: randomAlphanumericString(length: 10), metaText: randomAlphanumericString(length: 20), sliderValue: Float((arc4random()%100)/100)) : nil
                
                viewModel = KITextMessageViewModel(avatarImageData: arc4random()%2 == 1 ? .empty : .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg"), avatarGradientBase: Int(arc4random()), avatarInitialsText: intialsText, contentModel: .init(nameText: arc4random()%2 == 1 ? "Merlyn Monro" : nil, forwardedFromText: arc4random() % 10 == 1 ? "Forwarded message\nFrom Kate Bell" : nil, replyModel: replyModel, attachmentModel: arc4random()%2 == 1 ? imageAttachmentModel : detailAttachmentModel, text: arc4random() % 2 == 1 ? randomAlphanumericString(length: arc4random()%2 == 1 ? Int(arc4random() % 15) : Int(arc4random() % 1000)) : nil, messageStatus: nil, timeText: df.string(from: date)) , containerLocation: arc4random()%2 == 1 ? .right : .left)
            }
            
            items.append(.init(id: Int(date.timeIntervalSinceNow), date: date, viewModel: viewModel, replyId: replyId))
        }
        return items
    }
    
    func testChatMessagesCollectionView() {
        let view: KIChatMessagesCollectionView = .init(frame: self.view.frame)
        let items = makeChatMessageItems(startDate: Date(), length: 10)
        view.set(items: items, scrollToBottom: true)
        
        view.messagesDelegate = self
        
        self.view.addSubview(view)
    }
    
    func randomAlphanumericString(length: Int) -> String  {
        enum Statics {
            static let scalars = [UnicodeScalar("a").value...UnicodeScalar("z").value,
                                  UnicodeScalar("A").value...UnicodeScalar("Z").value,
                                  UnicodeScalar("0").value...UnicodeScalar("9").value].joined()
            
            static let characters = scalars.map { Character(UnicodeScalar($0)!) }
        }
        
        let result = (0..<length).map { _ in Statics.characters.randomElement()! }
        return String(result)
    }
    
    func testActionMessageView() {
        let model = KIActionMessageViewModel(width: self.view.frame.width, text: "Chat created with so many users, so please keep calm to respect them and take your seats to kate and play it with passion", imageData: nil)
        let view = KIActionMessageView(frame: .init(origin: .init(x: 0, y: 100), size: model.size), viewModel: model)
        
        self.view.addSubview(view)
        
        
        q.addOperation {
            sleep(2)
            model.text = "Chat created"
            model.imageData = .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg")
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
                view.frame = .init(origin: .init(x: 0, y: 100), size: model.size)
            }
        }
        
    }
    
    
    func testTextMessageView() {
        let replyModel = KIReplyMessageViewModel(width: 300, imageData: nil, topText: "Benjamin Jery", bottomText: "Hey ladies")
        let detailAttachmentModel = KIMessageDetailAttachmentViewModel(width: 300, action: .download, imageData: .empty, imageGradientBase: nil, imageInitialsText: nil, topText: "Johnny Dertiy - Hey ladies.mp3", metaText: "04:21, 1.2 MB", sliderValue: 0)
        
        let contentModel = KITextMessageContentViewModel(width: 300, nameText: "Benjamin Fankley", forwardedFromText: "Forwarded from me", replyModel: replyModel, attachmentModel: detailAttachmentModel, text: "Hi ladies and gentlemens, tonight we gonna keep"
            //asking you to play this amazing game. Let me explain the game. It is so easy to play. You just need to sit down and then stand up. Person who did the most is the winner."
            , messageStatus: nil, timeText: "12:05 AM")
        let model = KITextMessageViewModel(width: self.view.frame.width, avatarImageData: nil, avatarGradientBase: 4, avatarInitialsText: nil, contentModel: contentModel, containerLocation: .right)
        let view = KITextMessageView(frame: .init(origin: .init(x: 0, y: 100), size: model.size), viewModel: model)
        self.view.addSubview(view)
        
        
        q.addOperation {
            
            sleep(2)
            model.containerLocation = .left
            model.avatarImageData = nil
            contentModel.nameText = nil
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
                view.frame = .init(origin: .init(x: 0, y: 100), size: model.size)
            }
            
            sleep(2)
            model.containerLocation = .left
            model.avatarImageData = nil
            contentModel.nameText = nil
            contentModel.replyModel = nil
            let imageAttachmentModel = KIMessageImageAttachmentViewModel(width: 400, height: 200, whRatio: 0.8, imageData: .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg"), action: .download, metaText: "16:09")
            contentModel.attachmentModel = imageAttachmentModel
            contentModel.text = nil
            contentModel.forwardedFromText = nil
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
                view.frame = .init(origin: .init(x: 0, y: 100), size: model.size)
            }
            
            
            sleep(2)
            contentModel.nameText = "Kertan Menidas"
            model.avatarImageData = .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg")
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
                view.frame = .init(origin: .init(x: 0, y: 100), size: model.size)
            }
            
            
            
            
            
        }
    }
    
    
    func testTextMessageContentView() {
        let replyModel = KIReplyMessageViewModel(width: 300, imageData: nil, topText: "Benjamin Jery", bottomText: "Hey ladies")
        let detailAttachmentModel = KIMessageDetailAttachmentViewModel(width: 300, action: .download, imageData: .empty, imageGradientBase: nil, imageInitialsText: nil, topText: "Johnny Dertiy - Hey ladies.mp3", metaText: "04:21, 1.2 MB", sliderValue: 0)
        
        let model = KITextMessageContentViewModel(width: 300, nameText: "Benjamin Fankley",forwardedFromText: "Forwarded from me", replyModel: replyModel, attachmentModel: detailAttachmentModel, text: "Hey come over", messageStatus: nil, timeText: "12:05 AM")
        let view = KITextMessageContentView(frame: .init(x: 20, y: 100, width: model.width, height: model.height), viewModel: model)
        //        view.layer.borderWidth = 2
        //        view.layer.borderColor  = UIColor.gray.cgColor
        self.view.addSubview(view)
        
        
        q.addOperation {
            sleep(1)
            let imageAttachmentModel = KIMessageImageAttachmentViewModel(width: 400, height: 200, whRatio: 0.8, imageData: .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg"), action: .download, metaText: "16:09")
            model.attachmentModel = imageAttachmentModel
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
                view.frame = .init(origin: .init(x: 20, y: 100), size: model.size)
            }
            
            sleep(2)
            model.replyModel = nil
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
                view.frame = .init(origin: .init(x: 20, y: 100), size: model.size)
            }
            sleep(1)
            model.forwardedFromText = nil
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
                view.frame = .init(origin: .init(x: 20, y: 100), size: model.size)
            }
            sleep(1)
            model.text = nil
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
                view.frame = .init(origin: .init(x: 20, y: 100), size: model.size)
            }
            
            sleep(1)
            model.attachmentModel = detailAttachmentModel
            model.updateFrames()
            OperationQueue.main.addOperation {
                view.viewModel = model
                view.frame = .init(origin: .init(x: 20, y: 100), size: model.size)
            }
            
            
            
        }
    }
    
    func testMessageDetailAttachmentView() {
        let model = KIMessageDetailAttachmentViewModel(width: 200, action: .download, imageData: .empty, imageGradientBase: nil, imageInitialsText: nil, topText: "Johnny Dertiy - Hey ladies.mp3", metaText: "04:21, 1.2 MB", sliderValue: 0)
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
            model.metaText = "+1 293 8329 233"
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
        let model = KIMessageImageAttachmentViewModel(width: 100, height: 200, whRatio: 0.1, imageData: .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg"), action: .download, metaText: "16:09")
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
        
        let replyMessageView = KIReplyMessageView(frame: CGRect(x: 100, y: 100, width: width, height: height), viewModel: KIReplyMessageViewModel(width: width, imageData: nil, topText: "Benjamin Jery", bottomText: "Hey ladies"))
        
        q.addOperation {
            sleep(1)
            OperationQueue.main.addOperation {
                width = 300
                replyMessageView.frame = CGRect(x: 100, y: 100, width: width, height: height)
                replyMessageView.viewModel = KIReplyMessageViewModel(width: width, imageData: .urlString(urlString: "https://www.templatebeats.com/files/images/profile_user.jpg"), topText: "keaty floxy", bottomText: "Hey raspberry")
            }
            sleep(1)
            OperationQueue.main.addOperation {
                width = 400
                replyMessageView.frame = CGRect(x: 100, y: 100, width: width, height: height)
                replyMessageView.viewModel = KIReplyMessageViewModel(width: width, imageData: nil, topText: "keaty floxy djasnd iausda", bottomText: nil)
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

