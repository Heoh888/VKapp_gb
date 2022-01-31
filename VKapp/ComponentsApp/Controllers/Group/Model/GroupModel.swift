//
//  GroupModel.swift
//  VKapp
//
//  Created by MacBook on 22.01.2022.
//
import Foundation
import RealmSwift

struct GroupVk: Decodable {
    let response: ResponceGroup
}

struct ResponceGroup: Decodable {
    let count: Int
    let items: [Group]
}

class Group: Decodable {
    let id: Int
    let name: String
    let photo50: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case photo50 = "photo_50"
    }
}