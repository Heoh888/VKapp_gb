//
//  FriendsTableViewCell.swift
//  VKapp
//
//  Created by MacBook on 29.11.2021.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {


    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
