//
//  UserViewModel.swift
//  FireBaseDemo
//
//  Created by Hanh Vo on 4/18/23.
//

import Foundation
import FirebaseDatabase
import Firebase

class UserListViewModel {
    var users: [User] = []
    private let userRef = Database.database().reference().child("users")
    
    let currentUser: User? = nil
    
    func signOut(completion: @escaping (Bool) -> Void) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                completion(true)
            } catch {
                print("Error signing out: \(error.localizedDescription)")
                completion(false)
            }
        }
     }
    
    func fetchUsers(completion: @escaping (Bool) -> Void) {
        userRef.observeSingleEvent(of: .value) { snapshot in
            guard let userDict = snapshot.value as? [String: [String: Any]] else {
                completion(false)
                return
            }
            
            self.users = userDict.compactMap { key, value in
                guard let email = value["email"] as? String,
                      let displayName = value["displayName"] as? String else {
                    return nil
                }
                return User(uid: key, email: email, displayName: displayName)
            }
            completion(true)
        }
    }
    
    func getNumOfRow() -> Int{
        return users.count
    }
    
    func getCurrentUser(completion: @escaping (Result<String, Error>) ->Void){
        guard let  currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "UserListViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            return
        }
        let currentUserRef = userRef.child(currentUserId)
        currentUserRef.observeSingleEvent(of: .value) {dataSnapshot in
            if dataSnapshot.exists(),
               let value = dataSnapshot.value as? [String: AnyObject],
               let displayName = value["displayName"] as? String{
                completion(.success(displayName))
                
            } else {
                completion(.failure(NSError(domain: "UserListViewModel", code: -2, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
            }
        }
    }
}

