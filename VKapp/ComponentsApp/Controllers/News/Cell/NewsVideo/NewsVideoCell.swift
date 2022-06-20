//
//  NewsVideoCell.swift
//  VKapp
//
//  Created by Алексей Ходаков on 21.04.2022.
//
import WebKit
import UIKit

class NewsVideoCell: UITableViewCell {
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var textPost: UILabel!
    @IBOutlet weak var videoPost: WKWebView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var rePostButton: UIButton!
    @IBOutlet weak var views: UILabel!
    
    private var imageService = ImageLoader()
    private var service = RequestsServer()
    
    var likeCheckbox: Bool = false
    var type: String = ""
    var itemId: Int = 0
    var ownerId: Int = 0
    var countLIke: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageUser.layer.cornerRadius = imageUser.frame.height / 5
        videoPost.layer.cornerRadius = 10
        likeButton.layer.cornerRadius = 12
        likeButton.clipsToBounds = true
        commentsButton.layer.cornerRadius = 12
        commentsButton.clipsToBounds = true
        rePostButton.layer.cornerRadius = 12
        rePostButton.clipsToBounds = true
        likeCheckbox = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(model: [News], indexPath: Int) {
        let item = model[indexPath]
        likeCheckbox = false
        likeButton.tintColor = UIColor.gray
        likeButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        getLikedInfo()
        commentsButton.setTitle("\(item.comments?.count ?? 0)", for: .normal)
        rePostButton.setTitle("\(item.reposts?.count ?? 0)", for: .normal)
        views.text = "\(item.views?.count ?? 0)"
        
        if item.attachments != nil {
            if item.sourceId! > 0 {
                // Получим информацию о пользователе
                    self.service.loadUser(userId: String(item.sourceId!)) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let user):
                            self.imageService.loadImageData(url: user.response[0].photo50 ) { [weak self] image in
                                guard let self = self else { return }
                                self.nameUser.text = user.response[0].firstName
                                self.imageUser.image = image
                            }
                        case .failure(_):
                            return
                        }
                }
            } else {
                // Запросим информацию о группе
                    self.service.loadGroup(groupId: String(-item.sourceId!)) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let group):
                            self.imageService.loadImageData(url: group.response[0].photo200) { [weak self] image in
                                guard let self = self else { return }
                                self.nameUser.text = group.response[0].name
                                self.imageUser.image = image
                            }
                        case .failure(_):
                            return
                        }
                }
            }
            textPost.text = item.text
            let ownerId = item.attachments?[0].video?.ownerId
            let id = item.attachments?[0].video?.id
            service.loadVideo(id: String(id!), ownerid: String(ownerId!)) {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let video):
                    if video.response.items.count > 0 {
                        guard let url = URL(string: video.response.items[0].player!) else { return }
                        DispatchQueue.main.async {
                            self.videoPost.load(URLRequest(url: url))
                        }
                    }
                case .failure(_):
                    return
                }
            }
        }
        
        if item.copyHistory != nil {
            if ((item.copyHistory![0].ownerId)!) > 0 {
                // Получим информацию о пользователе
                    self.service.loadUser(userId: String(item.copyHistory![0].ownerId!)) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let user):
                            self.imageService.loadImageData(url: user.response[0].photo50 ) { [weak self] image in
                                guard let self = self else { return }
                                self.nameUser.text = user.response[0].firstName
                                self.imageUser.image = image
                            }
                        case .failure(_):
                            return
                        }
                }
            } else {
                // Запросим информацию о группе
                    self.service.loadGroup(groupId: String(-item.copyHistory![0].ownerId!)) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let group):
                            self.imageService.loadImageData(url: group.response[0].photo200) { [weak self] image in
                                guard let self = self else { return }
                                self.nameUser.text = group.response[0].name
                                self.imageUser.image = image
                            }
                        case .failure(_):
                            return
                        }
                }
            }
            textPost.text = item.copyHistory![0].text
            let ownerId = item.copyHistory![0].attachments?[0].video?.ownerId
            let id = item.copyHistory![0].attachments?[0].video?.id
            service.loadVideo(id: String(id!), ownerid: String(ownerId!)) {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let video):
                    if video.response.items.count > 0 {
                        guard let url = URL(string: video.response.items[0].player!) else { return }
                        DispatchQueue.main.async {
                            self.videoPost.load(URLRequest(url: url))
                        }
                    }
                case .failure(_):
                    return
                }
            }
        }
    }
    
    @IBAction func likeButton(_ sender: Any) {
        print("Like")
        if !likeCheckbox {
            likeCheckbox.toggle()
            let animation = CASpringAnimation(keyPath: "transform.scale")
            likeButton.tintColor = UIColor.red
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 1
            animation.timingFunction = .init(name: .easeInEaseOut)
            animation.mass = 2
            animation.stiffness = 400
            likeButton.imageView!.layer.add(animation, forKey: nil)
        } else {
            likeCheckbox.toggle()
            likeButton.tintColor = .systemGray
        }
    }
    
}
extension NewsVideoCell {
    
    func getLikedInfo () {
        service.likesGetList(type: type, itemId: itemId, ownerId: ownerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let likeList):
                DispatchQueue.main.async {
                    self.countLIke = likeList.response.count!
                    self.likeButton.setTitle("\(likeList.response.count!)", for: .normal)
                }
            case .failure(_):
                return
            }
        }
        service.likesIsLiked(type: type, itemId: itemId, ownerId: ownerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let like):
                DispatchQueue.main.async {
                    if like.response.liked == 1 {
                        self.likeButton.tintColor = UIColor.red
                        self.likeCheckbox = true
                    }
                }
            case .failure(_):
                return
            }
        }
    }
}
