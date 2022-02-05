//
//  FriendsTableViewController.swift
//  VKapp
//
//  Created by MacBook on 06.12.2021.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var icon = FriendscCollectionViewController()
    var friends: [FriendsSection] = []
    var filteredFriends: [FriendsSection] = []
    var lettersOfNames: [String] = []
    var service = FriendServiceManager()

    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFriends()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsTableViewCell")
        AppUtility.lockOrientation(.portrait)
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
        let lastName = section.data[indexPath.row].lastName
        let photo = section.data[indexPath.row].photo50
        cell.userName.text = name
        cell.userLastName.text = lastName
        service.loadImage(url: photo) { image in
            cell.avatar.image = image
        }
        cell.avatar.layer.cornerRadius = cell.avatar.frame.height / 5
        cell.shadow.layer.cornerRadius = 15
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyoard.instantiateViewController(identifier: "FriendscCollectionViewController") as! FriendscCollectionViewController
        vc.idUser = filteredFriends[indexPath[0]].data[indexPath[1]].id
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
