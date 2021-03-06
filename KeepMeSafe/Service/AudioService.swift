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
    
    static func newAudioReference(_ date: String) -> StorageReference {
        let uid = User.current.uid
        
        return Storage.storage().reference().child("audio/\(uid)/\(date).mp3")
    }
    
    //this is the function called when I want to upload a file to Storage, 
    static func create(audioURL: URL, date: String, duration: String) {
        let audioRef = newAudioReference(date)
        AudioStorageService.uploadAudio(audioFileName: audioURL, at: audioRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }

            let audioURLString = downloadURL.absoluteString
            create(audioURLString: audioURLString, date: date, duration: duration) //stores downloadURL of audio in Firebase Database
        }
    }
    
    //this creates a reference in the Firebase database, and is called in the above function **DONT CALL THIS FUNCTION**
    static func create(audioURLString: String, date: String, duration: String) {
        let currentUser = User.current
        let audio = Audio(audioURLString: audioURLString, date: date, duration: duration)
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
        
        let storageRef = Storage.storage().reference().child("audio/\(currentUser.uid)/\(audio.date).mp3")
        storageRef.delete { (error) in
            if (error != nil) {
                //print("Error deleting audiofile in Firebase Storage at: \(storageRef.name)")
            }
        }
        
        let databaseRef = Database.database().reference().child("audio").child(currentUser.uid).child(audio.key!)
        if databaseRef != nil{
            databaseRef.removeValue()
        }
        else {
            //print("Error with deleting audiofile in Firebase Database in AudioService")
        }
    }
}
