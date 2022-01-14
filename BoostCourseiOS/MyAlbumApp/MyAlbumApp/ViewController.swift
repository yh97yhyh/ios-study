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
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.navigationItem.title = "앨범"
        
        initAuthorization()
        initFlowLayout()
        
        print("1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // initAuthorization()
        print(".")
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
                    self.requestCollection()
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
            self.requestCollection()
            self.collectionView.reloadData()
        case .limited:
            print("limited")
        }
    }
    
    // MARK: - Photos
    
    private func requestCollection() {

        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                 subtype: .smartAlbumUserLibrary,
                                                                 options: nil)
        
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        UserPhotos.shared.albums.append(PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions))
        UserPhotos.shared.albumNames.append("Camera Roll")
        UserPhotos.shared.photoNums.append(UserPhotos.shared.albums[0].count)

        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: false)]
        let albumList = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                subtype: .any,
                                                                options: options)
        let albumNums = albumList.count
        let album = albumList.objects(at: IndexSet(0..<albumNums))
        
        for i in 0..<albumNums {
            UserPhotos.shared.albums.append(PHAsset.fetchAssets(in: album[i], options: fetchOptions))
            guard let albumName = album[i].localizedTitle else {
                return
            }
            if UserPhotos.shared.albums[i+1].count == 0 {
                UserPhotos.shared.albums.popLast()
                continue
            }
            UserPhotos.shared.albumNames.append(albumName)
            UserPhotos.shared.photoNums.append(UserPhotos.shared.albums[i+1].count)
            // print("ㅅㅂ \(albumName) : \(UserPhotos.shared.albums[i+1].count)")
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: UserPhotos.shared.albums[0]) else {
            return
        }
        
        OperationQueue.main.addOperation {
            // self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
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

