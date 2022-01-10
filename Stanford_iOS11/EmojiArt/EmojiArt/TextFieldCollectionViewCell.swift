//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by MZ01-KYONGH on 2021/11/26.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField! {
        didSet { textField.delegate = self }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
