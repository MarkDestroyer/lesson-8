//  GroupAPI.swift
//  client-server-1347
//
//  Created by Марк Киричко on 14.07.2021.
//

import Foundation
import Alamofire
import DynamicJSON
import RealmSwift


final class GroupAPI {
    
    let baseUrl = "https://api.vk.com/method"
    let token = Session.shared.token
    let cliendId = Session.shared.userId
    let version = "5.21"
    let groupDB = GroupDB()
   

    //DynamicJSON
    func getGroupInfo(completion: @escaping([GroupModel])->()) {
        
        let method = "/groups.get"
        
        let parameters: Parameters = [
            "access_token": token,
            "group_id": cliendId,
            "extended": "1",
            "fields": "photo_max",
            "count": "45",
            "v": version,
        ]
       
        
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            
            guard let data = response.data else { return }
            print(data.prettyJSON as Any)
            
            guard let items = JSON(data).response.items.array else { return }
            
            let group = items.map { GroupModel(json: $0)}
           
            DispatchQueue.main.async {
               self.groupDB.saveGroupData(group)
               let groupsFromDB = self.groupDB.read()
               completion(groupsFromDB)
            }
        }
    }
}

