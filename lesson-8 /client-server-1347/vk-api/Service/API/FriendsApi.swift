//
//  PhotoApi.swift
//  client-server-1347
//
//  Created by Марк Киричко on 14.07.2021.
//

import Foundation
import Alamofire
import DynamicJSON
import RealmSwift

final class FriendsAPI {
    
    let baseUrl = "https://api.vk.com/method"
    let token = Session.shared.token
    let cliendId = Session.shared.userId
    let version = "5.21"
    let friendDB = FriendDB()
    
    
    //DynamicJSON
    func getFriends3(completion: @escaping([User3])->()) {
        
        let method = "/friends.get"
        
        let parameters: Parameters = [
            "access_token": token,
            "order": "hints",
            "fields": "photo_max",
            "v": version,
            "user_id": cliendId]
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else { return }
            print(data.prettyJSON as Any)

            guard let items = JSON(data).response.items.array else { return }
                
            let friends = items.map { User3(json: $0)}
            
            DispatchQueue.main.async {
                self.friendDB.saveFriendsData(friends)
                let friendsFromDB = self.friendDB.read()
                completion(friendsFromDB)
            }
        }
    }
}
