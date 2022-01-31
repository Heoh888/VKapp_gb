//
//  FriendsServiceManager.swift
//  VKapp
//
//  Created by MacBook on 17.01.2022.
//

import Foundation
import UIKit

class FriendsServiceManager {
    
    private var service = FriendService()
    private var imageService = ImageLoader()
    
//    func loaderFrends(completion: @escaping([FriendsSection]) -> Void) {
//        service.loadFriend {[weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let friend):
//                let section = self.fromFriendsArray(from: friend.response.items)
//                completion(section)
//            case .failure(_):
//                return
//            }
//        }
//    }
    
    func loadImage(url: String, completion: @escaping(UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        imageService.LoaderImage(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(image)
            case .failure(let error):
                debugPrint("Error:\(error.localizedDescription)")
            }
        }
    }
}
extension FriendsServiceManager {
    
    func fromFriendsArray(from array: [Friend]?) -> [FriendsSection] {
        guard let array = array else {
            return []
        }
        let sorted = sortFriends(array: array)
        return formFriendsSection(array: sorted)
    }
    
    func sortFriends(array: [Friend]) -> [Character: [Friend]] {
        var newArray: [Character: [Friend]] = [:]
        
        for friend in array {
            guard let fristChar = friend.firstName.first else {
                continue
            }
            guard var array = newArray[fristChar] else {
                let newValue = [friend]
                newArray.updateValue(newValue, forKey: fristChar)
                continue
            }
            array.append(friend)
            newArray.updateValue(array, forKey: fristChar)
        }
        return newArray
    }
    
    func formFriendsSection(array: [Character: [Friend]]) -> [FriendsSection] {
        var sectionsArray: [FriendsSection] = []
        
        for (key, array) in array {
            sectionsArray.append(FriendsSection(key: key, data: array))
        }
        sectionsArray.sort { $0 < $1 }
        return sectionsArray
    }
}
