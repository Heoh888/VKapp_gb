//
//  RequestsData.swift
//  VKapp
//
//  Created by Алексей Ходаков on 29.04.2022.
//

import Foundation
import PromiseKit

enum Parametrs: String {
    case friendsGet = "/method/friends.get"
    case gpoupsGet = "/method/groups.get"
    case newsfeed = "/method/newsfeed.get"
    case userGet = "/method/users.get"
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
    
    func getUrl(parametrs: Parametrs, id: String = "") -> URL? {

        guard let token = Session.instance.token else { return nil }
        
        let params: [String: String]
        
        switch parametrs {
        case .newsfeed: params = ["access_token": token,
                                  "filters": "post",]
            
        case .gpoupsGet: params = ["access_token": token,
                                   "fields": "photo_50",
                                   "extended": "1"]
            
        case .friendsGet: params = ["access_token": token,
                                    "fields" : "photo_50"]
            
        case .userGet: params = ["access_token": token,
                                 "user_ids": id,
                                 "fields": "photo_50"]
        }
        
        let url = configureUrl(method: parametrs,
                               httpMethod: .get,
                               params: params)
        return url
    }
}
private extension ConfigureUrl {
    func configureUrl(method: Parametrs,
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
