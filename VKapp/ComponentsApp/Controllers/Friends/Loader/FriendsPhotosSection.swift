//
//  FriendsPhotosSection.swift
//  VKapp
//
//  Created by MacBook on 23.01.2022.
//

struct FriendsPhotosSection: Comparable {
    
    var key: Character
    var data: [FriendPhoto]

    static func < (lhs: FriendsPhotosSection, rhs: FriendsPhotosSection) -> Bool {
        return lhs.key < rhs.key
    }
    
    static func == (lhs: FriendsPhotosSection, rhs: FriendsPhotosSection) -> Bool {
        return lhs.key == rhs.key
    }
}
