//
//  Friend.swift
//  FriendsCollection
//
//  Created by MZ01-KYONGH on 2022/01/13.
//

import Foundation

struct Friend: Codable {
    
    struct Address: Codable {
        let country: String
        let city: String
    }
    
    let name: String
    let age: Int
    let addressInfo: Address
    
    var nameAndAge: String {
        return name + "(\(age))"
    }
    
    var fullAddress: String {
        return addressInfo.city + ", " + addressInfo.country
    }
    
    enum CodingKeys: String, CodingKey {
        case name, age
        case addressInfo = "address_info"
    }
}
