//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by MZ01-KYONGH on 2021/11/25.
//

import UIKit

class EmojiArtView: UIView {
    
    var backgroundImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
        
    }

    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }

}
