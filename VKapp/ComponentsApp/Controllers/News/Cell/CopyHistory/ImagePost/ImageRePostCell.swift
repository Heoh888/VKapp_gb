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
    @IBOutlet weak var heightConstraintText: NSLayoutConstraint!
    
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
    }
    
    @IBAction func likeButton(_ sender: Any) {
        if !likeCheckbox {
            service.likeAdd(type: type!, itemId: itemId!, ownerId: ownerId!)
            likeCheckbox = true
            let animation = CASpringAnimation(keyPath: "transform.scale")
            likeButton.tintColor = UIColor.red
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 1
            animation.timingFunction = .init(name: .easeInEaseOut)
            animation.mass = 2
            animation.stiffness = 400
            likeButton.imageView!.layer.add(animation, forKey: nil)
            likeButton.setTitle("\(countLIke! + 1)", for: .normal)
            countLIke! += 1
        } else {
            service.likesDelete(type: type!, itemId: itemId!, ownerId: ownerId!)
            likeCheckbox = false
            likeButton.tintColor = .systemGray
            likeButton.setTitle("\(countLIke! - 1)", for: .normal)
            countLIke! -= 1
        }
    }
}

extension ImageRePostCell: PostCellProtocol {
    
    func set<T>(value: T) where T : PostCellDataProtocol {
        type = value.type
        itemId = value.postId
        ownerId = value.sourceId
        
        likeCheckbox = false
        likeButton.tintColor = UIColor.gray
        likeButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        likeButton.setTitle("\(0)", for: .normal)
        
        let textPostheight = Double(textPost.numberOfVisibleLines) * Double(textPost.font.lineHeight)
        heightConstraintText.constant = textPostheight < 200 ? textPostheight + 3 : 200
        
        getData.getDataPostInfo(type: value.type!, itemId: value.postId!) { [weak self] liked, copied, count, items in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if liked == 1 {
                    self.likeButton.tintColor = UIColor.red
                    self.likeCheckbox = true
                }
                self.countLIke = count
                self.likeButton.setTitle("\(count)", for: .normal)
            }
        }
        
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
            self.nameUserRePost.text = "\u{21B3}" + " " + userName
        }
        
        guard let photo = value.copyHistory![0].attachments![0].photo?.sizes else { return }
        let urlImage = URL(string: photo[photo.count - 1].url)
        imagePost.kf.setImage(with: urlImage)
        
        commentsButton.setTitle("\(value.comments?.count ?? 0)", for: .normal)
        rePostButton.setTitle("\(value.reposts?.count ?? 0)", for: .normal)
        views.text = "\(value.views?.count ?? 0)"
    }
}
