//
//  ProfileDB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 24.07.2021.
//

import Foundation
import RealmSwift

protocol PersonDBProtocol {
    
    func add(_ user: ProfileU)
    func read() -> [ProfileU]
    func delete(_ user: ProfileU)
}

class PersonDB: PersonDBProtocol {
    
    let config = Realm.Configuration(schemaVersion: 5)
    lazy var mainRealm = try! Realm(configuration: config)
    
    var user: Array<ProfileU> = [ProfileU]()
    
    func add(_ user: ProfileU) {
        
        //DispatchQueue.main.async {
            do {
                self.mainRealm.beginWrite()
                self.mainRealm.add(user)
                try self.mainRealm.commitWrite()
                
            } catch {
                print(error.localizedDescription)
            }
        //}
        
    }
    
    func read() -> [ProfileU] {
        
            let users = mainRealm.objects(ProfileU.self)
            
            users.forEach { print($0.firstName, $0.lastName, $0.id) }
        
            print(mainRealm.configuration.fileURL)
            
            return Array(users)
        
    }
    
    func delete(_ user: ProfileU) {
        //DispatchQueue.main.async {
            do {
                self.mainRealm.beginWrite()
                self.mainRealm.delete(user)
                try self.mainRealm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
        //}
        
    }
    
    
        func saveUserData(_ info: (ProfileU)) {
            do {
                let realm = try Realm()
                let oldUserInfo = realm.objects(ProfileU.self)
                
                realm.beginWrite()
    
                realm.delete(oldUserInfo)
                
                realm.add(info)
                
                try realm.commitWrite()
            } catch {
    
                print(error)
            }
        }
    
    func loadData() {
            do {
                let realm = try Realm()
                
                let userinfo = realm.objects(ProfileU.self)
                
                self.user = Array(userinfo)
                
            } catch {
    // если произошла ошибка, выводим ее в консоль
                print(error)
            }
        }


}


