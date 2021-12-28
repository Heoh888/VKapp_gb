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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsTableViewCell")
    }
}
extension FriendsTableViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUsers.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as! FriendsTableViewCell
        tableView.separatorColor = UIColor.clear
        cell.userName.text = arrUsers.users[indexPath.row].name
        cell.avatar.image = arrUsers.users[indexPath.row].image
        cell.shadow.layer.cornerRadius = cell.shadow.frame.height / 7
        cell.avatar.layer.cornerRadius = cell.avatar.frame.height / 2
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

