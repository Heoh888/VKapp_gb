//
//  AllCroupTableViewCell.swift
//  VKapp
//
//  Created by MacBook on 14.12.2021.
//

import UIKit
import SwiftUI

class AllCroupTableViewCell: UITableViewCell {


    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var nameGruop: UILabel!
    
    private let imageService = ImageLoader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageGroup.layer.cornerRadius = imageGroup.frame.height / 5
        shadow.layer.cornerRadius = 15
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(group: GroupsSearchModel) {
        nameGruop.text = group.name
        imageService.loadImageData(url: group.imageUrl) { [weak self] image in
            guard let self = self else { return }
            self.imageGroup.image = image
        }
    }
}
