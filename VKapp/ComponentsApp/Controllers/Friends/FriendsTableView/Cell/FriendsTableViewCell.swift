//
//  FriendsTableViewCell.swift
//  VKapp
//
//  Created by MacBook on 29.11.2021.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLastName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    private let imageService = ImageLoader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = avatar.frame.height / 5
        shadow.layer.cornerRadius = 15
    }
    
    func configure(friend: Friend) {
        userName.text = friend.firstName
        userLastName.text = friend.lastName
        imageService.loadImageData(url: friend.photo50) { [weak self] image in
            guard let self = self else { return }
            self.avatar.image = image
        }
    }
}
