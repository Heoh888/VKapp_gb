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
    
    func getDataUser(id: String, completion: @escaping (UIImage?, String) -> Void) {
        getData(id: id) { user in
            DispatchQueue.main.async { [self] in
                imageService.loadImageData(url: user!.response[0].photo50 ) { image in
                    completion(image, user?.response[0].firstName ?? "No name")
                }
            }
        }
    }
    
    private func getData(id: String, completion: @escaping (UserVk?) -> Void) {
        firstly {
            URLSession.shared.dataTask(.promise, with: getUrl.getUrl(parametrs: .userGet, id: id)!)
        }
        .compactMap { try JSONDecoder().decode(UserVk.self, from: $0.data) }
        .done { user in
            completion(user)
        }
    }
}
