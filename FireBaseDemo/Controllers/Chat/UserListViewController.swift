//
//  UserListViewController.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/18/23.
//

import UIKit



class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentUsernameLabel: UILabel!
    
    
    private let viewModel = UserListViewModel()
   
    @IBAction func signOutButtonTapped(_ sender: Any) {
        viewModel.signOut { success in
                    if success {
                        DispatchQueue.main.async {
                            self.navigateToLoginViewController()
                        }
                    } else {
                        self.showAlert(title: "Sign out", message: "Sign out failed")
                        // Show an error message or handle the sign-out failure
                    }
                }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        getUserList()
        displayCurrentUserName()
        
    }
    
    private func navigateToLoginViewController() {
            // Assuming you are using a storyboard, and the LoginViewController has the Storyboard ID "LoginViewController"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
            
            // If you are using a UINavigationController, replace the current view controller stack
            if let navigationController = self.navigationController {
                navigationController.setViewControllers([loginViewController], animated: true)
            } else {
                // If you are not using a UINavigationController, present the LoginViewController modally
                loginViewController.modalPresentationStyle = .fullScreen
                self.present(loginViewController, animated: true, completion: nil)
            }
        }
    
    
    private func displayCurrentUserName(){
        viewModel.getCurrentUser{ [weak self] result in
            switch result {
            case .success(let userName):
                self?.currentUsernameLabel.text = "logged in as \(userName)"
        
            case .failure(let error):
                self?.showAlert(title: "failed to load username", message: error.localizedDescription)
            }
        }
    }
    
    private func getUserList() {
        viewModel.fetchUsers { [self] success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                self.showAlert(title: "Fetch user Error", message: "Cannot fetch")
            }
            
        }
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.textLabel?.text = viewModel.users[indexPath.row].displayName
        //users[indexPath.row].displayName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let receiverUserId = viewModel.users[indexPath.row]
            self.navigationItem.title = receiverUserId.displayName
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            chatVC.viewModel = ChatViewModel(selectedUserId: receiverUserId.uid)
            navigationController?.pushViewController(chatVC, animated: true)
            
            // Navigate to ChatViewController with the selected user
            // ...
        }
    
    // UITableViewDelegate
  
}
