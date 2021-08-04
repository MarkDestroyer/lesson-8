//
//  NewsFB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 04.08.2021.
//

import Foundation
import Firebase

class NewsFB {
    // 1
    let text: String
    let authorImagePath: String
    let ref: DatabaseReference?
    let authorName: String

    
    init(text: String, authorImagePath: String, authorName: String) {
        // 2
        self.ref = nil
        self.text = text
        self.authorImagePath = authorImagePath
        self.authorName = authorName
        
    }
    
    init?(snapshot: DataSnapshot) {
        // 3
        guard
            let value = snapshot.value as? [String: Any],
            let authorImagePath = value["authorImagePath"] as? String,
            let authorName = value["authorName"] as? String,
            let text = value["text"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.text = text
        self.authorImagePath = authorImagePath
        self.authorName = authorName
    }
    
    func toAnyObject() -> [String: Any] {
        // 4
        return [
            "text": text,
            "authorImagePath": authorImagePath,
            "authorName": authorName,
        ]
    }
}




