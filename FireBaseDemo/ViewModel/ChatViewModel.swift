//
//  ChatViewModel.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/18/23.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage

class ChatViewModel {
    var messages: [Message] = []
   
    private let ref: DatabaseReference
    private var messagesHandle: DatabaseHandle?
    private let receiverUserId: String
    let currentUserId: String
    
    private var chatId: String {
        return currentUserId < receiverUserId ? "\(currentUserId)_\(receiverUserId)" : "\(receiverUserId)_\(currentUserId)"
    }

    
    init(selectedUserId: String){
        self.ref = Database.database().reference()
        self.receiverUserId = selectedUserId
        self.currentUserId = Auth.auth().currentUser?.uid ?? ""
        print("INIT CHAT VIEW MODEL ")
    }
    
    func observeMessage(completion: @escaping (Message) -> Void) {
        let messageRef = ref.child("chats").child(chatId).child("messages")
        messagesHandle = messageRef.observe(.childAdded) { [weak self] snapshot in
            guard let self = self, let messageObject = self.message(from: snapshot) else { return }

            // Check if the message is already in the local messages array
            if let existingMessageIndex = self.messages.firstIndex(where: { $0.messageId == messageObject.messageId }) {
                // Update the existing message if needed
                self.messages[existingMessageIndex] = messageObject
            } else {
                // Append the new message to the local messages array
                self.messages.append(messageObject)
            }
            completion(messageObject)
        }
    }


   
    private func fetchMessagesForChat(chatID: String, completion: @escaping (Bool) -> Void) {
        if messages.isEmpty {
            print("messages is empty")
            ref.child("chats").child(chatId).child("messages").observe(.value) { [weak self] snapshot in
                guard let self = self else { return }
                for message in snapshot.children {
                    if let messageSnapshot = message as? DataSnapshot,
                       let messageObject = self.message(from: messageSnapshot) {
                        
                        messages.append(messageObject)
                        //print(messages)
                    }
                }
                messages.sort(by: { $0.timestamp < $1.timestamp })
                self.messages = messages
                completion(true)
            }
        }
    }
    private func fetchMessagesForChatw(chatID: String, completion: @escaping (Bool) -> Void) {
       
            print("messages is empty")
        ref.child("chats").child(chatId).child("messages").observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            for message in snapshot.children {
                if let messageSnapshot = message as? DataSnapshot,
                   let messageObject = self.message(from: messageSnapshot) {
                    
                    messages.append(messageObject)
                    //print(messages)
                }
            }
            messages.sort(by: { $0.timestamp < $1.timestamp })
            self.messages = messages
            completion(true)
        }
            
    }
    
    func fetchMessagesIfChatExists(completion: @escaping (Bool) -> Void) {
        let chatId = self.chatId
        ref.child("chats").child(chatId).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            if snapshot.exists() {
                self.fetchMessagesForChat(chatID: chatId, completion: completion)
            } else {
                completion(false)
            }
        }
    }


    
    private func message(from snapshot: DataSnapshot) -> Message? {
        guard let messageData = snapshot.value as? [String: Any],
            let senderId = messageData["senderId"] as? String,
            let timestamp = messageData["timestamp"] as? TimeInterval else {
                return nil
        }

        let text = messageData["text"] as? String
        let imageUrl = messageData["imageUrl"] as? String

        guard text != nil || imageUrl != nil else { return nil }

        return Message(messageId: snapshot.key, senderId: senderId, text: text, imageUrl: imageUrl, timestamp: timestamp)
    }


    func stopObservingMessage(){
        if let handler = messagesHandle {
            ref.child("chats").child(chatId).child("messages").removeObserver(withHandle: handler)
        }
    }
    
    func sendMessage(text: String, completion: @escaping (Bool) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            let messageData: [String: Any] = [
                "senderId": currentUser.uid,
                "text": text,
                "timestamp": Date().timeIntervalSince1970,
                "messageType": "text"
            ]
            ref.child("chats").child(chatId).child("messages").childByAutoId().setValue(messageData)
            completion(true)
        } else {
            completion(false)
        }
    }

    func getNumOfRow() -> Int{
        return messages.count
    }
    
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping(Bool) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.5) else  {
            return
        }
        let storageRef = Storage.storage().reference()
        
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metadata) { _, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                imageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription) url = \(String(describing: url))")
                        completion(false)
                        return
                    }
                    guard let downloadUrl = url else {
                        print("No download URL")
                        completion(false)
                        return
                    }
                    self.sendImageUrlToRTDatabase(imageUrl: downloadUrl.absoluteString)
                    completion(true)
                }
            }
    }
    
    func getImageUrlFromStorage(){
        
    }
    
    func sendImageUrlToRTDatabase(imageUrl: String){
        
        let messageRef = ref.child("chats").child(chatId).child("messages").childByAutoId()
        let messageData: [String: Any] = [
            "senderId": currentUserId,
            "imageUrl": imageUrl,
            "timestamp": Date().timeIntervalSince1970,
            "messageType": "image"
        ]
        messageRef.setValue(messageData)
    }
    
    deinit {
        print("DEINIT CHAT VIEW MODEL")
    }
}
