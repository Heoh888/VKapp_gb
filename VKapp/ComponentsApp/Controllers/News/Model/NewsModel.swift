//
//  NewsModel.swift
//  VKapp
//
//  Created by MacBook on 07.02.2022.
//

import Foundation

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
    let text: String?
    let attachments: [Attachments]?
    let copyHistory: [News]?
    let comments: Comments?
    var likes: Likes?
    let reposts: Reposts?
    let views: Views?
    let postId: Int?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case ownerId = "owner_id"
        case data = "date"
        case text = "text"
        case attachments = "attachments"
        case copyHistory = "copy_history"
        case comments = "comments"
        case likes = "likes"
        case reposts = "reposts"
        case views = "views"
        case postId = "post_id"
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
    let id: Int
    let ownerId: Int
    let sizes: [PhotoSize]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ownerId = "owner_id"
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
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
    }
}
// MARK: Модель для новостей типа "Like"
struct Likes: Decodable {
    var count: Int
    var userLikes: Int
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case userLikes = "user_likes"
    }
}
// MARK: Модель для новостей типа "Comments"
struct Comments: Decodable {
    var count: Int
}
// MARK: Модель для новостей типа "Reposts"
struct Reposts: Decodable {
    var count: Int
}
// MARK: Модель для новостей типа "Views"
struct Views: Decodable {
    var count: Int
}

