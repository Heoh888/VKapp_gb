//
//  RequestsData.swift
//  VKapp
//
//  Created by Алексей Ходаков on 29.04.2022.
//

import Foundation
import PromiseKit

fileprivate enum TypeMetod: String {
    case friendsGet = "/method/friends.get"
    case gpoupsGet = "/method/groups.get"
    case newsfeed = "/method/newsfeed.get"
}

fileprivate enum TypeRequsts: String {
    case get = "GET"
    case post = "POST"
}

class ConfigureUrl {
    private let scheme = "https"
    private let host = "api.vk.com"
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    func getUrlFriends() -> URL? {
        guard let token = Session.instance.token else { return nil }
        let params: [String: String] = ["access_token": token,
                                        "fields": "photo_50"]
        let url = configureUrl(method: .friendsGet,
                               httpMethod: .get,
                               params: params)
        return url
    }
    
    func getUrlGrups() -> URL? {
        guard let token = Session.instance.token else { return nil}
        let params: [String: String] = ["access_token": token,
                                        "fields": "photo_50",
                                        "extended": "1"
        ]
        let url = configureUrl(method: .gpoupsGet,
                               httpMethod: .get,
                               params: params)
        return url
    }
    
    func getUrlNews() -> URL? {
        guard let token = Session.instance.token else { return nil}
        let params: [String: String] = ["access_token": token,
                                        "filters": "post",
        ]
        let url = configureUrl(method: .newsfeed,
                               httpMethod: .get,
                               params: params)
        return url
    }
}
private extension ConfigureUrl {
    func configureUrl(method: TypeMetod,
                      httpMethod: TypeRequsts,
                      params: [String : String]) -> URL {
        var queryItem = [URLQueryItem]()
        queryItem.append(URLQueryItem(name: "v", value: "5.131"))
        for (param, value) in params {
            queryItem.append(URLQueryItem(name: param, value: value))
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = method.rawValue
        urlComponents.queryItems = queryItem
        
        guard let url = urlComponents.url else {
            fatalError("Url is invalid")
        }
        return url
    }
}
