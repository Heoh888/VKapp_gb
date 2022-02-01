//
//  TestModelRealm.swift
//  VKapp
//
//  Created by MacBook on 31.01.2022.
//

import Foundation
import RealmSwift

class TestModelRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

class Person: Object {
    @objc dynamic var ownerId: TestModelRealm?
    let dogs = List<ArrayUrlPhotos>()
}

class ArrayUrlPhotos: Object {
    @objc dynamic var sizes = ""
}
