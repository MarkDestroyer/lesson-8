//
//  GroupsTableViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 20.07.2021.
//

import UIKit
import RealmSwift
import Firebase

class GroupsViewController: UITableViewController {
    
    let groupAPI = GroupAPI()
    //var groups: Array<GroupModel> = [GroupModel]()
    let groupDB = GroupDB()
    var token: NotificationToken?
    let config = Realm.Configuration(schemaVersion: 4)
    lazy var mainRealm = try! Realm(configuration: config)
    let ref = Database.database().reference(withPath: "userinfo/groups") // ссылка на контейнер/папку в Database
    private var groupsFB = [GroupsFB]()
    
    var groups: Results<GroupModel>? {
        didSet {
            
            token = groups?.observe({ changes in
                
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
            
            let userinfo = realm.objects(GroupModel.self)
            
            self.groups = (userinfo)
            
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
    
//    @IBAction func addGroup(_ sender: Any) {
//        let alertVC = UIAlertController(title: "Добавить группу", message: nil, preferredStyle: .alert)
//
//            let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
//                guard let textField = alertVC.textFields?.first,
//                      let name = textField.text else { return }
//
//                // 1
//                let group = GroupsFB(name: name)
//                // 2
//                let groupRef = self.ref.child(name.lowercased())
//
//                groupRef.setValue(group.toAnyObject())
//            }
//
//            let cancelAction = UIAlertAction(title: "Отмена",
//                                                 style: .cancel)
//
//            alertVC.addTextField()
//
//            alertVC.addAction(saveAction)
//            alertVC.addAction(cancelAction)
//
//            present(alertVC, animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        groupAPI.getGroupInfo  { [weak self] groups in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                for group in groups {
                    self.groupDB.add(group)
                    let friendFB = GroupsFB(name: group.name, image: group.photo_max)
                    let friendRef = self.ref.child(String(group.groupId))
                    friendRef.setValue(friendFB.toAnyObject())
                }
            }
        }
        self.ref.observe(.value, with: { snapshot in
            var groups: [GroupsFB] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let group = GroupsFB(snapshot: snapshot) {
                    groups.append(group)
                }
            }
            
            self.groupsFB = groups
            self.tableView.reloadData()
        })
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsFB.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let group = groupsFB[indexPath.row]
            group.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupsTableViewCell.identifier, for: indexPath) as! GroupsTableViewCell
        
        let group = groupsFB[indexPath.row]
        cell.groupName.text = group.name
        cell.self.groupImage!.sd_setImage(with:  URL(string: group.image)!)
        cell.self.groupImage.layer.cornerRadius = 50;
        cell.self.groupImage.clipsToBounds = true
        cell.self.groupImage.layer.borderWidth = 5
        cell.self.groupImage.layer.borderColor = UIColor.black.cgColor

        
        return cell
    }
}

