//
//  SignUpViewModel.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/18/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewModel {
    
    func signUpAndAddUser(email: String, password: String, displayName: String, completion: @escaping (Bool) -> Void) {
            signUp(email: email, password: password, displayName: displayName) { userId, error in
                if let error = error {
                    print("Error signing up: \(error.localizedDescription)")
                    completion(false)
                } else if let userId = userId {
                    self.addUserToDatabase(userId: userId, email: email, displayName: displayName) { error in
                        if let error = error {
                            print("Error adding user to database: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                }
            }
        }
    
    private func signUp(email: String, password: String, displayName: String, completion: @escaping (String?, Error?) -> Void) {
           Auth.auth().createUser(withEmail: email, password: password) { result, error in
               if let error = error {
                   completion(nil, error)
               } else if let user = result?.user {
                   let changeRequest = user.createProfileChangeRequest()
                   changeRequest.displayName = displayName
                   changeRequest.commitChanges { profileError in
                       completion(user.uid, profileError)
                   }
               }
           }
       }
    
    func addUserToDatabase(userId: String, email: String, displayName: String, completion: @escaping (Error?) -> Void) {
        let userRef = Database.database().reference().child("users").child(userId)
        let userData: [String: Any] = [
                    "email": email,
                    "displayName": displayName
        ]
        userRef.setValue(userData){ error, _ in
            completion(error)
            
        }
    }
    

}
