//
//  GroupServiceManager.swift
//  VKapp
//
//  Created by MacBook on 22.01.2022.
//

import Foundation
import UIKit
import RealmSwift

class GroupServiceManager {
    private var service = RequestsServer()
    private let imageService = ImageLoader()
    
    func loadGroup(complition: @escaping([GroupsSection]) -> Void) {
        service.loadGroups { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let group):
                let section = self.formGroupArray(from: group.response.items)
                self.saveFriend(groups: group.response.items)
                complition(section)
            case .failure(_):
                return
            }
        }
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
private extension GroupServiceManager {
    func saveFriend(groups: [Group]) {
//        do {
//            let realm = try Realm()
//            realm.beginWrite()
//            realm.add(groups)
//            try realm.commitWrite()
//        } catch {
//            print(error)
//        }
    }
    
    func formGroupArray(from array: [Group]?) -> [GroupsSection] {
        guard let array = array else {
            return  []
        }
        let sorted = sortGroups(array: array)
        return fromGroupSection(array: sorted)
    }
    
    func sortGroups(array: [Group]) -> [Character: [Group]] {
        var newArray: [Character: [Group]] = [:]
        
        for group in array {
            guard let firstChar = group.name.first else {
                continue
            }
            
            guard var array = newArray[firstChar] else {
                let newValue = [group]
                newArray.updateValue(newValue, forKey: firstChar)
                continue
            }
            
            array.append(group)
            
            newArray.updateValue(array, forKey: firstChar)
        }
        return newArray
    }
    
    func fromGroupSection(array: [Character: [Group]]) -> [GroupsSection] {
        var sectionsArray: [GroupsSection] = []
        
        for (key, array) in array {
            sectionsArray.append(GroupsSection(key: key, data: array))
        }
        sectionsArray.sort { $0 < $1 }
        return sectionsArray
    }
    
}
