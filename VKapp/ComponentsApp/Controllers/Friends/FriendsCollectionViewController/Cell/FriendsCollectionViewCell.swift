//
//  FriendsCollectionViewCell.swift
//  VKapp
//
//  Created by MacBook on 15.12.2021.
//

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageFriends: UIImageView!
    @IBOutlet weak var like: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        like.tintColor = UIColor.gray
    }

    @IBAction func likeButton(_ sender: Any) {
        if like.tintColor == UIColor.gray {
            like.tintColor = UIColor.red
        }
        else if like.tintColor == UIColor.red {
            like.tintColor = UIColor.gray
        }
    }
}
