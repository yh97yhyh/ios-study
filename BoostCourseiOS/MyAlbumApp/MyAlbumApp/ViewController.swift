//
//  ViewController.swift
//  MyAlbumApp
//
//  Created by MZ01-KYONGH on 2022/01/13.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PHPhotoLibraryChangeObserver {

    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "albumCell"
    let flowLayout = UICollectionViewFlowLayout()
    let halfWidth = UIScreen.main.bounds.width / 2.0
    let imageSize = UIScreen.main.bounds.width / 2.0 - 15
    
    let imageManager = PHCachingImageManager()
    // var UserPhotos.shared.albums: [PHFetchResult<PHAsset>] = []
    // var UserPhotos.shared.albumNames: [String] = []
    // var UserPhotos.shared.photoNums: [Int] = []
    
    var albumIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        registerPhotoLibrary()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.navigationItem.title = "앨범"
        
        initAuthorization()
        initFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
    }
    
    private func initFlowLayout() {
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 6
        flowLayout.minimumInteritemSpacing = 3
        
        flowLayout.itemSize = CGSize(width: imageSize, height: halfWidth)
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    private func initAuthorization() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization() { (status) in
                switch status {
                case .authorized:
                    print("사용자 허용함")
                    UserPhotos.shared.requestCollection()
                    OperationQueue.main.addOperation {
                        self.collectionView.reloadData()
                    }
                case .denied:
                    print("사용자가 불허함")
                default:
                    break
                }
            }
        case .restricted:
            print("접근 제한")
        case .denied:
            print("접근 불허")
        case .authorized:
            print("접근 허가")
            UserPhotos.shared.requestCollection()
            OperationQueue.main.addOperation {
                self.collectionView.reloadData()
            }
        case .limited:
            print("limited")
        }
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
        return UserPhotos.shared.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }

        let photo = UserPhotos.shared.albums[indexPath.row][0]

        let options = PHImageRequestOptions()
        options.resizeMode = .exact

        imageManager.requestImage(for: photo,
                                     targetSize: CGSize(width: 100, height: 100),
                                     contentMode: .aspectFill,
                                     options: options) { (image, _) in
            cell.imageView.image = image
        }
        cell.albumNameLabel.text = UserPhotos.shared.albumNames[indexPath.row]
        cell.photeNum.text = String(UserPhotos.shared.photoNums[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumCollectionViewCell else {
            return
        }
        
        albumIndex = indexPath.row
        
        performSegue(withIdentifier: "startToPhotosViewController", sender: cell)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photosViewController = segue.destination as? PhotosViewController else {
            return
        }
        
        photosViewController.albumIndex = albumIndex
    }

}

