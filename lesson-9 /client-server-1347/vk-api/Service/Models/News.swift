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
    
    @objc dynamic var id: Int = 0
    @objc dynamic var text = ""
    @objc dynamic var likes = 0
    @objc dynamic var userLikes = 0
    @objc dynamic var views = 0
    @objc dynamic var comments = 0
    @objc dynamic var reposts = 0
    @objc dynamic var date = 0
    @objc dynamic var authorImagePath = ""
    @objc dynamic var authorName = ""

    convenience required init(json:JSON) {
        self.init()
        text = json.text.string ?? ""
        likes = json.likes.int ?? 0
        userLikes = json.userLikes.int ?? 0
        views = json.views.int ?? 0
        comments = json.comments.int ?? 0
        reposts = json.reposts.int ?? 0
        date = json.date.int ?? 0
        authorImagePath = json.authorImagePath.string ?? ""
        authorName = json.authorName.string ?? ""
        id = json.id.int ?? 0
    }
    
}

