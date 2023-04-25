//
//  ImageMessageTableViewCell.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/24/23.
//

import UIKit

class ImageMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    

    var message: Message?
//    {
//        didSet {
//            configureImage()
//        }
//    }
    var currentUserId: String?
    
    var messageContainerLeadingConstraint: NSLayoutConstraint?
    var messageContainerTrailingConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //messageImageView.image = UIImage(named: "defaultImage")
        setUpViews()
        setUpContainerConstraints()
        setupMessageImageViewConstraints()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
   
    }
    
    private func setUpViews() {
        // Your existing setup code
        messageContainer.addSubview(messageImageView)
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setUpContainerConstraints() {
        // Set up the constraints programmatically
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        messageContainerLeadingConstraint = messageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        messageContainerTrailingConstraint = messageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([
            messageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            messageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        let widthConstraint = messageContainer.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 0.9)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
    }
    
    private func setupMessageImageViewConstraints2() {
        let maxWidth = contentView.frame.width * 0.75
        let maxHeight: CGFloat = 200.0 // Adjust this value based on your preference

        let widthConstraint = messageImageView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
        let heightConstraint = messageImageView.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight)

        NSLayoutConstraint.activate([
            widthConstraint,
            heightConstraint
        ])
    }
    private func setupMessageImageViewConstraints() {
        let maxWidth = messageContainer.frame.width * 0.75
        let maxHeight: CGFloat = 200.0 // Adjust this value based on your preference

        let widthConstraint = messageImageView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
        let heightConstraint = messageImageView.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight)

        NSLayoutConstraint.activate([
            messageImageView.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 8),
            messageImageView.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -8),
            messageImageView.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 8),
            messageImageView.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -8),
            widthConstraint,
            heightConstraint
        ])
    }

    func configureImage(with message: Message, currentUserId: String) {
        let isSent = message.senderId == currentUserId
        // If is sent, image will be on the right, => trailing = true
        if isSent {
            activateSenderConstraints()
        } else {
            activateReceiverConstraints()
        }

        // Activate constraints
        NSLayoutConstraint.activate([
            messageContainerLeadingConstraint!,
            messageContainerTrailingConstraint!
        ])
        

        guard let imageUrl = message.imageUrl else {
            print("invalid image url")
            return
        }
       
       messageImageView.setImageFromUrl(imageUrl)
       // messageImageView.image = UIImage(named: "defaultImage")
    }
    
    func activateSenderConstraints(){
        messageContainerLeadingConstraint?.isActive = false
        messageContainerTrailingConstraint?.isActive = true
    }
    
    func activateReceiverConstraints(){
        messageContainerLeadingConstraint?.isActive = true
        messageContainerTrailingConstraint?.isActive = false
    }

}


