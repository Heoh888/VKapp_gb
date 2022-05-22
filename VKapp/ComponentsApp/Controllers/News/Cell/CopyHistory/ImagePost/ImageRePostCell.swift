//
//  ImageRePostCell.swift
//  VKapp
//
//  Created by Алексей Ходаков on 20.05.2022.
//

import UIKit
import Kingfisher

class ImageRePostCell: UITableViewCell {
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUserRePost: UILabel!
    @IBOutlet weak var imageUserRePost: UIImageView!
    @IBOutlet weak var textPost: UILabel!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var rePostButton: UIButton!
    @IBOutlet weak var views: UILabel!
    
    private var imageService = ImageLoader()
    private var service = RequestsServer()
    private var likeCheckbox: Bool = false
    
    private var getData = ViewNewsModel()
    
    private var type: String?
    private var itemId: Int?
    private var ownerId: Int?
    private var countLIke: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageUser.layer.cornerRadius = imageUser.frame.height / 2
        imageUserRePost.layer.cornerRadius = imageUserRePost.frame.height / 2
        likeButton.layer.cornerRadius = 12
        likeButton.clipsToBounds = true
        commentsButton.layer.cornerRadius = 12
        commentsButton.clipsToBounds = true
        rePostButton.layer.cornerRadius = 12
        rePostButton.clipsToBounds = true
        likeCheckbox = false
    }
    
    private func getLikedInfo () {
        service.likesGetList(type: type!, itemId: itemId!, ownerId: ownerId!) { [weak self] result in
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
        service.likesIsLiked(type: type!, itemId: itemId!, ownerId: ownerId!) { [weak self] result in
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
extension ImageRePostCell: PostCellProtocol {
    
    func set<T>(value: T) where T : PostCellDataProtocol {
        
        if value.copyHistory![0].attachments != nil {

            let sourceId: String = value.sourceId! > 0 ? String(value.sourceId!) : String(-value.sourceId!)
            
            getData.getDataUser(id: sourceId) { [weak self] image, userName in
                guard let self = self else { return }
                self.imageUser.image = image
                self.nameUser.text = userName
            }

            let ownerId: String = value.copyHistory![0].ownerId! > 0 ? String(value.copyHistory![0].ownerId!) : String(-value.copyHistory![0].ownerId!)
            
            getData.getDataUser(id: ownerId) { [weak self] image, userName in
                guard let self = self else { return }
                self.imageUserRePost.image = image
                self.nameUserRePost.text = userName
            }
        }
        
        textPost.text = value.text!
        
        guard let photo = value.copyHistory![0].attachments![0].photo?.sizes else { return }
        let urlImage = URL(string: photo[photo.count - 1].url)
        imagePost.kf.setImage(with: urlImage)
        
        commentsButton.setTitle("\(value.comments?.count ?? 0)", for: .normal)
        rePostButton.setTitle("\(value.reposts?.count ?? 0)", for: .normal)
        views.text = "\(value.views?.count ?? 0)"
    }
}

