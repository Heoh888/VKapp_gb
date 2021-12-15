//
//  FriendsViewController.swift
//  VKapp
//
//  Created by MacBook on 06.12.2021.
//

import UIKit

class FriendscCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var index = IndexPath(item: 0, section: 0)
    
    private var arrUsers = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "FriendsViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendsViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}
extension FriendscCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsViewCell", for: indexPath) as! FriendsViewCell
        cell.imageFriends.image = arrUsers.users[index[1]].image
        cell.collectionCell.layer.cornerRadius = cell.collectionCell.frame.height / 20
        cell.shadow.layer.shadowColor = UIColor.gray.cgColor
        cell.shadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.shadow.layer.shadowOpacity = 4
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.size)
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2 + 30)
    }
    

    

}

