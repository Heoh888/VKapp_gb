//
//  VideoModel.swift
//  VKapp
//
//  Created by MacBook on 20.02.2022.
//

import Foundation

struct VideoVk: Decodable {
    let response: ResponceVideo
}

struct ResponceVideo: Decodable {
    let items: [Video]
}

struct Video: Decodable {
    let image: [ImageSize]
    let player: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "image"
        case player = "player"
    }
}

struct ImageSize: Decodable {
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}
