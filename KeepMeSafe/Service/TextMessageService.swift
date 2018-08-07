//
//  SendTextMessage.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 7/26/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import Alamofire

class TextMessageService {
    
    //format: "+16504507598"
    static func sendTextMessage(phoneNumber: String?, message: String?) {
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameters: Parameters = [
            "To": phoneNumber ?? "",
            "Body": message ?? ""
        ]
        
        Alamofire.request("https://pearl-partridge-8635.twil.io/sms", method: .post, parameters: parameters, headers: headers).response { response in
            print(response)
            
        }
    }
    
}
