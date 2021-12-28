//
//  FriendsViewCell.swift
//  VKapp
//
//  Created by MacBook on 06.12.2021.
//

import UIKit

class FriendsViewCell: UICollectionViewCell {
    
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var collectionCell: UIView!
    @IBOutlet weak var imageFriends: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        like.tintColor = UIColor.gray
    }
    
    @IBAction func likeButton(_ sender: Any) {
        if like.tintColor == UIColor.gray {
            let animation = CASpringAnimation(keyPath: "transform.scale")
            like.tintColor = UIColor.red
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 1
            animation.timingFunction = .init(name: .easeInEaseOut)
            animation.mass = 2
            animation.stiffness = 400
            like.layer.add(animation, forKey: nil)
        }
        else if like.tintColor == UIColor.red {
            like.tintColor = UIColor.gray
        }
    }
}
