//
//  FriendsViewController.swift
//  VKapp
//
//  Created by MacBook on 06.12.2021.
//

import UIKit

class FriendscCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var indexPath = IndexPath(item: 0, section: 0)
    
    private var arrUsers = PulUsers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "FriendsViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendsViewCell")
        // Do any additional setup after loading the view.
        print(indexPath)
    }
}
extension FriendscCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsViewCell", for: indexPath) as! FriendsViewCell
        let user = arrUsers.users[self.indexPath[1]]
        print(indexPath.item)
        cell.setupCell(user: user)
        return cell
    }
}

