//
//  ViewController.swift
//  HelloWorld
//
//  Created by MZ01-KYONGH on 2021/11/11.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstTextView: UITextView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var firstTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextView.text = "Hello"
        myLabel.text = "What's your name?"
    }
    
    @IBAction func firstButton(_ sender: Any) {
        let name = firstTextField.text!
        myLabel.text = "Hello \(name)"
    }
    

    @IBAction func changeToWhite(_ sender: Any) {
        view.backgroundColor = UIColor.white
    }
    
    @IBAction func chnageBackgroundColorToBlack(_ sender: Any) {
        view.backgroundColor = UIColor.black
    }
    
    @IBAction func changeToBlue(_ sender: Any) {
        view.backgroundColor = UIColor.blue
    }
    
    
    
}

