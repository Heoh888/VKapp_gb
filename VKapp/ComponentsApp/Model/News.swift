//
//  News.swift
//  VKapp
//
//  Created by MacBook on 15.12.2021.
//

import UIKit

struct NewsModel {
    let nameUser:String
    let imageAvatar:UIImage
    let imagePost:UIImage
    let textPost:String
    var like:Int
    var likeStatus: Bool
    var rePost:Int
    let comment:[String]
    let views:Int
}

class News {
    
    var news:[NewsModel] = [NewsModel(nameUser: "Amelia",
                                      imageAvatar: UIImage(named: "7")!,
                                      imagePost: UIImage(named: "4")!,
                                      textPost: "Ok",
                                      like: 2000,
                                      likeStatus: false,
                                      rePost: 2,
                                      comment: ["Ghb","wefdf"],
                                      views: 2),
                            NewsModel(nameUser: "Oliver",
                                      imageAvatar: UIImage(named: "4")!,
                                      imagePost: UIImage(named: "2")!,
                                      textPost: "Ok",
                                      like: 5,
                                      likeStatus: false,
                                      rePost: 20,
                                      comment: ["derfw","wrwefdf"],
                                      views: 2),
                            NewsModel(nameUser: "Tony",
                                      imageAvatar: UIImage(named: "2")!,
                                      imagePost: UIImage(named: "2")!,
                                      textPost: "Ok",
                                      like: 5,
                                      likeStatus: false,
                                      rePost: 20,
                                      comment: ["derfw","wrwefdf"],
                                      views: 2),
                            NewsModel(nameUser: "Mason",
                                      imageAvatar: UIImage(named: "3")!,
                                      imagePost: UIImage(named: "2")!,
                                      textPost: "Ok",
                                      like: 5,
                                      likeStatus: false,
                                      rePost: 20,
                                      comment: ["derfw","wrwefdf"],
                                      views: 2),
                            NewsModel(nameUser: "TheCat",
                                      imageAvatar: UIImage(named: "TheСat")!,
                                      imagePost: UIImage(named: "2")!,
                                      textPost: "Ok",
                                      like: 5,
                                      likeStatus: false,
                                      rePost: 20,
                                      comment: ["derfw","wrwefdf"],
                                      views: 2)]
}

