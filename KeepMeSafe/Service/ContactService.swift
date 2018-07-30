//
//  ContactService.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 7/27/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct ContactService {
    
    static func create(contactName: String, contactNumber: String) {
        let currentUser = User.current
        let contact = Contact(name: contactName, number: contactNumber)
        let dict = contact.dictValue
        let contactRef = Database.database().reference().child("contacts").child(currentUser.uid).childByAutoId()
        contactRef.updateChildValues(dict)
    }
    
    static func contacts(for user: User, completion: @escaping ([Contact]) -> Void) {
        let ref = Database.database().reference().child("contacts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let contacts = snapshot.reversed().compactMap(Contact.init)
            completion(contacts)
        })
    }
    
    static func remove(contact: Contact) {
        let currentUser = User.current
        let ref = Database.database().reference().child("contacts").child(currentUser.uid).child(contact.key!)
        if ref != nil{
            ref.removeValue()
        }
        else {
            print("Error with removing contact in ContactService")
        }
        
    }
}
