//
//  MessageService.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 8/1/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct MessageService {
    
    static func create(mainMessageName: String, locationMessageName: String) {
        let currentUser = User.current
        let message = Message(mainMessage: mainMessageName, locationMessage: locationMessageName)
        let dict = message.dictValue
        let messageRef = Database.database().reference().child("messages").child(currentUser.uid).childByAutoId()
        messageRef.updateChildValues(dict)
    }
    
    static func messages(for user: User, completion: @escaping ([Message]) -> Void) {
        let ref = Database.database().reference().child("messages").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let messages = snapshot.reversed().compactMap(Message.init)
            completion(messages)
        })
    }
    
    static func edit(message: Message, mainMessage: String, locationMessage: String) {
        let currentUser = User.current
        let ref = Database.database().reference().child("messages").child(currentUser.uid).child(message.key!)
        if ref != nil {
            ref.setValue(["mainMessage": mainMessage, "locationMessage": locationMessage])
        }
        else {
            print("Error with removing message in MessageService")
        }
    }
}

