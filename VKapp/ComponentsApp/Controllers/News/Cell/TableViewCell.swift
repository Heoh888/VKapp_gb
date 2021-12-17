//
//  TableViewCell.swift
//  VKapp
//
//  Created by MacBook on 17.12.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var news = NewsTableViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
