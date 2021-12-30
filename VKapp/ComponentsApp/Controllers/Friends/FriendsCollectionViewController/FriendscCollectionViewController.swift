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
    
    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "FriendsViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendsViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

// MARK: - Collection view data source
extension FriendscCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUsers.users[index[1]].image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsViewCell", for: indexPath) as! FriendsViewCell
        cell.imageFriends.image = arrUsers.users[index[1]].image[indexPath.row]
        cell.imageFriends.layer.cornerRadius =  10
        cell.collectionCell.layer.cornerRadius =  10
        cell.shadow.layer.shadowColor = UIColor.gray.cgColor
        cell.shadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.shadow.layer.shadowOpacity = 4
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2 + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4,
                       delay: 0.1,
                       animations: {cell.transform = CGAffineTransform.identity},
                       completion: {Void in()})
    }
}

