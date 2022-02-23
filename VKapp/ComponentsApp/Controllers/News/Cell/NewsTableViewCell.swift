//
//  NewsTableViewCell.swift
//  VKapp
//
//  Created by MacBook on 15.12.2021.
//
import WebKit
import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var post: UIView!
    
    // Шапка поста
    @IBOutlet weak var headerSpace: UIView!
    
    // Пространство для UILabal
    @IBOutlet weak var textSpace: UIView!
    
    // Пространство для UIImageView
    @IBOutlet weak var imageSpace: UIView!
    
    // кнопка Лайк
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var like: UIImageView!
    @IBOutlet weak var likeText: UILabel!
    @IBOutlet weak var likeBase: UIView!
    
    // кнопка комментарии
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var commentsBase: UIView!
    @IBOutlet weak var commentsText: UILabel!
    
    // кнопка ре-пост
    @IBOutlet weak var rePostButton: UIButton!
    @IBOutlet weak var rePostBase: UIView!
    @IBOutlet weak var rePostText: UILabel!
    
    @IBOutlet weak var views: UILabel!
    
    private var service = RequestsServer()
    private var imageService = ImageLoader()
    private var elementPost = AddElementNews()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        post.layer.cornerRadius = 10
        headerSpace.layer.cornerRadius = 10
        rePostBase.layer.cornerRadius = rePostBase.frame.height / 2
        commentsBase.layer.cornerRadius = commentsBase.frame.height / 2
        likeBase.layer.cornerRadius = likeBase.frame.height / 2
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(news: News1, allNews: NewsModel) {
        // Предварительно очистим все пространства
        textSpace.subviews.forEach { $0.removeFromSuperview() }
        imageSpace.subviews.forEach { $0.removeFromSuperview() }
        headerSpace.subviews.forEach { $0.removeFromSuperview() }
        
        // Определим имплементацию модели
        if news.copyHistory != nil && news.attachments == nil {
            if ((news.copyHistory![0].ownerId)!) > 0 {
                // Получим информацию о пользователе
                service.loadUser(userId: String(news.copyHistory![0].ownerId!)) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let user):
                        DispatchQueue.main.async {
                            self.imageService.loadImageData(url: user.response[0].photo50 ) { [weak self] image in
                                guard let self = self else { return }
                                    self.elementPost.addElement(userName: user.response[0].firstName, avatarUser: image, space: &self.headerSpace)
                            }
                        }
                    case .failure(_):
                        return
                    }
                }
            } else {
                // Запросим информацию о группе
                service.loadGroup(groupId: String(-news.copyHistory![0].ownerId!)) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let gpoup):
                        DispatchQueue.main.async {
                            self.imageService.loadImageData(url: gpoup.response[0].photo200) { [weak self] image in
                                guard let self = self else { return }
                                self.elementPost.addElement(userName: gpoup.response[0].name, avatarUser: image, space: &self.headerSpace)
                            }
                        }
                    case .failure(_):
                        return
                    }
                }
            }
            
            if news.copyHistory![0].text! != "" {
                self.elementPost.addElement(text: news.copyHistory![0].text!, space: &textSpace)
            }
            if news.copyHistory![0].attachments?[0].type == "photo" {
                let count = news.copyHistory![0].attachments?[0].photo?.sizes.count ?? 0
                let imageUrl = news.copyHistory![0].attachments?[0].photo?.sizes[count - 1].url ?? ""
                imageService.loadImageData(url: imageUrl ) { [weak self] image in
                    guard let self = self else { return }
                    self.elementPost.addElement(image: image, space: &self.imageSpace)
                }
            }
            if news.copyHistory![0].attachments?[0].type == "video" {
                let ownerId = news.copyHistory![0].attachments?[0].video?.ownerId
                let id = news.copyHistory![0].attachments?[0].video?.id
                service.loadVideo(id: String(id!),
                                  ownerid: String(ownerId!)) {  [weak self]  result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let video):
                        DispatchQueue.main.async {
                            autoreleasepool {
                                self.elementPost.addElement(url:  video.response.items[0].player!, space: &self.imageSpace)
                            }
                        }
                    case .failure(_):
                        return
                    }
                }
            }
        } else if news.copyHistory == nil && news.attachments != nil {
            if news.sourceId! > 0 {
                // Получим информацию о пользователе
                service.loadUser(userId: String(news.sourceId!)) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let user):
                        DispatchQueue.main.async {
                            self.imageService.loadImageData(url: user.response[0].photo50 ) { [weak self] image in
                                guard let self = self else { return }
                                self.elementPost.addElement(userName: user.response[0].firstName, avatarUser: image, space: &self.headerSpace)
                            }
                        }
                    case .failure(_):
                        return
                    }
                }
            } else {
                // Запросим информацию о группе
                service.loadGroup(groupId: String(-news.sourceId!)) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let group):
                        DispatchQueue.main.async {
                            self.imageService.loadImageData(url: group.response[0].photo200) { [weak self] image in
                                guard let self = self else { return }
                                self.elementPost.addElement(userName: group.response[0].name, avatarUser: image, space: &self.headerSpace)
                            }
                        }
                    case .failure(_):
                        return
                    }
                }
            }
            if news.text! != "" {
                self.elementPost.addElement(text: news.text!, space: &textSpace)
            }
            if news.attachments![0].type == "photo" {
                let count = news.attachments?[0].photo?.sizes.count ?? 0
                let imageUrl = news.attachments?[0].photo?.sizes[count - 1].url ?? ""
                imageService.loadImageData(url: imageUrl ) { [weak self] image in
                    guard let self = self else { return }
                    self.elementPost.addElement(image: image, space: &self.imageSpace)
                }
            }
            if news.attachments![0].type == "video" {
                let ownerId = news.attachments?[0].video?.ownerId
                let id = news.attachments?[0].video?.id
                service.loadVideo(id: String(id!), ownerid: String(ownerId!)) {  [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let video):
                        DispatchQueue.main.async {
                            autoreleasepool {
                                self.elementPost.addElement(url:  video.response.items[0].player!, space: &self.imageSpace)
                            }
                        }
                    case .failure(_):
                        return
                    }
                }
            }
        }
        //        like.tintColor = likeColour(status: all.likeStatus,
        //                                    cell: like,
        //                                    statusAnimation: &all.animation)
    }
    
    // ТО:DО Перенести в общий класс с Анимацииями
    private func likeColour(status: Bool, cell: AnyObject, statusAnimation: inout Bool) -> UIColor {
        var color: UIColor
        if status == false {
            color = UIColor.gray
        } else {
            color = UIColor.red
            if statusAnimation == true {
                let animation = CASpringAnimation(keyPath: "transform.scale")
                animation.fromValue = 0
                animation.toValue = 1
                animation.duration = 1
                animation.timingFunction = .init(name: .easeInEaseOut)
                animation.mass = 2
                animation.stiffness = 400
                cell.layer.add(animation, forKey: nil)
                statusAnimation = false
            }
        }
        return color
    }
}
