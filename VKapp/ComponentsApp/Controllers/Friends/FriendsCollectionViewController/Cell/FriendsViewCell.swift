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
            like.tintColor = UIColor.red
        }
        else if like.tintColor == UIColor.red {
            like.tintColor = UIColor.gray
        }
    }
}
