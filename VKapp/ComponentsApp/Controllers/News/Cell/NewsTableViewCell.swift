//
//  NewsTableViewCell.swift
//  VKapp
//
//  Created by MacBook on 15.12.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var headerPost: UIView!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var post: UIView!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var textPost: UILabel!
    @IBOutlet weak var imagePost: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var like: UIImageView!
    @IBOutlet weak var likeText: UILabel!
    @IBOutlet weak var likeBase: UIView!
    
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var commentsBase: UIView!
    @IBOutlet weak var commentsText: UILabel!
    
    @IBOutlet weak var rePostButton: UIButton!
    @IBOutlet weak var rePostBase: UIView!
    @IBOutlet weak var rePostText: UILabel!
    
    @IBOutlet weak var views: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
