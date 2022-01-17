//
//  Session.swift
//  VKapp
//
//  Created by MacBook on 02.01.2022.
//

import Foundation

class Session {
    
    static let instance = Session()
    
    private init() {}
    
    var token: String?
    var userId: Int?
}
