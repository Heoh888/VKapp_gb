//
//  FriendsViewController.swift
//  VKapp
//
//  Created by MacBook on 06.12.2021.
//

import UIKit

class FriendscCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var idUser: Int = 0
    var friendPhotos: [String] = []
    var service = RequestsServer()
    private let imageService = ImageLoader()
    
    // MARK: - lifeСycle
    override func viewDidLoad() {
        fetchFriendsPhotos()
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "FriendsViewCell", bundle: nil), forCellWithReuseIdentifier: "FriendsViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        AppUtility.lockOrientation(.portrait)
    }
}

// MARK: - Collection view data source
extension FriendscCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return friendPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsViewCell", for: indexPath) as! FriendsViewCell
        let photo = friendPhotos[indexPath[0]]
        loadImage(url: photo) { image in
            cell.imageFriends.image = image
        }
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

extension FriendscCollectionViewController {
    func loadLatters(arrayFriendPhotos: [String]) {
        for url in arrayFriendPhotos {
            friendPhotos.append(url)
        }
    }
    
    func fetchFriendsPhotos() {
        service.loadPhotos(id: idUser) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let friendPhoto):
                let section = self.fromFriendSection(from: friendPhoto.response.items)
                self.loadLatters(arrayFriendPhotos: section)
            case .failure(_):
                return
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fromFriendSection(from array: [FriendPhoto]?) -> [String] {
        var sectionsArray: [String] = []
        for item in array! {
            sectionsArray.append(item.sizes[item.sizes.count - 1].url)
        }
        return sectionsArray
    }
    
    func loadImage(url: String, complition: @escaping(UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        imageService.loadImage(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                complition(image)
            case .failure(let error):
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
    }
}
