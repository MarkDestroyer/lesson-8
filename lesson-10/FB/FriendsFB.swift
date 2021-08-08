//
//  FriendsFB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 31.07.2021.
//

import Foundation
import Firebase

class FriendsFB {
    // 1
    let name: String
    let lastname: String
    let ref: DatabaseReference?
    let image: String?
    
    init(name: String, lastname: String, image: String) {
        // 2
        self.ref = nil
        self.name = name
        self.lastname = lastname
        self.image = image
    }
    
    init?(snapshot: DataSnapshot) {
        // 3
        guard
            let value = snapshot.value as? [String: Any],
            let lastname = value["lastname"] as? String,
            let image =  value["image"] as? String,
            let name = value["name"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.name = name
        self.lastname = lastname
        self.image = image
    }
    
    func toAnyObject() -> [String: Any] {
        // 4
        return [
            "name": name,
            "lastname": lastname,
            "image": image
        ]
    }
}


