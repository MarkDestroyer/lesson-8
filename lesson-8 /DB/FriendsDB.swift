//
//  FriendsDB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 24.07.2021.
//

import Foundation
import RealmSwift

protocol FriendsDBProtocol {
    
    func add(_ user: User3)
    func read() -> [User3]
    func delete(_ user: User3)
}

class FriendDB: FriendsDBProtocol {
    
    let config = Realm.Configuration(schemaVersion: 5)
    lazy var mainRealm = try! Realm(configuration: config)
    var user: Array<User3> = [User3]()
    
    func add(_ user: User3) {
        
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
    
    func read() -> [User3] {
        
            let users = mainRealm.objects(User3.self)
            
            users.forEach { print($0.firstName, $0.lastName, $0.id) }
        
            print(mainRealm.configuration.fileURL)
            
            return Array(users)
        
    }
    
    func delete(_ user: User3) {
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
    
    // сохранение погодных данных в realm
        func saveFriendsData(_ info: [User3]) {
    // обработка исключений при работе с хранилищем
            do {
    // получаем доступ к хранилищу
                let realm = try Realm()
                
    // все старые погодные данные для текущего города
                let oldFriendUserInfo = realm.objects(User3.self)
                
    // начинаем изменять хранилище
                realm.beginWrite()
                
    // удаляем старые данные
                realm.delete(oldFriendUserInfo)
                
    // кладем все объекты класса погоды в хранилище
                realm.add(info)
                
    // завершаем изменение хранилища
                try realm.commitWrite()
            } catch {
    // если произошла ошибка, выводим ее в консоль
                print(error)
            }
        }
    
    func loadData() {
            do {
                let realm = try Realm()
                
                let userinfo = realm.objects(User3.self)
                
                self.user = Array(userinfo)
                
            } catch {
    // если произошла ошибка, выводим ее в консоль
                print(error)
            }
        }

}



