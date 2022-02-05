//
//  ImageLoader.swift
//  VKapp
//
//  Created by MacBook on 20.01.2022.
//

import Foundation
import UIKit

class ImageLoader {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    func loadImageData(url: String, complition: @escaping(UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        self.loadImage(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                complition(image)
            case .failure(let error):
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func loadImage(url: URL, completion: @escaping(Result<Data, Error>) -> Void) {
        let complitionONMain: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        session.dataTask(with: url, completionHandler: { data, responce, error in
            guard let responceData = data, error == nil else {
                if let error = error {
                    complitionONMain(.failure(error))
                }
                return
            }
            complitionONMain(.success(responceData))
        }).resume()
    }
}
