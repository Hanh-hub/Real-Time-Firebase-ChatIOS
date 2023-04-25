//
//  ViewModel.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/13/23.
//

import Foundation
import Firebase
import FirebaseAuth

class LogInViewModel {
    var authListener: AuthStateDidChangeListenerHandle?
    
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
           Auth.auth().signIn(withEmail: email, password: password) {  result, error in
               if error != nil {
                   completion(false)
               } else {
                   
                   completion(true)
               }
           }
    }
    
    func signup(email: String, password: String, completion: @escaping (Bool) -> Void) {
           Auth.auth().createUser(withEmail: email, password: password) { result, error in
               if error != nil {
                   completion(false)
               } else {
                   completion(true)
               }
           }
       }
    
   
    
    
    func observeAuthChanges(completion: @escaping (Bool) -> Void) {
            authListener = Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    print("User is logged in with email: \(user.email ?? "")")
                    completion(true)
                } else {
                    print("User is logged out")
                    completion(false)
                }
            }
    }
    
    func stopObservingAuthChanges() {
           if let listener = authListener {
               Auth.auth().removeStateDidChangeListener(listener)
           }
    }
    
}
