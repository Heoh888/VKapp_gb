//
//  FriendModel.swift
//  VKapp
//
//  Created by MacBook on 20.01.2022.
//

struct FriendVk: Decodable {
    let response: ResponceFriends
}

struct ResponceFriends: Decodable {
    let count: Int
    let items: [Friend]
}

struct Friend: Decodable {
    let id: Int
    let firstName, lastName: String
    let photo50: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo50 = "photo_50"
    }
}
