//
//  FriendPhotosModel.swift
//  VKapp
//
//  Created by MacBook on 23.01.2022.
//
import Foundation
import RealmSwift

struct FriendPhotoVk: Decodable {
    let response: ResponceFriendsPhoto
}

struct ResponceFriendsPhoto: Decodable {
    let count: Int
    let items: [FriendPhoto]
}

class FriendPhoto: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var owner_id: Int
    @objc dynamic var sizes: [PhotoSize]
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner_id = "owner_id"
        case sizes
    }
}

class PhotoSize: Object, Decodable {
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

