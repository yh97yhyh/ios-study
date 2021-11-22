//
//  DemoURL.swift
//  Cassini
//
//  Created by MZ01-KYONGH on 2021/11/19.
//

import Foundation

struct DemoURL {
    static let Stanford = "https://doz1futtg6626.cloudfront.net/images/2021/5/18/TW_Release.jpg?width=1024&mode=crop.png"
    
    static let NASA = [
        "Cassini" : "http://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
        "Earth" : "http://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
        "Saturn" : "http://www.nasa.gov/sites/default/files/saturn_collage.jpg"
    ]
    
    static func NASAImageNamed(imageName: String?) -> NSURL? {
        if let urlstring = NASA[imageName ?? ""] {
            return NSURL(string: urlstring)
        } else {
            return nil
        }
    }
}
