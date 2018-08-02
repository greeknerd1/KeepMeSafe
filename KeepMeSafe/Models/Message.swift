//
//  Message.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 8/1/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Message {
    var key: String?
    var mainMessage: String
    var locationMessage: String
    
    init(mainMessage: String, locationMessage: String) {
        self.mainMessage = mainMessage
        self.locationMessage = locationMessage
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let mainMessage = dict["mainMessage"] as? String,
            let locationMessage = dict["locationMessage"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.mainMessage = mainMessage
        self.locationMessage = locationMessage
    }

    
    var dictValue: [String: Any] {
        return ["mainMessage": mainMessage, "locationMessage": locationMessage]
    }
    
    
}
