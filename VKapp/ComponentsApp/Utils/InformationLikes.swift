//
//  InformationLikes.swift
//  VKapp
//
//  Created by Алексей Ходаков on 26.04.2022.
//

import Foundation

public class InformationLikes {
    //    var type: String
    //    var itemId: Int
    //    var ownerId: Int
    
    //    init (type: String, itemId: Int, ownerId: Int) {
    //        self.type = type
    //        self.itemId = itemId
    //        self.ownerId = ownerId
    //    }
    
    private var service = RequestsServer()
    var group = DispatchGroup()
    
    func getInfoLiket(type: String, itemId: Int, ownerId: Int, completion: (_ count:Int, _ liked: Bool) -> ()) {
        var count: Int = 0
        var liked: Bool = false
        // TODO : Одельная функйия получения о лайках
        group.enter()
        DispatchQueue.main.async {
            self.group.enter()
            self.service.likesIsLiked(type: type, itemId: itemId, ownerId: ownerId) { result in
                switch result {
                case .success(let like):
                    self.service.likesGetList(type: type, itemId: itemId, ownerId: ownerId) { result in
                        switch result {
                        case .success(let likeList):
                            self.group.leave()
                            self.group.notify(queue: .main) {
                                count = likeList.response.count!
                            }
                        case .failure(_):
                            return
                        }
                    }
                    if like.response.liked == 1 {
                        liked = true
                    }
                case .failure(_):
                    return
                }
            }
        }
            completion(count, liked)
    }
}
