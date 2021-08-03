//
//  LoginViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 31.07.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    let authService = Auth.auth()
    private var token: AuthStateDidChangeListenerHandle!
    
    @IBOutlet weak var LoginTextField: UITextField!
    
    @IBOutlet weak var PassWordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = authService.addStateDidChangeListener{[weak self] auth, user in
            guard user != nil else {return}
            self?.showHomeVC()
        }
    }

    
    private func showHomeVC() {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "MenuViewController") else {return}
        guard let window = self.view.window else {return}
        window.rootViewController = vc
    }
    
    func showAlert(title: String? , text: String?) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okControl = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okControl)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func SignInAction(_ sender: Any?) {
        
        guard let email = LoginTextField.text, LoginTextField.hasText,
              let password = PassWordTextField.text, PassWordTextField.hasText
        else {
            showAlert(title: "Ошибка Ввода", text: "Данные не введены")
            return
        }
        
        authService.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            if let error = error {
                self?.showAlert(title: "Ошибка Firebase", text: error.localizedDescription)
                return
            }
           
            //self?.showHomeVC()
        }
    }
    
    
    @IBAction func SignUpAction(_ sender: Any) {
    
        guard let email = LoginTextField.text, LoginTextField.hasText,
              let password = PassWordTextField.text, PassWordTextField.hasText
        else {
            showAlert(title: "Ошибка Ввода", text: "Данные не введены")
            return
        }
        
        authService.createUser(withEmail: email, password: password) {[weak self] authResult, error in
            
            if let error = error {
                self?.showAlert(title: "Ошибка Firebase", text: error.localizedDescription)
                return
            }
            
            self?.SignInAction(nil)
        }
    }
}
