//
//  Model.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/17/23.
//

import Foundation
import UIKit

struct User {
    let uid: String
    let email: String
    let displayName: String
}

//struct User{
//    var firstName: String
//    var lastName: String
//}

struct Channel {
    var id = UUID()
    var groupName: String
}

struct ChatUIConfiguration {
    let primaryColor: UIColor
    let secondaryColor: UIColor
    let inputTextViewBgColor: UIColor
    let inputTextViewTextColor: UIColor
    let inputPlaceholderTextColor: UIColor
}

//struct Message {
//    let id: String
//    let senderId: String
//    let text: String
//    let timestamp: TimeInterval
//
//    init?(id: String, data: [String: Any]) {
//        guard let senderId = data["senderId"] as? String,
//              let text = data["text"] as? String,
//              let timestamp = data["timestamp"] as? TimeInterval else {
//            return nil
//        }
//
//        self.id = id
//        self.senderId = senderId
//        self.text = text
//        self.timestamp = timestamp
//    }
//}

struct Message {
    let messageId: String
    let senderId: String
    let text: String?
    let imageUrl: String?
    let timestamp: TimeInterval
    
    var messageType: MessageType {
        if imageUrl != nil {
            return .image
        } else {
            return .text
        }
    }
}

enum MessageType {
     case text, image
}
