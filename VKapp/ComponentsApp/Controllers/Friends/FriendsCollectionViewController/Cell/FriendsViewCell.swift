//
//  FriendsViewCell.swift
//  VKapp
//
//  Created by MacBook on 06.12.2021.
//

import UIKit

class FriendsViewCell: UICollectionViewCell {

    @IBOutlet weak var imageFriends: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(user: User) {
        self.imageFriends.image = user.image
    }
}
