//
//  GroupsFB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 31.07.2021.
//

import Foundation
import Firebase

class GroupsFB {
    // 1
    let name: String
    let ref: DatabaseReference?
    let image: String
    
    init(name: String, image: String) {
        // 2
        self.ref = nil
        self.name = name
        self.image = image
    }
    
    init?(snapshot: DataSnapshot) {
        // 3
        guard
            let value = snapshot.value as? [String: Any],
            let name = value["name"] as? String,
            let image = value["image"] as? String
        else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.name = name
        self.image = image
    }
    
    func toAnyObject() -> [String: Any] {
        // 4
        return [
            "name": name,
            "image": image
        ]
    }
}


