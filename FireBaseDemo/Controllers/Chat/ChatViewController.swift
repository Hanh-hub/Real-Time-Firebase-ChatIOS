//
//  ChatViewController.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/17/23.
//

import UIKit
import FirebaseDatabase
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    
    @IBOutlet weak var placeholderLabel: UILabel!

    @IBOutlet weak var messagesTableView: UITableView!
   // @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var messageInput: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var sendImageView: UIImageView!
    var viewModel: ChatViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpPlaceholderLabel()
        loadMessageHistory()
        observeForIncomingMessage()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        
        if let text = messageInput.text, !text.isEmpty {
            //self.showAlert(title: "text message detected", message: "this is a text message")
            viewModel.sendMessage(text: text) { success in
                if success {
                    DispatchQueue.main.async {
                        //reset send box
                        self.messageInput.text = ""
                    }
                }
            }
        } else {
            if let imageMessage = sendImageView.image {
               
               // viewModel
                viewModel.uploadImageToFirebaseStorage(image: imageMessage) {success in
                    if success {
                        DispatchQueue.main.async {
                            self.sendImageView.image = nil
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // Change to .camera to capture photo
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    private func setUpTableView(){
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        messageInput.delegate = self
        
        messagesTableView.separatorStyle = .none
        messagesTableView.rowHeight = UITableView.automaticDimension
        messagesTableView.estimatedRowHeight = 500 // You can use any reasonable estimated height value
    }
    
    private func setUpPlaceholderLabel(){
        placeholderLabel.text = "Enter your text here..."
        placeholderLabel.font = UIFont.systemFont(ofSize: (messageInput.font?.pointSize ?? 16.0) * 0.9)
        placeholderLabel.textColor = UIColor.lightGray

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: messageInput.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: messageInput.trailingAnchor, constant: -5),
            placeholderLabel.topAnchor.constraint(equalTo: messageInput.topAnchor, constant: messageInput.textContainerInset.top - 2),
            placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: messageInput.bottomAnchor, constant: -messageInput.textContainerInset.bottom)
        ])
    }
  
    private func observeForIncomingMessage() {
        viewModel.observeMessage { [weak self] message in
                   // Update the UI with the new or updated message
            DispatchQueue.main.async {
                self?.messagesTableView.reloadData()
                self?.scrollToBottom()
            }
        }
    }
    
    private func loadMessageHistory() {
        viewModel.fetchMessagesIfChatExists { success in
            if success {
                DispatchQueue.main.async {
                    self.messagesTableView.reloadData()
                    //self.showAlert(title: "table reload", message: "table reloaded")
                }
            } else {
                self.showAlert(title: "failed to load", message: "failed to load message")
            }
            
        }
        scrollToBottom()
    }

    
    
    private func scrollToBottom() {
        let numberOfSections = messagesTableView.numberOfSections
        
        if numberOfSections > 0 {
            let numberOfRows = messagesTableView.numberOfRows(inSection: numberOfSections - 1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    
    deinit {
        viewModel.stopObservingMessage()
    }
    
    // MARK: - UITableViewDataSource
}

                                        
extension ChatViewController{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5 // Change this value to adjust the space between rows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumOfRow()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.section]
       
        print("messageType", message.messageType)
        if message.messageType == .text {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
            cell.selectionStyle = .none
            
           // cell.currentUserSenderId = message.senderId
            cell.configure(with: message, currentUserId: viewModel.currentUserId)
            return cell
        } else {
            //self.showAlert(title: "image detect", message: "resuable cell for image")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageMessageTableViewCell", for: indexPath) as! ImageMessageTableViewCell
            cell.selectionStyle = .none
            cell.configureImage(with: message, currentUserId: viewModel.currentUserId)
            return cell
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !messageInput.text.isEmpty
    }

}


extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage  = info[.originalImage] as? UIImage else {
            return
        }
        sendImageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
}
