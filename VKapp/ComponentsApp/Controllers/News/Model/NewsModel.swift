//
//  NewsModel.swift
//  VKapp
//
//  Created by MacBook on 07.02.2022.
//

import Foundation

protocol PostCellProtocol {
    func set<T: PostCellDataProtocol>(value: T)
}

protocol PostCellDataProtocol {
    var sourceId: Int? { get }
    var ownerId: Int? { get }
    var text: String? { get }
    var attachments: [Attachments]? { get }
    var copyHistory: [CopyHistory]? { get }
    var likes: Likes? { get }
    var comments: Comments? { get }
    var reposts: Reposts? { get }
    var views: Views? { get }
}

struct NewsVk: Decodable {
    let response: ResponceNews
}

struct ResponceNews: Decodable {
    let items: [News]
}

struct News: Decodable {

    enum PostType: String {
        case postImageOnly = "ImagePostCell"
        case postTextOnly = "TextPostCell"
        case postVideoOnly = "VideoPostCell"
        case rePostImageOnly = "ImageRePostCell"
        case rePostTextOnly = "TextRePostCell"
        case rePostVideoOnly = "VideoRePostCell"
    }

    let sourceId: Int?
    let ownerId: Int?
    let data: Int?
    let text: String?
    let attachments: [Attachments]?
    let copyHistory: [CopyHistory]?
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
    var postType: PostType? {
        let hasAttachments = attachments != nil
        let hasCopyHistory = copyHistory != nil
        
        switch (hasAttachments, hasCopyHistory) {
        case (true, false):
            let hasImage = attachments![0].photo != nil
            let hasVideo = attachments![0].video != nil
            let hasText = text != ""
            switch (hasImage, hasText, hasVideo) {
            case (true, false, false): return .postImageOnly
            case (true, true, false): return .postImageOnly
            case (false, true, false): return .postTextOnly
            case (false, false, true): return .postVideoOnly
            case (false, true, true): return .postVideoOnly
            default: return nil
            }
        case (false, true):
            let hasImage = copyHistory![0].attachments?[0].photo != nil
            let hasVideo = copyHistory![0].attachments?[0].video != nil
            let hasText = copyHistory![0].text != ""
            switch (hasImage, hasText, hasVideo) {
            case (true, false, false): return .rePostImageOnly
            case (true, true, false): return .rePostImageOnly
            case (false, true, false): return .rePostTextOnly
            case (false, false, true): return .rePostVideoOnly
            case (false, true, true): return .rePostVideoOnly
            default: return nil
            }
        case (false, false): return nil
        case (true, true): return nil
        }
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
    let id: Int?
    let ownerId: Int?
    let fromId: Int?
    let text: String?
    let attachments: [Attachments]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ownerId = "owner_id"
        case fromId = "from_id"
        case text = "text"
        case attachments = "attachments"
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

extension News: PostCellDataProtocol {}
