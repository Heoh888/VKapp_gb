//
//  ViewImageModel.swift
//  VKapp
//
//  Created by Алексей Ходаков on 22.05.2022.
//

import Foundation
import UIKit
import PromiseKit

class ViewNewsModel {
    private var imageService = ImageLoader()
    private var service = RequestsServer()
    private var getUrl = ConfigureUrl()
    
    let queue = OperationQueue()
    
    func getDataPostInfo(type: String, itemId: Int, completion: @escaping (Int, Int, Int, [Int]) -> Void) {
        firstly {
            URLSession.shared.dataTask(.promise, with: getUrl.getUrl(parametrs: .isLiked,
                                                                     id: String(itemId),
                                                                     type: type)!)
        }
        .compactMap { try JSONDecoder().decode(LikesModel.self, from: $0.data) }
        .done { likeIs in
            DispatchQueue.main.async {
                firstly {
                    URLSession.shared.dataTask(.promise, with: self.getUrl.getUrl(parametrs: .likesGetList,
                                                                                  id: String(itemId),
                                                                                  type: type)!)
                }
                .compactMap { try JSONDecoder().decode(LikesModel.self, from: $0.data) }
                .done { likeInfo in
                    guard
                        let liked = likeIs.response.liked,
                        let copied = likeIs.response.copied,
                        let count = likeInfo.response.count,
                        let items = likeInfo.response.items
                    else { return }
                    completion(liked, copied, count, items)
                }
            }
        }
    }
    
    func getDataUser(id: String, completion: @escaping (UIImage?, String) -> Void) {
        
        firstly {
            URLSession.shared.dataTask(.promise, with: getUrl.getUrl(parametrs: .userGet, id: id)!)
        }
        .compactMap { try JSONDecoder().decode(UserVk.self, from: $0.data) }
        .done { user in
            DispatchQueue.main.async { [self] in
                imageService.loadImageData(url: user.response[0].photo50 ) { image in
                    completion(image, user.response[0].firstName)
                }
            }
        }
    }
}
