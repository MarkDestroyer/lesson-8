//
//  NewsAPI.swift
//  client-server-1347
//
//  Created by Марк Киричко on 04.08.2021.
//

import Foundation
import Alamofire
import DynamicJSON
import RealmSwift


final class NewsAPI {
    
    let baseUrl = "https://api.vk.com/method/"
    let token = Session.shared.token
    let cliendId = Session.shared.userId
    let version = "5.21"
    let newsDB = NewsDB()
   

    //DynamicJSON
    func getNewsInfo(completion: @escaping([NewsRealm])->()) {
        
        let method = "newsfeed.get"
        
        let parameters: Parameters = [
            "access_token": token,
                          "user_id": cliendId,
                          "source_ids": "friends,groups,pages",
                          "filters": "post, date",
                          "count": "100",
                          "fields": "first_name,last_name,name,photo_100,online",
                          "v": version
        ]
       
        
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            
            guard let data = response.data else { return }
            print(data.prettyJSON as Any)
            
            guard let items = JSON(data).response.items.array else { return }
            
            let news = items.map { NewsRealm(json: $0)}
           
            DispatchQueue.main.async {
               self.newsDB.saveNewsData(news)
               let newsFromDB = self.newsDB.read()
               completion(newsFromDB)
            }
        }
    }
}


