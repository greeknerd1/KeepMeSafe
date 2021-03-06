//
//  Audio.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 8/2/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Audio {
    
    var key: String?
    var audioURLString: String
    var date: String
    var duration: String
    
    init(audioURLString: String, date: String, duration: String) {
        self.audioURLString = audioURLString
        self.date = date
        self.duration = duration
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let audioURLString = dict["audioURLString"] as? String,
            let date = dict["date"] as? String,
            let duration = dict["duration"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.audioURLString = audioURLString
        self.date = date
        self.duration = duration
    }
    
    var dictValue: [String: Any] {
        return ["audioURLString": audioURLString, "date": date, "duration": duration]
    }
    
    
}
