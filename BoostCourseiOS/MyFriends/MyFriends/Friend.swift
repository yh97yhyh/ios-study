//
//  Friend.swift
//  MyFriends
//
//  Created by MZ01-KYONGH on 2022/01/11.
//

import Foundation

//{
//    "name":"하나",
//    "age":22,
//    "address_info": {
//        "country":"대한민국",
//        "city":"울산"
//    }
//},

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
