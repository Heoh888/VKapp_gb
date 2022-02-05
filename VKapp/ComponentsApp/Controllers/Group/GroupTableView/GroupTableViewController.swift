//
//  GroupTableViewController.swift
//  VKapp
//
//  Created by MacBook on 03.12.2021.
//

import UIKit
import RealmSwift

class GroupTableViewController: UITableViewController {
    
    @IBOutlet var groupTableView: UITableView!
    
    var service = RequestsServer()
    var persistence = RealmCacheService()
    
    private lazy var realm = RealmCacheService()
    private var groupResponce: Results<Group>? {
        realm.read(Group.self)
    }
    
    private  var notificationToken: NotificationToken? = nil
    
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
        //        if editingStyle == .delete {
        //            userGroups.remove(at: indexPath.row)
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //        }
    }
    
    // MARK: - Actions
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        //        if segue.identifier == "addGroup" {
        //            guard let allGroupController = segue.source as? AllGroupTableViewController else { return }
        //            if let indexPath = allGroupController.tableView.indexPathForSelectedRow {
        //                let group = allGroupController.fillteredAllGroup[indexPath.row]
        //                print(indexPath)
        //                if groups.count == 0 {
        //                    groups.append(group)
        //                    tableView.reloadData()
        //                } else {
        //                    var item:Bool = false
        //                    for i in groups {
        //                        if i.name == group.name {
        //                            item = false
        //                            break
        //                        } else {
        //                            item = true
        //                        }
        //                    }
        //                    if item == true {
        //                        groups.append(group)
        //                        tableView.reloadData()
        //                        item = false
        //                    }
        //                }
        //            }
        //        }
    }
    deinit {
        notificationToken?.invalidate()
    }
}
extension GroupTableViewController {

    func fetchGroups() {
        service.loadGroups { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let group):
               
                let realm = try! Realm()
                let groupsCount = realm.objects(Group.self)
                
            // TO:DO до делать удаление по индексу
                if groupsCount.count != group.response.items.count {
                    try! realm.write {
                        realm.delete(groupsCount)
                    }
                    DispatchQueue.main.async {
                        autoreleasepool {
                            try! self.persistence.add(object: group.response.items)
                        }
                    }
                }
            case .failure(_):
                return
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
