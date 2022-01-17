//
//  UserPhotos.swift
//  MyAlbumApp
//
//  Created by MZ01-KYONGH on 2022/01/14.
//

import Foundation
import Photos

class UserPhotos {
    
    static let shared = UserPhotos()
    
    var albums: [PHFetchResult<PHAsset>] = []
    var albumNames: [String] = []
    var photoNums: [Int] = []
    
    func requestCollection() {

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
    
    func setChanges(changedCameraRoll: PHFetchResultChangeDetails<PHAsset>, changedAlbum: PHFetchResultChangeDetails<PHAsset>, albumIndex: Int) {
        UserPhotos.shared.albums[0] = changedCameraRoll.fetchResultAfterChanges
        UserPhotos.shared.albums[albumIndex] = changedAlbum.fetchResultAfterChanges
        UserPhotos.shared.photoNums[0] = UserPhotos.shared.albums[0].count
        UserPhotos.shared.photoNums[albumIndex] = UserPhotos.shared.albums[albumIndex].count
    }
}
