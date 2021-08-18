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
    let postID: Int
    let text: String
    let ref: DatabaseReference?
    let photo: String
    
    init(postID: Int, text: String, photo: String) {
        // 2
        self.ref = nil
        self.postID = postID
//        self.authorImagePath = authorImagePath
//        self.authorName = authorName
        self.text = text
        self.photo = photo
    }
    
    init?(snapshot: DataSnapshot) {
        // 3
        guard
            let value = snapshot.value as? [String: Any],
            let postID = value["postID"] as? Int,
            let text = value["text"] as? String,
            let photo = value["photo"] as? String
            else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.postID = postID
        self.text = text
        self.photo = photo
//        self.authorImagePath = authorImagePath
//        self.authorName = authorName
    }
    
    func toAnyObject() -> [String: Any] {
        // 4
        return [
            "postID": postID,
            "text": text,
            "photo": photo
//            "authorName": authorName,
        ]
    }
}




