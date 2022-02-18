//
//  GroupModel.swift
//  VKapp
//
//  Created by MacBook on 22.01.2022.
//
import Foundation
import RealmSwift

struct GroupsVk: Decodable {
    let response: ResponceGroup
}

struct ResponceGroup: Decodable {
    let count: Int
    let items: [Group]
}

class Group: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var photo50: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case photo50 = "photo_50"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
