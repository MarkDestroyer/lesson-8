//
//  Group.swift
//  client-server-1347
//
//  Created by Марк Киричко on 14.07.2021.
//

import Foundation
import Alamofire
import DynamicJSON
import RealmSwift

class GroupModel: Object {
    
    @objc dynamic var groupId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo_max: String = ""
    
    convenience required init(json:JSON) {
        self.init()
        groupId = json.id.int ?? 0
        name = json.name.string ?? ""
        photo_max = json.photo_max.string ?? ""
    }
}
