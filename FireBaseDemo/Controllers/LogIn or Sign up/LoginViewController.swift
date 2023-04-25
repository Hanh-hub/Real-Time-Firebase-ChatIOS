//
//  ViewController.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/13/23.
//




import UIKit
import Firebase

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
   // @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    
    var viewModel = LogInViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        viewModel.login(email: email, password: password) { [weak self] success in
            if success {
                self?.showUsersScreen()
            } else {
                self?.showAlert(message: "Invalid email or password")
            }
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        signUpVC.modalPresentationStyle = .popover
               signUpVC.modalTransitionStyle = .crossDissolve
               present(signUpVC, animated: true, completion: nil)
      }
    
    // MARK: - Private functions
    
   
    
    private func showUsersScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let UsersVC = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
        navigationController?.pushViewController(UsersVC, animated: true)
    }
    
    private func showSignUpScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
        navigationController?.pushViewController(signUpVC, animated: true)
        
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

