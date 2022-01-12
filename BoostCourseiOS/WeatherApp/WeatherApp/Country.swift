//
//  File.swift
//  WeatherApp
//
//  Created by MZ01-KYONGH on 2022/01/11.
//

import Foundation

struct Country: Codable {
    
    let koreanName: String
    let assetName: String
    
    enum CodingKeys: String, CodingKey {
        case koreanName = "korean_name"
        case assetName = "asset_name"
    }
}
