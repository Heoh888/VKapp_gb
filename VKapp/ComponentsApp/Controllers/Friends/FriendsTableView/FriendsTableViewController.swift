//
//  FriendsTableViewController.swift
//  VKapp
//
//  Created by MacBook on 06.12.2021.
//

import UIKit

class FriendsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrUsers = User()
    var icon = FriendscCollectionViewController()
    var friends: [FriendsSection] = []
    var filteredFriends: [FriendsSection] = []
    var lettersOfNames: [String] = []
    var service = FriendServiceManager()
    
    var service1 = RequestsServer()

    
    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFriends()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsTableViewCell")
    }
}

// MARK: - Table view data source
extension FriendsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as! FriendsTableViewCell
        tableView.separatorColor = UIColor.clear
        let section = filteredFriends[indexPath.section]
        let name = section.data[indexPath.row].firstName
        let photo = section.data[indexPath.row].photo50
        cell.userName.text = name
        service.loadImage(url: photo) { image in
            cell.avatar.image = image
        }
        cell.avatar.layer.cornerRadius = cell.avatar.frame.height / 2
        cell.shadow.layer.cornerRadius = 10
        cell.shadow.layer.shadowColor = UIColor.gray.cgColor
        cell.shadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.shadow.layer.shadowOpacity = 4
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyoard.instantiateViewController(identifier: "FriendscCollectionViewController") as! FriendscCollectionViewController
        vc.index = IndexPath(row: indexPath[1], section: 0)
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FriendsTableViewController {
    func loadLatters() {
        for user in friends {
            lettersOfNames.append(String(user.key))
        }
    }
    
    func fetchFriends() {
        service.loadFriend { [weak self] friends in
            guard let self = self else { return }
            self.friends = friends
            self.filteredFriends = friends
            self.loadLatters()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
