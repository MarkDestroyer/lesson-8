//
//  GroupsTableViewCell.swift
//  client-server-1347
//
//  Created by Марк Киричко on 21.07.2021.
//

import UIKit
import RealmSwift

class GroupsTableViewCell: UITableViewCell {

    static let identifier = "GroupsTableViewCell"
    var group: Array<GroupModel> = [GroupModel]()
    var groupDB = GroupDB()
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    
   
    
    func loadData(_ group: GroupModel) {
        do {
            let realm = try Realm()
            
            let userinfo = realm.objects(GroupModel.self)
            
            self.group = Array(userinfo)
            
            groupName.text = group.name
            groupImage!.sd_setImage(with:  URL(string: group.photo_max)!)
            self.groupImage.layer.cornerRadius = 50;
            self.groupImage.clipsToBounds = true
            self.groupImage.layer.borderWidth = 5
            self.groupImage.layer.borderColor = UIColor.black.cgColor
            let tap = UITapGestureRecognizer(target: self, action: #selector(viewOnTapped))
            groupImage.addGestureRecognizer(tap)
            groupImage.isUserInteractionEnabled = true
            self.groupDB.read()
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }


    private func springAnimationGroups() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 300
        animation.mass = 3
        animation.duration = 3
        animation.beginTime = CACurrentMediaTime() + 1
        groupImage.layer.add(animation, forKey: nil)
    }

    @objc func viewOnTapped() {
        springAnimationGroups()
    }

}
