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
    let items: [News]
}

struct News: Decodable {

    let sourceId: Int?
    let ownerId: Int?
    let data: Int?
//    let photos: PhotosNews?
    let text: String?
    let attachments: [Attachments]?
    let copyHistory: [News]?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case ownerId = "owner_id"
        case data = "date"
//        case photos = "photos"
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

struct VideoNewsItems: Decodable {
    let image: [PhotoSize]
    let id: Int
    let ownerId: Int
    
    enum CodingKeys: String, CodingKey {
        case image = "image"
        case id = "id"
        case ownerId = "owner_id"
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
    let video: VideoNewsItems?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case photo = "photo"
        case video = "video"
        
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
