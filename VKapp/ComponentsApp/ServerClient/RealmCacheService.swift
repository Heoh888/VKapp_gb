//
//  RealmCacheService.swift
//  VKapp
//
//  Created by MacBook on 31.01.2022.
//

import RealmSwift

class RealmCacheService {
    enum ErrorsFromCache: Error {
        case noRealmObjct(String)
        case noPrimaryKeys(String)
        case failedToReads(String)
    }
    
    func add<T: Object>(object: T) throws {
        let realm = try! Realm()
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func add<T: Object>(object: [T]) throws {
        let realm = try! Realm()
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func read<T: Object>(_ object: T.Type, key: String = "", complition: (Result<T, Error>) -> Void) {
        let realm = try! Realm()
        if let result = realm.object(ofType: T.self, forPrimaryKey: key) {
            complition(.success(result))
        }
    }
    
    func read<T: Object>(_ object: T.Type) -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self)
    }
    
    func update<T: Object>(type: T, primaryKeyValue: Any, setNewValue: Any, field: String) throws {
        let realm = try! Realm()
        try realm.write {
            guard let primaryKey = T.primaryKey() else {
                print("No primaryKey")
                return
            }
            let target = realm.objects(T.self).filter("\(primaryKey) = %#", primaryKeyValue)
            target.setValue(setNewValue, forKey: "\(field)")
        }
    }
    
    func grtObject<T: Object>(type: T.Type) throws -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self)
    }
    
    func delete<T: Object>(object: T) throws {
        let realm = try! Realm()
        try realm.write {
            realm.delete(object)
        }
    }
    
    func deleteAll() throws {
        let realm = try! Realm()
        try realm.write {
            realm.deleteAll()
        }
    }
}
