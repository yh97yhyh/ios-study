//
//  ViewController.swift
//  AsyncExample
//
//  Created by MZ01-KYONGH on 2022/01/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    @IBAction func touchUpDownloadButton(_ sender: UIButton) {
        // 이미지 다운로드 -> 이미지 뷰에 셋팅
        
        guard let imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg") else {
            return
        }
        
        OperationQueue().addOperation {
            let imageData: Data?
            do {
                imageData = try Data.init(contentsOf: imageURL)
            } catch {
                return
            }
            
            guard let imageData = imageData else {
                return
            }
            
            self.image = UIImage(data: imageData)
            
        }
        
        guard let image = image else {
            return
        }

        self.imageView.image = image
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

