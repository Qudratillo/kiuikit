//
//  KIChatDialoguesListCell.swift
//  KIUIKit
//
//  Created by Macbook on 9/26/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import UIKit

protocol DialogueListViewModel {
    var iconString: String? { get }
    var isOnline: Bool { get }
    var titleLeftIcon: String? { get }
    var titleName: String? { get }
    var titleRightIcon: String? { get }
    var statusImage: String? { get }
    var titleDetail: String? { get }
    var titleExtraDetail: String? { get }
    var date: String { get }
    var meta: Int { get }
    
}

class KIChatDialoguesListCell: UITableViewCell {
    
    let avatarImageView: KICircleImageView = {
        let imageView = KICircleImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let onlineIndiCatorImageView: KICircleImageView = {
        let imageView = KICircleImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLeftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Jasur Amirov Abdurashid ogli 1996 yil 17 apprel"
        return label
    }()
    
    let titleRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return imageView
    }()
    
    let messageStatusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        return imageView
    }()
    
    let detailedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Anvar"
        
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        //        label.alignmentRectInsets =
        return label
    }()
    
    let extraDetailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Assalomu alaykum"
        label.textColor = .gray
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.text = "Sep 26"
        return label
    }()
    
    let metaBadgeCountLabel: PaddingLabel = {
        let label = PaddingLabel(top: 4, right: 4, bottom: 4, left: 4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.layer.cornerRadius = 7.5
        label.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        label.textColor = .white
        label.textAlignment = .right
        label.layer.masksToBounds = true
        label.text = "999+"
        return label
    }()
    
    let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    private func setupViews() {
        
        addSubview(avatarImageView)
        avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.avatarImageVeiwLeftMargin).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.avatarImageVeiwTopBottomMargin).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarImageVeiwWidth).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarImageVeiwWidth).isActive = true
        
        avatarImageView.addSubview(onlineIndiCatorImageView)
        onlineIndiCatorImageView.rightAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: -6).isActive = true
        onlineIndiCatorImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -6).isActive = true
        onlineIndiCatorImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        onlineIndiCatorImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        titleLeftImageView.widthAnchor.constraint(equalToConstant: Constants.titleLeftImageViewWidth).isActive = true
        titleLeftImageView.heightAnchor.constraint(equalToConstant: Constants.titleLeftImageViewWidth).isActive = true
        
        titleRightImageView.widthAnchor.constraint(equalToConstant: Constants.titleRightImageViewWidth).isActive = true
        titleRightImageView.heightAnchor.constraint(equalToConstant: Constants.titleRightImageViewWidth).isActive = true
        
        topStackView.addArrangedSubview(titleLeftImageView)
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(titleRightImageView)
        
        addSubview(topStackView)
        topStackView.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 16).isActive = true
        topStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        let topStackViewWidth = self.frame.width - Constants.avatarImageVeiwWidth
                                                 - Constants.avatarImageVeiwLeftMargin
                                                 - Constants.topStackViewLeftRightMargin
                                                 - Constants.topStackViewRightMargin
                                                 - Constants.messageStatusRightMargin
                                                 - Constants.messageStatusWidth
                                                 - Constants.dateLabelWidth
                                                 - Constants.dateLabelLeftMargin
        topStackView.widthAnchor.constraint(lessThanOrEqualToConstant: topStackViewWidth).isActive = true
        
        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(messageStatusImageView)
        messageStatusImageView.rightAnchor.constraint(equalTo: dateLabel.leftAnchor, constant: -4).isActive = true
        messageStatusImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        messageStatusImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        messageStatusImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        addSubview(metaBadgeCountLabel)
        metaBadgeCountLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4).isActive = true
        metaBadgeCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        metaBadgeCountLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(detailedLabel)
        detailedLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 12).isActive = true
        detailedLabel.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 4).isActive = true
        //        detailedLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -80).isActive = true
        // view model kirib kelganda widthni hisiblab constraintni update qilish kerak
        //        detailedLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        
        
        addSubview(extraDetailLabel)
        extraDetailLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 12).isActive = true
        extraDetailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        extraDetailLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        // view model kirib kelganda widthni hisiblab constraintni update qilish kerak
        extraDetailLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        
    }
    
    func set(viewModel: DialogueListViewModel?, type: DialogueType, width: CGFloat) {
        
        //        avatarImageView.image = UIImage(named: "icons8-user")
        
        
        switch type {
        case .contact:
            print("contact")
        case .chat:
            print("contact")
        case .group:
            print("contact")
        case .chanel:
            print("contact")
        }
        let detailedLabelWidth = width - Constants.avatarImageVeiwLeftMargin
                                       - Constants.avatarImageVeiwWidth
                                       - Constants.detailedLabelLeftMargin
                                       - metaBadgeCountLabel.frame.width
                                       - Constants.detailedLabelLeftMargin
                                       - Constants.dateLabelRightMargin
        detailedLabel.widthAnchor.constraint(equalToConstant: detailedLabelWidth).isActive = true
        detailedLabel.layoutIfNeeded()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}

enum DialogueType {
    case contact, chat, group, chanel
}


