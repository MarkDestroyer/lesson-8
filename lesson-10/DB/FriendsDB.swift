//
//  FriendsDB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 24.07.2021.
//

import Foundation
import RealmSwift

protocol FriendsDBProtocol {
    
    func add(_ user: FriendsModel)
    func read() -> [FriendsModel]
    func delete(_ user: FriendsModel)
}

class FriendDB: FriendsDBProtocol {
    
    let config = Realm.Configuration(schemaVersion: 5)
    lazy var mainRealm = try! Realm(configuration: config)
    var user: Array<FriendsModel> = [FriendsModel]()
    
    func add(_ user: FriendsModel) {
        
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
    
    func read() -> [FriendsModel] {
        
            let users = mainRealm.objects(FriendsModel.self)
            
            users.forEach { print($0.firstName, $0.lastName, $0.id) }
        
            print(mainRealm.configuration.fileURL)
            
            return Array(users)
        
    }
    
    func delete(_ user: FriendsModel) {
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
        func saveFriendsData(_ info: [FriendsModel]) {
    // обработка исключений при работе с хранилищем
            do {
    // получаем доступ к хранилищу
                let realm = try Realm()
                
    // все старые погодные данные для текущего города
                let oldFriendUserInfo = realm.objects(FriendsModel.self)
                
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
                
                let userinfo = realm.objects(FriendsModel.self)
                
                self.user = Array(userinfo)
                
            } catch {
    // если произошла ошибка, выводим ее в консоль
                print(error)
            }
        }

}



