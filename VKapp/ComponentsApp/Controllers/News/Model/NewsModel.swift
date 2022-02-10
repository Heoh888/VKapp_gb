//
//  NewsModel.swift
//  VKapp
//
//  Created by MacBook on 07.02.2022.
//

import Foundation
import GameKit

struct NewsVk: Decodable {
    let response: ResponceNews
}

struct ResponceNews: Decodable {
    let items: [News1]
}

struct News1: Decodable {
    let sourceId: Int?
    let data: Int?
    let photos: PhotosNews?
    let text: String?
    let attachments: [Attachments]?
    let copyHistory: [News1]?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case data = "date"
        case photos = "photos"
        case text = "text"
        case attachments = "attachments"
        case copyHistory = "copy_history"
        case type = "type"
    }
}

// MARK: Модель для новостей типа "wall_photo"
struct PhotosNews: Decodable {
    let count: Int
    let items: [PhotoNewsItems]
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case items = "items"
    }
}

struct PhotoNewsItems: Decodable {
    let sizes: [PhotoSize]
    
    enum CodingKeys: String, CodingKey {
        case sizes = "sizes"
    }
}

struct PhotoNewsSize: Decodable {
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

// MARK: Модель для новостей типа "post"
struct Attachments: Decodable {
    let type: String
    let photo: PhotoNewsItems?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case photo = "photo"
    }
}

struct CopyHistory: Decodable {
    let type: String
//    let photo: PhotoNewsItems?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
//        case photo = "photo"
    }
}
