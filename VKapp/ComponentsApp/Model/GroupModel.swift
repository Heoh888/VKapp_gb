//
//  GroupModel.swift
//  VKapp
//
//  Created by MacBook on 19.02.2022.
//

import Foundation

struct GroupVk: Decodable {
    let response: [GroupInfo]
}

struct GroupInfo: Decodable {
    var id: Int
    var name: String
    var photo200: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case photo200 = "photo_200"
    }
}
