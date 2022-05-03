//
//  Request.swift
//  Networking
//
//  Created by MZ01-KYONGH on 2022/04/28.
//

import Foundation

let DidReceiveFriendsNotification: Notification.Name = Notification.Name("DidReceiveFriends")

func requestFriends() {
    guard let url = URL(string: "https://randomuser.me/api/?results=20&inc=name,email,picture") else { return }
    
    let session = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let data = data else { return }
        
        do {
            let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            NotificationCenter.default.post(name: DidReceiveFriendsNotification,
                                            object: nil,
                                            userInfo: ["friends": apiResponse.results])
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    
    dataTask.resume()
}
