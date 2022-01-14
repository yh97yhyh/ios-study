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
}
