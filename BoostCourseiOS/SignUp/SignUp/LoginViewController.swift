//
//  ViewController.swift
//  SignUp
//
//  Created by MZ01-KYONGH on 2022/01/10.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !UserInformation.user.isEmpty() {
            idTextField.text = UserInformation.user.id
        }
    }


}

