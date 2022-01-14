//
//  PhotosViewController.swift
//  MyAlbumApp
//
//  Created by MZ01-KYONGH on 2022/01/13.
//

import UIKit
import Photos

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "photoCell"
    let flowLayout = UICollectionViewFlowLayout()
    let halfWidth = UIScreen.main.bounds.width / 3.3333
    let imageSize = UIScreen.main.bounds.width / 3.3333
    
    let imageManager = PHCachingImageManager()
    var albumIndex: Int!
    
    var photoIndex: Int!
    
    var shareImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        initFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = UserPhotos.shared.albumNames[albumIndex]
    }
    
    private func initFlowLayout() {
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 1
        
        flowLayout.itemSize = CGSize(width: imageSize, height: imageSize)
        
        self.collectionView.collectionViewLayout = flowLayout
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            return
        }
        
        photoIndex = indexPath.row
        
        performSegue(withIdentifier: "startToImageViewController", sender: cell)
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
