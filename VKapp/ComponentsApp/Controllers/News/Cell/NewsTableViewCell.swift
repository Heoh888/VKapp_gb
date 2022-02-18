//
//  NewsTableViewCell.swift
//  VKapp
//
//  Created by MacBook on 15.12.2021.
//

import UIKit
import RealmSwift

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var post: UIView!
    
    // Шапка поста
    @IBOutlet weak var headerPost: UIView!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    // Пространство для UILabal
    @IBOutlet weak var textSpace: UIView!
    
    // Пространство для UIImageView
    @IBOutlet weak var imageSpace: UIView!
    @IBOutlet weak var constraynPostSpace: NSLayoutConstraint!
    
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
    private var arrayUserInfo: [String] = ["", "", ""]
    private let imageService = ImageLoader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        post.layer.cornerRadius = 10
        imageAvatar.layer.cornerRadius = imageAvatar.frame.height / 2
        rePostBase.layer.cornerRadius = rePostBase.frame.height / 2
        commentsBase.layer.cornerRadius = commentsBase.frame.height / 2
        likeBase.layer.cornerRadius = likeBase.frame.height / 2
        headerPost.layer.cornerRadius = 10
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(news: News1, allNews: NewsModel) {
        
        // TO:DO Остановился здесь
        // Получим информацию о пользователе
        if news.sourceId! > 0 {
            let userInfo: [String] = userInfo(userId: news.sourceId!)
            print(userInfo)
            userName.text = userInfo[0]
            imageService.loadImageData(url: userInfo[2] ) { [weak self] image in
                guard let self = self else { return }
                self.imageAvatar.image = image
            }
        }
        
        
        
        // Предварительно очистим все пространства
        textSpace.subviews.forEach {
            $0.removeFromSuperview()
        }
        imageSpace.subviews.forEach {
            $0.removeFromSuperview()
            
        }
        
        // Определим имплементацию модели
        if news.copyHistory != nil && news.attachments == nil {
            if news.copyHistory![0].text! == "" {
                textSpace.subviews.forEach {
                    $0.removeFromSuperview()
                }
            } else {
                self.addTextElement(text: news.copyHistory![0].text!)
            }
            if news.copyHistory![0].attachments?[0].photo != nil {
                let count = news.copyHistory![0].attachments?[0].photo?.sizes.count ?? 0
                let imageUrl = news.copyHistory![0].attachments?[0].photo?.sizes[count - 1].url ?? ""
                imageService.loadImageData(url: imageUrl ) { [weak self] image in
                    guard let self = self else { return }
                    self.addImageElement(image: image)
                }
            }
        } else if news.copyHistory == nil && news.attachments != nil {
            if news.text! == "" {
                textSpace.subviews.forEach {
                    $0.removeFromSuperview()
                }
            } else {
                self.addTextElement(text: news.text!)
            }
            if news.attachments![0].photo != nil {
                let count = news.attachments?[0].photo?.sizes.count ?? 0
                let imageUrl = news.attachments?[0].photo?.sizes[count - 1].url ?? ""
                imageService.loadImageData(url: imageUrl ) { [weak self] image in
                    guard let self = self else { return }
                    self.addImageElement(image: image)
                }
            }
        }
        //        like.tintColor = likeColour(status: all.likeStatus,
        //                                    cell: like,
        //                                    statusAnimation: &all.animation)
        arrayUserInfo = ["", "", ""]
    }
    
    // Добавляет элемент UIImageView в пространство "text Space"
    private func addImageElement(image: UIImage) {
        let newView = UIImageView()
        newView.image = image
        newView.contentMode = .scaleAspectFill
        newView.layer.cornerRadius = 10
        newView.layer.masksToBounds = true;
        imageSpace.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ newView.topAnchor.constraint(equalTo: imageSpace.topAnchor, constant: 10),
                                      newView.bottomAnchor.constraint(equalTo: imageSpace.bottomAnchor, constant: -10),
                                      newView.leftAnchor.constraint(equalTo: imageSpace.leftAnchor, constant: 7),
                                      newView.rightAnchor.constraint(equalTo: imageSpace.rightAnchor, constant: -7)])
    }
    
    // Добавляет элемент UILabel в пространство "imageSpace"
    private func addTextElement(text: String) {
        let newView = UILabel()
        newView.text = text
        newView.numberOfLines = 11
        textSpace.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ newView.topAnchor.constraint(equalTo: textSpace.topAnchor, constant: 10),
                                      newView.bottomAnchor.constraint(equalTo: textSpace.bottomAnchor, constant: -10),
                                      newView.leftAnchor.constraint(equalTo: textSpace.leftAnchor, constant: 11),
                                      newView.rightAnchor.constraint(equalTo: textSpace.rightAnchor, constant: -11)])
    }
    
    // Запросим информацию о пользователе
    private func userInfo(userId: Int) -> [String] {
        
        service.loadUser(userId: String(userId)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let friend):
                DispatchQueue.main.async {
                    self.arrayUserInfo.insert(friend.response[0].firstName, at: 0)
                    self.arrayUserInfo.insert(friend.response[0].photo50, at: 2)
                }
            case .failure(_):
                return
            }
        }
        return arrayUserInfo
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
