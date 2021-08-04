//
//  MenuViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 15.07.2021.
//

import UIKit
import Firebase

class MenuViewController: UITabBarController {
    let authService = Auth.auth()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
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
    
}
