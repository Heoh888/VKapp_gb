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
    
    private let imageService = ImageLoader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageGroup.layer.cornerRadius = imageGroup.frame.height / 5
        cellViewGroup.layer.cornerRadius = 15
    }
        
    func configure(group: Group) {
        nameGroup.text = group.name
        imageService.loadImageData(url: group.photo50) { [weak self] image in
            guard let self = self else { return }
            self.imageGroup.image = image
        }
    }
}
