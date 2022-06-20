//
//  GroupTableViewController.swift
//  VKapp
//
//  Created by MacBook on 03.12.2021.
//

import UIKit
import RealmSwift
import PromiseKit

class GroupTableViewController: UITableViewController {
    
    @IBOutlet var groupTableView: UITableView!
    
    var service = RequestsServer()
    var persistence = RealmCacheService()
    private var getUrl = ConfigureUrl()
    private var notificationToken: NotificationToken? = nil
    private lazy var realm = RealmCacheService()
    private var groupResponce: Results<Group>? {
        realm.read(Group.self)
    }
    
    // MARK: - lifeСycle
    override func viewDidLoad() {
        createNotificationGroupToken()
        fetchGroups()
        super.viewDidLoad()
        groupTableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "CellViewGroup")
        AppUtility.lockOrientation(.portrait)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupResponce?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellViewGroup", for: indexPath) as! GroupTableViewCell
        tableView.separatorColor = UIColor.clear
        if let groups = groupResponce {
            cell.configure(group: groups[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        service.deleteGroup(idGroup: groupResponce![indexPath[1]].id)
        let realm = try! Realm()
        print(realm.configuration.fileURL!)
        let group = realm.objects(Group.self)
        for item in group {
            if item.id == groupResponce![indexPath[1]].id {
                try! realm.write {
                    realm.delete(group[indexPath[1]])
                }
                break;
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            guard let allGroupController = segue.source as? AllGroupTableViewController else { return }
            if let indexPath = allGroupController.tableView.indexPathForSelectedRow {
                let group = allGroupController.groupArrayModel[indexPath.row]
                service.joinGroup(idGroup: group.id)
                DispatchQueue.main.async {
                    autoreleasepool {
                        try! self.persistence.add(object: group)
                    }
                }
            }
        }
    }
    deinit {
        notificationToken?.invalidate()
    }
}
extension GroupTableViewController {
    
    func fetchGroups() {
        firstly {
            URLSession.shared.dataTask(.promise, with: getUrl.getUrlFriends()!)
        }
        .compactMap { try JSONDecoder().decode(GroupsVk.self, from: $0.data) }
        .done { groups in
            let realm = try! Realm()
            let groupsCount = realm.objects(Group.self)
            if groupsCount.count != groups.response.items.count {
                try! realm.write {
                    realm.delete(groupsCount)
                }
                DispatchQueue.main.async {
                    autoreleasepool {
                        try! self.persistence.add(object: groups.response.items)
                    }
                }
            }
        }
    }
    
    func createNotificationGroupToken() {
        let realm = try! Realm()
        let results = realm.objects(Group.self)
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
