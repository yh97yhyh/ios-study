//
//  ImageViewController.swift
//  MyAlbumApp
//
//  Created by MZ01-KYONGH on 2022/01/14.
//

import UIKit
import Photos

class ImageViewController: UIViewController, UIScrollViewDelegate, PHPhotoLibraryChangeObserver {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var albumIndex: Int!
    var photoIndex: Int!
    
    let imageManager = PHCachingImageManager()
    var photo: PHAsset!
    
    var shareImage: UIImage!

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let timeFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "a hh:mm:ss"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerPhotoLibrary()
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        initImage()
        initTitleView()
        initToolbar()
    }
    
    private func initTitleView() {
        guard let date = photo.creationDate else {
            return
        }
        
        datelabel.text = dateFormatter.string(from: date)
        timeLabel.text = timeFormatter.string(from: date)
        self.navigationItem.titleView = titleStackView
    }
    
    private func initToolbar() {
        guard let items = toolbar.items else {
            return
        }
        
        if photo.isFavorite {
            items[1].title = "❤️"
        }
    }
     
    private func initImage() {
        
        photo = UserPhotos.shared.albums[albumIndex][photoIndex]
        
        let options = PHImageRequestOptions()
        options.resizeMode = .exact

        imageManager.requestImage(for: photo,
                                     targetSize: CGSize(width: photo.pixelWidth , height: photo.pixelHeight),
                                     contentMode: .aspectFill,
                                     options: options) { (image, _) in
            self.shareImage = image
            self.imageView.image = image
        }
    }
    
    // MARK: - Photos
    
    func registerPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
        guard let changedCameraRoll = changeInstance.changeDetails(for: UserPhotos.shared.albums[0]) else {
            return
        }
        
        guard let changedAlbum = changeInstance.changeDetails(for: UserPhotos.shared.albums[albumIndex]) else {
            return
        }
        
        UserPhotos.shared.setChanges(changedCameraRoll: changedCameraRoll, changedAlbum: changedAlbum, albumIndex: albumIndex)
        
//        if !changedCameraRoll.removedObjects.isEmpty {
//            DispatchQueue.main.async {
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
        
    }
    
    // MARK: - ToolbarButton
    
    @IBAction func didClickShareButton(_ sender: UIBarButtonItem) {
        guard let shareImage = shareImage else {
            return
        }
        
        var shareObjects: [Any] = []
        
        shareObjects.append(shareImage)
        
        let activitViewController = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
        activitViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activitViewController, animated: true, completion: nil)
    }
    
    @IBAction func didClickDeleteButton(_ sender: UIBarButtonItem) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([self.photo] as NSArray)
        }, completionHandler: nil)
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
