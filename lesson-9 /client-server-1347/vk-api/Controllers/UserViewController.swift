//
//  FriendsViewController.swift
//  client-server-1347
//
//  Created by Artur Igberdin on 12.07.2021.
//

import UIKit
import RealmSwift
import SDWebImage
import Firebase


class UserProfileViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var bd: UILabel!
    
    let userApi = UserAPI()
    var user: Array<Profile> = [Profile]()
    let personDB = PersonDB()
    let authService = Auth.auth()
    private var User = [UserFB]()
    let ref = Database.database().reference(withPath: "userinfo/user") // ссылка на контейнер/папку в Database
    
    
    func loadData() {
        do {
            let realm = try Realm()
            
            let userinfo = realm.objects(Profile.self)
            
            self.user = Array(userinfo)
            
            for person in user {
                let firstname = person.firstName
                let lastname = person.lastName
                let fullname = ("\(firstname) \(lastname)")
                let town = person.home_town
                let birthday = person.bdate
                nameLabel.text = fullname
                townLabel.text = town
                bd.text = birthday
                imageView.sd_setImage(with:  URL(string: person.photo_max)!)
                self.imageView.layer.cornerRadius = 75;
                self.imageView.clipsToBounds = true
                self.imageView.layer.borderWidth = 5
                self.imageView.layer.borderColor = UIColor.black.cgColor
                let tap = UITapGestureRecognizer(target: self, action: #selector(viewOnTapped))
                imageView.addGestureRecognizer(tap)
                imageView.isUserInteractionEnabled = true
            }
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
    
    
    private func springAnimationFriends() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 1000
        animation.mass = 3
        animation.duration = 3
        animation.beginTime = CACurrentMediaTime() + 1
        imageView.layer.add(animation, forKey: nil)
    }
    
    @objc func viewOnTapped() {
        springAnimationFriends()
    }
    
    private func showLoginVC() {
        guard let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") else {return}
        guard let window = self.view.window else {return}
        window.rootViewController = vc
    }
    
    
    
    @IBAction func SignOutAction(_ sender: Any) {
        
        try?authService.signOut()
        showLoginVC()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userApi.getUserInfo {[weak self] userinfo in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                
                self.personDB.add(userinfo)
                let friendFB = UserFB(name: userinfo.firstName, lastname: userinfo.lastName, image: userinfo.photo_max, bd: userinfo.bdate, town: userinfo.home_town)
                let friendRef = self.ref.child(String(userinfo.id))
                friendRef.setValue(friendFB.toAnyObject())
            
        }
            self.ref.observe(.value, with: { [self] snapshot in
            var info: [UserFB] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let profile = UserFB(snapshot: snapshot) {
                    info.append(profile)
                    self.nameLabel.text = ("\(profile.name) \(profile.lastname)")
                    self.bd.text = profile.bd
                    self.townLabel.text = profile.town
                    self.imageView.sd_setImage(with:  URL(string: profile.image)!)
                    self.imageView.layer.cornerRadius = 75;
                    self.imageView.clipsToBounds = true
                    self.imageView.layer.borderWidth = 5
                    self.imageView.layer.borderColor = UIColor.black.cgColor
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewOnTapped))
                    self.imageView.addGestureRecognizer(tap)
                    self.imageView.isUserInteractionEnabled = true
                }
            }
            
            self.User = info
        })
        
    }
}

}
