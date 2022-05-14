//
//  ParseData.swift
//  VKapp
//
//  Created by Алексей Ходаков on 13.05.2022.
//

import Foundation

class ParseData: Operation {
    var outputData: [News] = []
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data else { return }
        
        print(data)

        let decoder = JSONDecoder()
        do {
            let posts = try decoder.decode(NewsVk.self, from: data)
            outputData = posts.response.items
        } catch {
            return print("error")
        }
    }
}
