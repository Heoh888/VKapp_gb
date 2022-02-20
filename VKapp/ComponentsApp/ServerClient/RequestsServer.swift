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
    case gpoupsGet = "/method/groups.get"
    case photosGet = "/method/photos.get"
    case deleteGroup = "/method/groups.leave"
    case joinGroup = "/method/groups.join"
    case searchGroup = "/method/groups.search"
    case newsfeed = "/method/newsfeed.get"
    case userGet = "/method/users.get"
    case gpoupGet = "/method/groups.getById"
    case videoGet = "/method/video.get"
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
    
    func loadNews(complition: @escaping (Result<NewsVk, RequestsServerErroe>) -> ()){
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "filters": "post"]
        let url = configureUrl(method: .newsfeed,
                               httpMethod: .get,
                               params: params)
        print(url)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                return complition(.failure(.requestError(error)))
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()

            do {
                let result = try decoder.decode(NewsVk.self, from: data)
                return complition(.success(result))
            } catch {
                return complition(.failure(.parseError))

            }
        }
        task.resume()
    }
    
    func loadFriend(complition: @escaping (Result<FriendVk, RequestsServerErroe>) -> ()) {
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "fields": "photo_50"]
        let url = configureUrl(method: .friendsGet,
                               httpMethod: .get,
                               params: params)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                return complition(.failure(.requestError(error)))
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(FriendVk.self, from: data)
                return complition(.success(result))
            } catch {
                return complition(.failure(.parseError))
                
            }
        }
        task.resume()
    }
    
    func loadGroup(groupId: String, complition: @escaping (Result<GroupVk, RequestsServerErroe>) -> ()) {
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "group_id": groupId]
        let url = configureUrl(method: .gpoupGet ,
                               httpMethod: .get,
                               params: params)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                return complition(.failure(.requestError(error)))
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(GroupVk.self, from: data)
                return complition(.success(result))
            } catch {
                return complition(.failure(.parseError))
                
            }
        }
        task.resume()
    }
    
    func loadUser(userId: String, complition: @escaping (Result<UserVk, RequestsServerErroe>) -> ()) {
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "user_ids": userId,
                                        "fields": "photo_50"]
        let url = configureUrl(method: .userGet ,
                               httpMethod: .get,
                               params: params)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                return complition(.failure(.requestError(error)))
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(UserVk.self, from: data)
                return complition(.success(result))
            } catch {
                return complition(.failure(.parseError))
                
            }
        }
        task.resume()
    }
    
    func loadGroups(complition: @escaping (Result<GroupsVk, RequestsServerErroe>) -> ()) {
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "fields": "photo_50",
                                        "extended": "1"
        ]
        let url = configureUrl(method: .gpoupsGet,
                               httpMethod: .get,
                               params: params)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                return complition(.failure(.requestError(error)))
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(GroupsVk.self, from: data)
                return complition(.success(result))
            } catch {
                return complition(.failure(.parseError))
                
            }
        }
        task.resume()
    }
    
    func loadGroupsSearch(q: String, complition: @escaping (Result<GroupsVk, RequestsServerErroe>) -> ()) {
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "q": q,
                                        "count": "100"
        ]
        let url = configureUrl(method: .searchGroup,
                               httpMethod: .get,
                               params: params)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                return complition(.failure(.requestError(error)))
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(GroupsVk.self, from: data)
                return complition(.success(result))
            } catch {
                return complition(.failure(.parseError))
                
            }
        }
        task.resume()
    }
    func joinGroup(idGroup: Int) {
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "group_id": String(idGroup),
        ]
        let url = configureUrl(method: .joinGroup,
                               httpMethod: .get,
                               params: params)
        let task = session.dataTask(with: url)
        task.resume()
    }
    
    func deleteGroup(idGroup: Int) {
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "group_id": String(idGroup),
        ]
        let url = configureUrl(method: .deleteGroup,
                               httpMethod: .get,
                               params: params)
        let task = session.dataTask(with: url)
        task.resume()
    }
    
    func loadVideo(id: String, ownerid: String, complition: @escaping (Result<VideoVk, RequestsServerErroe>) -> ()) {
        guard let token = Session.instance.token else {
            return
        }
        let params: [String: String] = ["access_token": token,
                                        "videos": ownerid + "_" + id]
        let url = configureUrl(method: .videoGet ,
                               httpMethod: .get,
                               params: params)
        print(url)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                return complition(.failure(.requestError(error)))
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(VideoVk.self, from: data)
                return complition(.success(result))
            } catch {
                return complition(.failure(.parseError))
                
            }
        }
        task.resume()
    }
    
    func loadPhotos(id: Int, complition: @escaping (Result<FriendPhotoVk, RequestsServerErroe>)-> ()) {
        guard let token = Session.instance.token else {
            return
        }

        let params: [String: String] = ["access_token": token,
                                        "owner_id": String(id),
                                        "album_id": "profile",
                                        "extended": "1"
        ]
        let url = configureUrl(method: .photosGet,
                               httpMethod: .get,
                               params: params)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                return complition(.failure(.requestError(error)))
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(FriendPhotoVk.self, from: data)
                return complition(.success(result))
            } catch {
                return complition(.failure(.parseError))
                
            }
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
