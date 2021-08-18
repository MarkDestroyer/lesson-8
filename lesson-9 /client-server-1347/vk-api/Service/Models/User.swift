//
//  User1.swift
//  client-server-1347
//
//  Created by Artur Igberdin on 12.07.2021.
//

import Foundation
import Alamofire
import DynamicJSON
import RealmSwift

class Profile: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var lastName: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var photo_max: String = ""
    @objc dynamic var home_town: String = ""
    @objc dynamic var bdate: String = ""
    
    
    convenience required init(json: JSON) {
        self.init()
        self.id = json.id.int ?? 0 //json["id"] as! Int
        self.firstName = json.first_name.string ?? "" //json["first_name"] as! String
        self.lastName = json.last_name.string ?? ""  //json["last_name"] as! String
        self.photo_max = json.photo_max.string ?? ""
        self.home_town = json.home_town.string ?? ""
        self.bdate = json.bdate.string ?? ""
       
    }
}
