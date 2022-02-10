//
//  UserModel.swift
//  VKapp
//
//  Created by MacBook on 10.02.2022.
//

import Foundation

struct UserVk: Decodable {
    let response: [UserInfo]
}

struct UserInfo: Decodable {
    var id: Int
    var firstName, lastName: String
    var photo50: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo50 = "photo_50"
    }
}
