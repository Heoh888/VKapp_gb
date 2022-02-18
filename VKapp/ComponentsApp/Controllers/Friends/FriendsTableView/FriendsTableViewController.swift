//
//  FriendsTableViewController.swift
//  VKapp
//
//  Created by MacBook on 06.12.2021.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController {
    
    @IBOutlet weak var friendTableView: UITableView!

    private var service = RequestsServer()
    private var persistence = RealmCacheService()
    private var notificationToken: NotificationToken? = nil
    private lazy var realm = RealmCacheService()
    private var friendResponce: Results<Friend>? {
        realm.read(Friend.self)
    }
    
    // MARK: - lifeСycle
    override func viewDidLoad() {
        createNotificationFriendToken()
        fetchFriends()
        super.viewDidLoad()
        friendTableView.register(UINib(nibName: "FriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsTableViewCell")
        AppUtility.lockOrientation(.portrait)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendResponce?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as! FriendsTableViewCell
        tableView.separatorColor = UIColor.clear
        if let friends = friendResponce {
            cell.configure(friend: friends[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyoard.instantiateViewController(identifier: "FriendscCollectionViewController") as! FriendscCollectionViewController
        vc.idUser = friendResponce![indexPath[1]].id
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FriendsTableViewController {

    func fetchFriends() {
        service.loadFriend { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let friend):
                let realm = try! Realm()
                let friendCount = realm.objects(Friend.self)
            // TO:DO до делать удаление по индексу
                if friendCount.count != friend.response.items.count {
                    try! realm.write {
                        realm.delete(friendCount)
                    }
                    DispatchQueue.main.async {
                        autoreleasepool {
                            try! self.persistence.add(object: friend.response.items)
                        }
                    }
                }
            case .failure(_):
                return
            }
        }
    }
    
    func createNotificationFriendToken() {
        let realm = try! Realm()
        let results = realm.objects(Friend.self)
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}
