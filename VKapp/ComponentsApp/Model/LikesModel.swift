//
//  LikesModel.swift
//  VKapp
//
//  Created by Алексей Ходаков on 26.04.2022.
//

import Foundation

struct LikesModel: Decodable {
    let response: Like
}

struct Like: Decodable {
    var liked: Int?
    var copied: Int?
    var count: Int?
    var items: [Int]?
}


