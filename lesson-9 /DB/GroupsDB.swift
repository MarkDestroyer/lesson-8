//
//  GroupsDB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 24.07.2021.
//

import Foundation
import RealmSwift

protocol GroupsDBProtocol {
    
    func add(_ user: GroupModel)
    func read() -> [GroupModel]
    func delete(_ user: GroupModel)
}

class GroupDB: GroupsDBProtocol {
    
    let config = Realm.Configuration(schemaVersion: 3)
    lazy var mainRealm = try! Realm(configuration: config)
    var group: Array<GroupModel> = [GroupModel]()
    
    func add(_ user: GroupModel) {
        
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
    
    func read() -> [GroupModel] {
        
            let users = mainRealm.objects(GroupModel.self)
            
        users.forEach { print($0.name, $0.photo_max, $0.groupId) }
        
            print(mainRealm.configuration.fileURL)
            
            return Array(users)
        
    }
    
    func delete(_ user: GroupModel) {
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
        func saveGroupData(_ infoGroup: [GroupModel]) {
    // обработка исключений при работе с хранилищем
            do {
    // получаем доступ к хранилищу
                let realm = try Realm()
                
    // все старые погодные данные для текущего города
                let oldGroupInfo = realm.objects(GroupModel.self)
                
    // начинаем изменять хранилище
                realm.beginWrite()
                
    // удаляем старые данные
                realm.delete(oldGroupInfo)
                
    // кладем все объекты класса погоды в хранилище
                realm.add(infoGroup)
                
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
                
                let groupinfo = realm.objects(GroupModel.self)
                
                self.group = Array(groupinfo)
                
            } catch {
    // если произошла ошибка, выводим ее в консоль
                print(error)
            }
        }
}




