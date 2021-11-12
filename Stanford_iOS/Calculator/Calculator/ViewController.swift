//
//  ViewController.swift
//  Calculator
//
//  Created by MZ01-KYONGH on 2021/11/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.titleLabel!.text!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathmeticalSymbol = sender.titleLabel?.text {
            if mathmeticalSymbol == "π" {
                display.text = String(Double.pi)
            }
        }

    }
}

