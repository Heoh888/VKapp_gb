//
//  GroupTableViewCell.swift
//  VKapp
//
//  Created by MacBook on 03.12.2021.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellViewGroup: UIView!
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var imageGroup: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
