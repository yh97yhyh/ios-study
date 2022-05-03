//
//  Model.swift
//  Networking
//
//  Created by MZ01-KYONGH on 2022/04/28.
//

import Foundation

struct APIResponse: Codable {
    let results: [Friend]
}

struct Friend: Codable {
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
        
        var full: String {
            return self.title.capitalized + ". " + self.first.capitalized + " " + self.last.capitalized
        }
    }
    
    struct Picture: Codable {
        let large: String
        let medium: String
        let thumbnail: String
    }
    
    let name: Name
    let email: String
    let picture: Picture
}

/*
 {"results":[

 {"name":{"title":"Mr","first":"Bela","last":"Hinkel"},"email":"bela.hinkel@example.com","picture":{"large":"https://randomuser.me/api/portraits/men/5.jpg","medium":"https://randomuser.me/api/portraits/med/men/5.jpg","thumbnail":"https://randomuser.me/api/portraits/thumb/men/5.jpg"}},
 {"name":{"title":"Mr","first":"Nicolas","last":"Slawa"},"email":"nicolas.slawa@example.com","picture":{"large":"https://randomuser.me/api/portraits/men/13.jpg","medium":"https://randomuser.me/api/portraits/med/men/13.jpg","thumbnail":"https://randomuser.me/api/portraits/thumb/men/13.jpg"}},
 */
