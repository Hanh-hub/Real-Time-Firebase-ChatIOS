//
//  SignUpViewController.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/18/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let viewModel = SignUpViewModel()
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!

  
    @IBAction func signUpButtonTapped( _ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let displayName = displayNameTextField.text, !displayName.isEmpty else {
            return
        }
        viewModel.signUpAndAddUser(email: email, password: password, displayName: displayName) { success in
                   if success {
                       // Dismiss the sign-up pop-up and navigate to the
                       self.dismiss(animated: true, completion: nil)
                   } else {
                       // Show error message for failed sign-up
                   }
               }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    private func showUsersScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let UsersVC = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
        navigationController?.pushViewController(UsersVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
