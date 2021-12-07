//
//  AllCroupTableViewCell.swift
//  VKapp
//
//  Created by MacBook on 07.12.2021.
//

import UIKit

class AllCroupTableViewCell: UITableViewCell {

    @IBOutlet weak var cellViewGroup: UIView!
    @IBOutlet weak var nameGruop: UILabel!
    @IBOutlet weak var imageGroup: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
