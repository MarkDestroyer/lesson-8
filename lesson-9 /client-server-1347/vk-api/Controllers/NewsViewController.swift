//
//  NewsViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 03.08.2021.
//

import UIKit
import RealmSwift
import Firebase

class NewsViewController: UITableViewController {

    let newsAPI = NewsAPI()
    //var friends: Array<User3> = [User3]()
    let newsDB = NewsDB()
    var token: NotificationToken?
    let config = Realm.Configuration(schemaVersion: 4)
    lazy var mainRealm = try! Realm(configuration: config)
    let ref = Database.database().reference(withPath: "userinfo/news") // ссылка на контейнер/папку в Database
    private var News = [NewsFB]()
    
    var friends: Results<FriendsModel>? {
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
            
            let userinfo = realm.objects(FriendsModel.self)
            
            self.friends = (userinfo)
            
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        newsAPI.getNewsInfo  { [weak self] news in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                for post in news {
                    self.newsDB.add(post)
                    let newsFB = NewsFB(text: post.text, authorImagePath: post.authorImagePath, authorName: post.authorName)
                    let newsRef = self.ref.child(String(post.id))
                    newsRef.setValue(newsFB.toAnyObject())
                }
            }
        }
        self.ref.observe(.value, with: { snapshot in
            var posts: [NewsFB] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let post = NewsFB(snapshot: snapshot) {
                    posts.append(post)
                }
            }
            
            self.News = posts
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return News.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let friend = News[indexPath.row]
            friend.ref?.removeValue()
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        let friend = News[indexPath.row]
        cell.NewsText!.text = ("\(friend.authorName) \(friend.text)")
        cell.self.imageView!.sd_setImage(with:  URL(string: friend.authorImagePath)!)
        cell.self.imageView!.layer.cornerRadius = 50;
        cell.self.imageView!.clipsToBounds = true
        cell.self.imageView!.layer.borderWidth = 5
        cell.self.imageView!.layer.borderColor = UIColor.black.cgColor

        return cell
    }
    

}
