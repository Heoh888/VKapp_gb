//
//  FireBaseGroup.swift
//  VKapp
//
//  Created by MacBook on 05.02.2022.
//

import Foundation
//import Firebase
//
//// MARK: - FireBase для групп
//class FireBaseGroup {
//    
//    // определим проперти
//    // проперти name с типом String
//    let groupName: String
//    
//    // проперти id с типом Int
//    let groupId: Int
//    
//    // проперти ref c сылкой Reference
//    let ref: DatabaseReference!
//    
//    // инициализация проперти
//    init(name: String, id: Int) {
//        // определим дефолтные типы данных
//        self.ref = nil
//        self.groupId = id
//        self.groupName = name
//    }
//    
//    // иницилизируем, где передадим что снапшот это ссылка DataSnapShot
//    init?(snapshot: DataSnapshot) {
//        // сделаем проверку
//        guard
//            // проперти value присвоим значение типа [String: Any]
//            let value = snapshot.value as? [String: Any],
//            // проперти id присвоим значение полученное по ключу "id" типа Int
//            let id = value["groupId"] as? Int,
//            // проперти name присвоим значение полученное по ключу "name" типа String
//            let name = value["groupName"] as? String
//        else {
//            // иначе возратим nil
//            return nil
//        }
//        self.ref = snapshot.ref
//        self.groupId = id
//        self.groupName = name
//    }
//    // определим метод каторый возвращает массив типа [String: Any] из выходных параметров
//    func toAnyObject() ->  [String: Any] {
//        return [
//            "GroupId": groupId,
//            "GroupName": groupName
//        ]
//    }
//}
