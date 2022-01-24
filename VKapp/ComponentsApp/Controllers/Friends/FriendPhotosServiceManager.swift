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

