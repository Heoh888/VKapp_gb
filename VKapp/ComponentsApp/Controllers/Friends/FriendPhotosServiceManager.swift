//
//  FriendPhotosServiceManager.swift
//  VKapp
//
//  Created by MacBook on 23.01.2022.
//

import Foundation

import UIKit

class FriendPhotosServiceManager {
    private var service = RequestsServer()
    private let imageService = ImageLoader()
    
    var persistence = RealmCacheService()
    
    func loadFriendPhoto(idUser: Int, complition: @escaping([String]) -> Void) {
        service.loadPhotos(id: idUser) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photo):
                let section = self.fromFriendPhotos(from: photo.response.items)
                complition(section)
//                DispatchQueue.main.async {
//                    autoreleasepool {
//                        try! self.persistence.add(object: photo.response.items)
//                    }
//                }
            case .failure(_):
                return
            }
        }
    }
    
    func fromFriendPhotos(from array: [FriendPhoto]?) -> [String] {
        var sectionsArray: [String] = []
        for item in array! {
            sectionsArray.append(item.sizes[item.sizes.count - 1].url)
        }
        return sectionsArray
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

