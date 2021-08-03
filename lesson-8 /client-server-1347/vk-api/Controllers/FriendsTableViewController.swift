//
//  FriendsTableViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 20.07.2021.
//

import UIKit
import RealmSwift
import Firebase

class FriendsViewController: UITableViewController {
    
    let friendsAPI = FriendsAPI()
    //var friends: Array<User3> = [User3]()
    let friendDB = FriendDB()
    var token: NotificationToken?
    let config = Realm.Configuration(schemaVersion: 4)
    lazy var mainRealm = try! Realm(configuration: config)
    let ref = Database.database().reference(withPath: "userinfo/friends") // ссылка на контейнер/папку в Database
    private var friendsFB = [FriendsFB]()
    
    var friends: Results<User3>? {
        didSet {
            
            token = friends?.observe({ changes in
                
                switch changes {
                case .initial(let results):
                    print("initial", results)
                    
                    self.tableView.reloadData()
                    
                case .update(let results, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                    print("update", results)
                    
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                              with: .automatic)
                    self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                              with: .automatic)
                    self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                              with: .automatic)
                    self.tableView.endUpdates()
                    
                    
                case .error(let error):
                    print("Error", error.localizedDescription)
                }
            })
        }
    }
    
    func loadData() {
        do {
            let realm = try Realm()
            
            let userinfo = realm.objects(User3.self)
            
            self.friends = (userinfo)
            
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        friendsAPI.getFriends3  { [weak self] friends in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                for friend in friends {
                    self.friendDB.add(friend)
                    let friendFB = FriendsFB(name: friend.firstName, lastname: friend.lastName, image: friend.photo_max)
                    let friendRef = self.ref.child(String(friend.id))
                    friendRef.setValue(friendFB.toAnyObject())
                }
            }
        }
        self.ref.observe(.value, with: { snapshot in
            var friends: [FriendsFB] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let friend = FriendsFB(snapshot: snapshot) {
                    friends.append(friend)
                }
            }
            
            self.friendsFB = friends
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsFB.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let friend = friendsFB[indexPath.row]
            friend.ref?.removeValue()
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier, for: indexPath) as! FriendsTableViewCell
        
        let friend = friendsFB[indexPath.row]
        cell.nameLabel.text = ("\(friend.name) \(friend.lastname)")
        cell.self.FriendImage!.sd_setImage(with:  URL(string: friend.image!)!)
        cell.self.FriendImage.layer.cornerRadius = 50;
        cell.self.FriendImage.clipsToBounds = true
        cell.self.FriendImage.layer.borderWidth = 5
        cell.self.FriendImage.layer.borderColor = UIColor.black.cgColor

        return cell
    }
    
}

