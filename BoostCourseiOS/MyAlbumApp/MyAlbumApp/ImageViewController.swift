//
//  ImageViewController.swift
//  MyAlbumApp
//
//  Created by MZ01-KYONGH on 2022/01/14.
//

import UIKit
import Photos

class ImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var albumIndex: Int!
    var photoIndex: Int!
    
    let imageManager = PHCachingImageManager()
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        initImage()
    }
    
    private func initImage() {
        
        let photo = UserPhotos.shared.albums[albumIndex][photoIndex]
        
        let options = PHImageRequestOptions()
        options.resizeMode = .exact

        imageManager.requestImage(for: photo,
                                     targetSize: CGSize(width: photo.pixelWidth , height: photo.pixelHeight),
                                     contentMode: .aspectFill,
                                     options: options) { (image, _) in
            self.imageView.image = image
        }
    }
    
    // MARK: - UIScrollView
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
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
