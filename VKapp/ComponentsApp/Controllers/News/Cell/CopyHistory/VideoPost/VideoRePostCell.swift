//
//  VideoRePostCell.swift
//  VKapp
//
//  Created by Алексей Ходаков on 20.05.2022.
//

import UIKit

class VideoRePostCell: UITableViewCell {
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUserRePost: UILabel!
    @IBOutlet weak var imageUserRePost: UIImageView!
    @IBOutlet weak var textPost: UILabel!
    @IBOutlet weak var videoPost: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var rePostButton: UIButton!
    @IBOutlet weak var views: UILabel!
    
    private var imageService = ImageLoader()
    private var service = RequestsServer()
    private var likeCheckbox: Bool = false
    
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
