//
//  NewsDB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 04.08.2021.
//

import Foundation
import RealmSwift

protocol NewsDBProtocol {
    
    func add(_ user: NewsRealm)
    func read() -> [NewsRealm]
    func delete(_ user: NewsRealm)
}

class NewsDB: NewsDBProtocol {
    
    let config = Realm.Configuration(schemaVersion: 3)
    lazy var mainRealm = try! Realm(configuration: config)
    var group: Array<NewsRealm> = [NewsRealm]()
    
    func add(_ user: NewsRealm) {
        
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
    
    func read() -> [NewsRealm] {
        
            let users = mainRealm.objects(NewsRealm.self)
            
        users.forEach { print($0.date, $0.authorName, $0.likes) }
        
            print(mainRealm.configuration.fileURL)
            
            return Array(users)
        
    }
    
    func delete(_ user: NewsRealm) {
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
        func saveNewsData(_ infoGroup: [NewsRealm]) {
    // обработка исключений при работе с хранилищем
            do {
    // получаем доступ к хранилищу
                let realm = try Realm()
                
    // все старые погодные данные для текущего города
                let oldGroupInfo = realm.objects(NewsRealm.self)
                
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
                
                let groupinfo = realm.objects(NewsRealm.self)
                
                self.group = Array(groupinfo)
                
            } catch {
    // если произошла ошибка, выводим ее в консоль
                print(error)
            }
        }
}





