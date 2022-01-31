//
//  ImageLoader.swift
//  VKapp
//
//  Created by MacBook on 20.01.2022.
//

import Foundation

class ImageLoader {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
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
