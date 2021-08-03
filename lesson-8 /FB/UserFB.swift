//
//  UserFB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 01.08.2021.
//

import Foundation
import Firebase

class UserFB {
    // 1
    let name: String
    let lastname: String
    let ref: DatabaseReference?
    let image: String
    let bd: String
    let town: String
    
    init(name: String, lastname: String, image: String, bd: String, town: String) {
        // 2
        self.ref = nil
        self.name = name
        self.lastname = lastname
        self.image = image
        self.bd = bd
        self.town = town
    }
    
    init?(snapshot: DataSnapshot) {
        // 3
        guard
            let value = snapshot.value as? [String: Any],
            let lastname = value["lastname"] as? String,
            let image = value["image"] as? String,
            let bd = value["bd"] as? String,
            let town = value["town"] as? String,
            let name = value["name"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.name = name
        self.lastname = lastname
        self.image = image
        self.bd = bd
        self.town = town
    }
    
    func toAnyObject() -> [String: Any] {
        // 4
        return [
            "name": name,
            "lastname": lastname,
            "image": image,
            "bd": bd,
            "town": town
        ]
    }
}



