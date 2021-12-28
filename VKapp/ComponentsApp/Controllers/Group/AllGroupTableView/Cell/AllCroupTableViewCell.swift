//
//  AllCroupTableViewCell.swift
//  VKapp
//
//  Created by MacBook on 14.12.2021.
//

import UIKit

class AllCroupTableViewCell: UITableViewCell {


    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var nameGruop: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
