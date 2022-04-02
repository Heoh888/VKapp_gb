//
//  AddElementNews.swift
//  VKapp
//
//  Created by MacBook on 23.02.2022.
//

import WebKit
import UIKit

class AddElementNews {
    
    func addElement(image: UIImage, space: inout UIView) {
        let newView = UIImageView()
        newView.image = image
        newView.contentMode = .scaleAspectFill
        newView.layer.cornerRadius = 10
        newView.layer.masksToBounds = true;
        space.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ newView.topAnchor.constraint(equalTo: space.topAnchor, constant: 10),
                                      newView.bottomAnchor.constraint(equalTo: space.bottomAnchor, constant: -10),
                                      newView.leftAnchor.constraint(equalTo: space.leftAnchor, constant: 7),
                                      newView.rightAnchor.constraint(equalTo: space.rightAnchor, constant: -7)])
    }
    
    // Добавляет элемент UILabel в пространство "imageSpace"
    func addElement(text: String, space: inout UIView) {
        let newView = UILabel()
        newView.text = text
        newView.numberOfLines = 11
        space.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ newView.topAnchor.constraint(equalTo: space.topAnchor, constant: 10),
                                      newView.bottomAnchor.constraint(equalTo: space.bottomAnchor, constant: -10),
                                      newView.leftAnchor.constraint(equalTo: space.leftAnchor, constant: 11),
                                      newView.rightAnchor.constraint(equalTo: space.rightAnchor, constant: -11)])
    }
    
    // Добавляет элемент UILabel в пространство "imageSpace"
    func addElement(url: String, space: inout UIView) {
        let webKit = WKWebView()
        guard let url = URL(string: url) else { return }
        webKit.layer.cornerRadius = 10
        webKit.layer.masksToBounds = true;
        space.addSubview(webKit)
        webKit.load(URLRequest(url: url))
        webKit.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ webKit.topAnchor.constraint(equalTo: space.topAnchor, constant: 10),
                                      webKit.bottomAnchor.constraint(equalTo: space.bottomAnchor, constant: -10),
                                      webKit.leftAnchor.constraint(equalTo: space.leftAnchor, constant: 7),
                                      webKit.rightAnchor.constraint(equalTo: space.rightAnchor, constant: -7)])
    }
    
    func addElement(userName: String, avatarUser: UIImage, space: inout UIView) {
        let avatarUserView = UIImageView()
        let userNameView = UILabel()
        avatarUserView.image = avatarUser
        avatarUserView.contentMode = .scaleAspectFill
        avatarUserView.layer.cornerRadius = 9
        avatarUserView .layer.masksToBounds = true;
        userNameView.text = userName
        space.addSubview(avatarUserView)
        space.addSubview(userNameView)
        
        if space.subviews.contains(avatarUserView) {
           print("ok")
          }else{
           print("yj")
        }
        
        avatarUserView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ avatarUserView.topAnchor.constraint(equalTo: space.topAnchor, constant: 7),
                                      avatarUserView.bottomAnchor.constraint(equalTo: space.bottomAnchor, constant: -7),
                                      avatarUserView.leftAnchor.constraint(equalTo: space.leftAnchor, constant: 7),
                                      avatarUserView.heightAnchor.constraint(equalToConstant: 40),
                                      avatarUserView.widthAnchor.constraint(equalToConstant: 40)])
        
        userNameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ userNameView.topAnchor.constraint(equalTo: space.topAnchor, constant: 10),
                                      userNameView.bottomAnchor.constraint(equalTo: space.bottomAnchor, constant: -10),
                                      userNameView.leftAnchor.constraint(equalTo: avatarUserView.rightAnchor, constant: 11),
                                      userNameView.rightAnchor.constraint(equalTo: space.rightAnchor, constant: -11)])
    }

}
