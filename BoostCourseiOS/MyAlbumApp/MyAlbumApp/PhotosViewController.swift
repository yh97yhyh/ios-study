//
//  PhotosViewController.swift
//  MyAlbumApp
//
//  Created by MZ01-KYONGH on 2022/01/13.
//

import UIKit
import Photos

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PHPhotoLibraryChangeObserver {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "photoCell"
    let flowLayout = UICollectionViewFlowLayout()
    let halfWidth = UIScreen.main.bounds.width / 3.3333
    let imageSize = UIScreen.main.bounds.width / 3.3333
    
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    var isSelecting = false {
        didSet {
            selectButton.title = (isSelecting) ? "취소" : "선택"
            
            guard let items = toolbar.items else {
                return
            }
            if isSelecting {
                items[0].isEnabled = true
                items[2].isEnabled = true
            } else {
                items[0].isEnabled = false
                items[2].isEnabled = false
                selectedPhotos = []
                selectedImages = []
            }
        }
    }
    var selectedPhotos: [PHAsset]! = []
    var selectedImages: [UIImage]! = []
    
    let imageManager = PHCachingImageManager()
    var albumIndex: Int!
    
    var photoIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerPhotoLibrary()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        initFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = UserPhotos.shared.albumNames[albumIndex]
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
    }
    
    private func initFlowLayout() {
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 1
        
        flowLayout.itemSize = CGSize(width: imageSize, height: imageSize)
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - Titlebar
    
    @IBAction func didClickSelectButton(_ sender: UIBarButtonItem) {
        isSelecting = (isSelecting) ? false : true
    }
    
    // MARK: - Photos
    
    func registerPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changedCameraRoll = changeInstance.changeDetails(for: UserPhotos.shared.albums[0]) else {
            return
        }
        
        guard let changedAlbum = changeInstance.changeDetails(for: UserPhotos.shared.albums[albumIndex]) else {
            return
        }

        UserPhotos.shared.setChanges(changedCameraRoll: changedCameraRoll, changedAlbum: changedAlbum, albumIndex: albumIndex)
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserPhotos.shared.albums[albumIndex].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = UserPhotos.shared.albums[albumIndex][indexPath.row]
        
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        imageManager.requestImage(for: photo,
                                     targetSize: CGSize(width: 100, height: 100),
                                     contentMode: .aspectFill,
                                     options: options) { (image, _) in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isSelecting {
            let photo = UserPhotos.shared.albums[albumIndex][indexPath.row]
            selectedPhotos.append(photo)
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            imageManager.requestImage(for: photo,
                                         targetSize: CGSize(width: photo.pixelWidth, height: photo.pixelHeight),
                                         contentMode: .aspectFill,
                                         options: options) { (image, _) in
                guard let image = image else {
                    return
                }
                self.selectedImages.append(image)
            }
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
                return
            }
            
            photoIndex = indexPath.row
            
            performSegue(withIdentifier: "startToImageViewController", sender: cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - ToolbarButton
    @IBAction func didClickShareButton(_ sender: UIBarButtonItem) {
        guard let selectedImages = selectedImages else {
            return
        }
        
        var shareObjects: [Any] = []
        
        for shareImage in selectedImages {
            shareObjects.append(shareImage)
        }
        
        let activitViewController = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
        activitViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activitViewController, animated: true) {
            self.isSelecting = false
        }
    }
    
    @IBAction func didClickDeleteButton(_ sender: UIBarButtonItem) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(self.selectedPhotos as NSArray)
        }) { (_, _) in
            self.isSelecting = false
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageViewController = segue.destination as? ImageViewController else {
            return
        }
        
        imageViewController.photoIndex = photoIndex
        imageViewController.albumIndex = albumIndex
    }


}
