//
//  Contact.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 7/27/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Contact {
    var key: String?
    var name: String
    var number: String
    
    init(name: String, number: String) {
        self.name = name
        self.number = number
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["name"] as? String,
            let number = dict["number"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.name = name
        self.number = number
    }
    
    var dictValue: [String: Any] {
        return ["name": name, "number": number]
    }
    
    
}
