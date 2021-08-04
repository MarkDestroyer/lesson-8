//
//  News.swift
//  client-server-1347
//
//  Created by Марк Киричко on 04.08.2021.
//

import Foundation
import Alamofire
import DynamicJSON
import RealmSwift

class NewsRealm: Object {
    
    @objc dynamic var postID: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var trackCode: String = ""
    @objc dynamic var photo_max: String = ""
    
    convenience required init(json:JSON) {
        self.init()
        postID = json.post_id.int ?? 0
        text = json.text.string ?? "нет заголовка "
        trackCode = json.trackCode.string ?? ""
        photo_max = json.photo_max.string ?? ""
    }
    
}

