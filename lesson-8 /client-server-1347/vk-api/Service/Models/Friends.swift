//
//  Photo.swift
//  client-server-1347
//
//  Created by Марк Киричко on 14.07.2021.
//

import Foundation
import Alamofire
import DynamicJSON
import RealmSwift

class User3: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var lastName: String = ""
    @objc dynamic var photo_max: String = ""
    @objc dynamic var firstName: String = ""
    
    
    
    convenience required init(json: JSON) {
        self.init()
        self.id = json.id.int ?? 0 //json["id"] as! Int
        self.firstName = json.first_name.string ?? "" //json["first_name"] as! String
        self.lastName = json.last_name.string ?? "" //json["last_name"] as! String
        self.photo_max = json.photo_max.string ?? ""
    }
}
