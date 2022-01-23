//
//  FriendPhotosModel.swift
//  VKapp
//
//  Created by MacBook on 23.01.2022.
//

struct FriendPhotoVk: Decodable {
    let response: ResponceFriendsPhoto
}

struct ResponceFriendsPhoto: Decodable {
    let count: Int
    let items: [FriendPhoto]
}

struct FriendPhoto: Decodable {
    let id: Int
    let owner_id: Int
    let sizes: [PhotoSize]

    
    enum CodingKeys: String, CodingKey {
        case id
        case owner_id = "owner_id"
        case sizes
    }
}

struct PhotoSize: Decodable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

