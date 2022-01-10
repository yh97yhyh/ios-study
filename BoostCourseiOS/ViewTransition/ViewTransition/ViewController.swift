//
//  ViewController.swift
//  ViewTransition
//
//  Created by MZ01-KYONGH on 2022/01/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameFiled: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchUpSetButton(_ sender: UIButton) {
        UserInformation.shared.name = nameFiled.text
        UserInformation.shared.age = ageField.text
    }
    
}

