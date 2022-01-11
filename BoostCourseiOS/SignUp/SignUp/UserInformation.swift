//
//  UserInformation.swift
//  SignUp
//
//  Created by MZ01-KYONGH on 2022/01/11.
//

import Foundation
import UIKit

class UserInformation {
    static var user: UserInformation = UserInformation()
    
    var id: String?
    var password: String?
    var profileImage: UIImage?
    var profile: String?
    var phoneNum: String?
    var birthday: String?
    
    func isEmpty() -> Bool {
        if id != nil && password != nil && profileImage != nil && profile != nil && phoneNum != nil && birthday != nil {
            return true
        } else {
            return false
        }
    }
    
    func destroy() {
        id = nil
        password = nil
        profileImage = nil
        profile = nil
        phoneNum = nil
        birthday = nil
    }
}
