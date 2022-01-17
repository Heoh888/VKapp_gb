//
//  FriendsSection.swift
//  VKapp
//
//  Created by MacBook on 17.01.2022.
//

import Foundation

struct FriendsSection: Comparable {
    
    var key: Character
    var data:[Friend]
    
    static func < (lhs: FriendsSection, rhs: FriendsSection) -> Bool {
        return lhs.key < rhs.key
    }
    
    static func == (lhs: FriendsSection, rhs: FriendsSection) -> Bool {
        return lhs.key == rhs.key
    }
}
