//
//  AudioService.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 8/2/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import UIKit

struct AudioService {
    
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newAudioReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("audio/\(uid)/\(timestamp).mp3")
    }
    
    //this is the function called when I want to upload a file to Storage, 
    static func create(audioURL: URL, date: String) {
        let audioRef = newAudioReference()
        AudioStorageService.uploadAudio(audioFileName: audioURL, at: audioRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }

            let audioURLString = downloadURL.absoluteString
            create(audioURLString: audioURLString, date: date) //stores downloadURL of audio in Firebase Database
        }
    }
    
    //this creates a reference in the Firebase database, and is called in the above function **DONT CALL THIS FUNCTION**
    static func create(audioURLString: String, date: String) {
        let currentUser = User.current
        let audio = Audio(audioURLString: audioURLString, date: date)
        let dict = audio.dictValue
        let audioRef = Database.database().reference().child("audio").child(currentUser.uid).childByAutoId()
        audioRef.updateChildValues(dict)
    }
    
    static func getAllAudios(for user: User, completion: @escaping ([Audio]) -> Void) {
        let ref = Database.database().reference().child("audio").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let allAudios = snapshot.reversed().compactMap(Audio.init)
            completion(allAudios)
        })
    }
    
    //change so it removes the reference in Firebase Storage too
    static func removeAudio(audio: Audio) {
        let currentUser = User.current
        let ref = Database.database().reference().child("audio").child(currentUser.uid).child(audio.key!)
        if ref != nil{
            ref.removeValue()
        }
        else {
            print("Error with removing contact in AudioService")
        }
    }
}
