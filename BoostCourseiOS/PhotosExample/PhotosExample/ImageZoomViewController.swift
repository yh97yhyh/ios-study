//
//  ImageZoomViewController.swift
//  PhotosExample
//
//  Created by MZ01-KYONGH on 2022/01/12.
//

import UIKit
import Photos

class ImageZoomViewController: UIViewController, UIScrollViewDelegate {
    
    var asset: PHAsset!
    let imageManager = PHCachingImageManager()
    
    @IBOutlet weak var imageView: UIImageView!
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageManager.requestImage(for: asset,
                                     targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                                     contentMode: .aspectFill,
                                     options: nil) { (image, _) in
            self.imageView.image = image
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
