//
//  AudioStorageService.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 8/2/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import FirebaseStorage

struct AudioStorageService { 
    
    static func uploadAudio(audioFileName: URL, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // 1
        let audioData = try! Data(contentsOf: audioFileName)
        
        // 2
        reference.putData(audioData, metadata: nil, completion: { (metadata, error) in
            // 3
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // 4
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        })
    }

    
//    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
//        // 1
//        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
//            return completion(nil)
//        }
//
//        // 2
//        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
//            // 3
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//                return completion(nil)
//            }
//            
//            // 4
//            reference.downloadURL(completion: { (url, error) in
//                if let error = error {
//                    assertionFailure(error.localizedDescription)
//                    return completion(nil)
//                }
//                completion(url)
//            })
//        })
//    }
}
