//
//  ViewController.swift
//  MyAlbumApp
//
//  Created by MZ01-KYONGH on 2022/01/13.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "albumCell"
    let flowLayout = UICollectionViewFlowLayout()
    let halfWidth = UIScreen.main.bounds.width / 2.0
    let imageWidth = UIScreen.main.bounds.width / 2.0 - 20
    
    let imageManager = PHCachingImageManager()
    var photosOfAlbum: [PHFetchResult<PHAsset>] = []
    var albumNames: [String] = []
    var photoNums: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        initAuthorization()
        initFlowLayout()
    }
    
    private func initFlowLayout() {
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        flowLayout.itemSize = CGSize(width: imageWidth, height: halfWidth)
        
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
        
        photosOfAlbum.append(PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions))
        albumNames.append("Camera Roll")
        photoNums.append(photosOfAlbum[0].count)

        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: false)]
        let albumList = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                subtype: .any,
                                                                options: options)
        let albumNums = albumList.count
        let album = albumList.objects(at: IndexSet(0..<albumNums))
        
        for i in 0..<albumNums {
            photosOfAlbum.append(PHAsset.fetchAssets(in: album[i], options: fetchOptions))
            guard let albumName = album[i].localizedTitle else {
                return
            }
            if photosOfAlbum[i+1].count == 0 {
                photosOfAlbum.popLast()
                continue
            }
            albumNames.append(albumName)
            photoNums.append(photosOfAlbum[i+1].count)
            // print("ㅅㅂ \(albumName) : \(photosOfAlbum[i+1].count)")
        }
    }

    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosOfAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }

        let photo = photosOfAlbum[indexPath.row][0]

        let options = PHImageRequestOptions()
        options.resizeMode = .exact

        imageManager.requestImage(for: photo,
                                     targetSize: CGSize(width: 100, height: 100),
                                     contentMode: .aspectFill,
                                     options: options) { (image, _) in
            cell.imageView.image = image
        }
        cell.albumNameLabel.text = albumNames[indexPath.row]
        cell.photeNum.text = String(photoNums[indexPath.row])
        
        return cell
    }

}

