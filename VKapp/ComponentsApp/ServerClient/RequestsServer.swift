//
//  FriendService.swift
//  VKapp
//
//  Created by MacBook on 17.01.2022.
//

import Foundation

enum RequestsServerErroe: Error {
    case parseError
    case requestError(Error)
}

fileprivate enum TypeMetod: String {
    case friendsGet = "/method/friends.get"
}

fileprivate enum TypeRequsts: String {
    case get = "GET"
    case post = "POST"
}

final class RequestsServer {
    private let scheme = "https"
    private let host = "api.vk.com"
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    func loadFriend() {
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "fields": "photo_50"]
        let url = configureUrl(method: .friendsGet,
                               httpMethod: .get,
                               params: params)
        print(url)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                fatalError("ERROR")
            }
            guard let data = data else { return }
            
        }
        task.resume()
    }
    
    func loadGroups() {
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "fields": "photo_50",
                                        "extended": "1"
        ]
        let url = configureUrl(method: .friendsGet,
                               httpMethod: .get,
                               params: params)
        print(url)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                fatalError("ERROR")
            }
            guard let data = data else { return }
            
        }
        task.resume()
    }
}
private extension RequestsServer {
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
