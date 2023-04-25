//
//  MessageTableViewCell.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/17/23.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBackgroundView: UIView!

    private var messageBackgroundViewLeadingConstraint: NSLayoutConstraint?
    private var messageBackgroundViewTrailingConstraint: NSLayoutConstraint?
    
    //var currentUserSenderId: String = " "
       
       override func awakeFromNib() {
           super.awakeFromNib()
           setupViews()
           setupMessageContainerConstraints()
           setupMessageLabelConstraints()
       }

    func configure(with message: Message, currentUserId: String) {
        guard let textMessage = message.text else {return}
        messageLabel.text = textMessage
       

        if message.senderId == currentUserId {
            // Customize the appearance for sent messages
            messageBackgroundView.backgroundColor = .blue
            messageLabel.textColor = .white

            messageBackgroundViewLeadingConstraint?.isActive = false
            messageBackgroundViewTrailingConstraint?.isActive = true
        } else {
            // Customize the appearance for received messages
            messageBackgroundView.backgroundColor = .darkGray
            messageLabel.textColor = .white

            messageBackgroundViewLeadingConstraint?.isActive = true
            messageBackgroundViewTrailingConstraint?.isActive = false
        }
    }

    
    private func setupViews() {
        messageBackgroundView.layer.cornerRadius = 12
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping

        messageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(messageBackgroundView)
        messageBackgroundView.addSubview(messageLabel)
    }

    private func setupMessageContainerConstraints() {
        // Constraints for messageBackgroundView
        let widthConstraint = messageBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 0.75)
        widthConstraint.isActive = true

        messageBackgroundViewLeadingConstraint = messageBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        messageBackgroundViewTrailingConstraint = messageBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)

        // Constraints for messageLabel
        NSLayoutConstraint.activate([
            messageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            messageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupMessageLabelConstraints(){
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -8),
            messageLabel.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -8)
        ])
    }
}
