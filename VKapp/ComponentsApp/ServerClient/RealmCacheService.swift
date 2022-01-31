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
    
    static let shared = RealmCacheService()
    private let realm: Realm
    
    private init?() {
        let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configuration) else { return nil }
        self.realm = realm
    }
    
    func add<T: Object>(object: T) throws {
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func add<T: Object>(object: [T]) throws {
        do {
            realm.beginWrite()
            realm.add(object, update: .modified)
            try realm.commitWrite()
            
        } catch {
            print(ErrorsFromCache.noPrimaryKeys(""))
        }
    }
    
    func update<T: Object>(type: T, primaryKeyValue: Any, setNewValue: Any, field: String) throws {
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
        return realm.objects(T.self)
    }
    
    func delete<T: Object>(object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }
    
    func deleteAll() throws {
        try realm.write {
            realm.deleteAll()
        }
    }
}
