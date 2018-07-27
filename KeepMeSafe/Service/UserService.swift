//
//  UserService.swift
//  Makestagram
//
//  Created by Gabriel Khouri-Haddad on 7/11/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(user)
        })
    }
    
    //Working on here
//    static func createContact(contactFullName: String, contactPhoneNumber: String) {
//        
//        //can use User.current.uid?? Which is better
//        guard let userUID = Auth.auth().currentUser?.uid else { return }
//        
//        let contactAttrs = ["contact": contactFullName]
//        let ref = Database.database().reference().child("contacts").child(userUID)
//        
//        
//        
//    }
}
