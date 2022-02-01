//
//  FriendServiceManager.swift
//  VKapp
//
//  Created by MacBook on 20.01.2022.
//

import Foundation
import UIKit
import RealmSwift

class FriendServiceManager {
    private var service = RequestsServer()
    private let imageService = ImageLoader()
    
    var persistence = RealmCacheService()
    
    func loadFriend(complition: @escaping([FriendsSection]) -> Void) {
        //        guard let realm = try? Realm() else { return }
        //        let friends = realm.objects(Friend.self)
        //
        //        if !friends.isEmpty {
        //            let section = formFriendsArray(from: Array(friends))
        //            complition(section)
        //            return
        //        }
        service.loadFriend { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let friend):
                let section = self.formFriendsArray(from: friend.response.items)
                complition(section)
//                DispatchQueue.main.async {
//                    autoreleasepool {
//                        try! self.persistence.add(object: friend.response.items)
//                    }
//                }
            case .failure(_):
                return
            }
        }
    }
    
    func loadImage(url: String, complition: @escaping(UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        imageService.loadImage(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                complition(image)
            case .failure(let error):
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
    }
}
private extension FriendServiceManager {
    func formFriendsArray(from array: [Friend]?) -> [FriendsSection] {
        guard let array = array else {
            return  []
        }
        let sorted = sortFriends(array: array)
        return fromFriendSection(array: sorted)
    }
    
    func sortFriends(array: [Friend]) -> [Character: [Friend]] {
        var newArray: [Character: [Friend]] = [:]
        
        for friend in array {
            guard let firstChar = friend.firstName.first else {
                continue
            }
            guard var array = newArray[firstChar] else {
                let newValue = [friend]
                newArray.updateValue(newValue, forKey: firstChar)
                continue
            }
            array.append(friend)
            newArray.updateValue(array, forKey: firstChar)
        }
        return newArray
    }
    
    func fromFriendSection(array: [Character: [Friend]]) -> [FriendsSection] {
        var sectionsArray: [FriendsSection] = []
        
        for (key, array) in array {
            sectionsArray.append(FriendsSection(key: key, data: array))
        }
        sectionsArray.sort { $0 < $1 }
        return sectionsArray
    }
    
}
