//
//  ImageLoader.swift
//  VKapp
//
//  Created by MacBook on 17.01.2022.
//

import Foundation

class ImageLoader {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    func LoaderImage(url: URL, completion: @escaping(Result<Data, Error>) -> Void) {
        let completionOnMain: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        session.dataTask(with: url, completionHandler: { data, response, erorr in
            guard let responseData = data, erorr == nil else {
                if let error = erorr {
                    completionOnMain(.failure(error))
                }
                return
            }
            completionOnMain(.success(responseData))
        }).resume()
    }
}
