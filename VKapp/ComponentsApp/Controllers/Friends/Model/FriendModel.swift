//
//  FriendModel.swift
//  VKapp
//
//  Created by MacBook on 20.01.2022.
//
import RealmSwift
import Foundation

struct FriendVk: Decodable {
    let response: ResponceFriends
}

struct ResponceFriends: Decodable {
    let count: Int
    let items: [Friend]
}

class Friend: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var firstName, lastName: String
    @objc dynamic var photo50: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo50 = "photo_50"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["firstName"]
    }
}
