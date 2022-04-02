//
//  GroupTableViewController.swift
//  VKapp
//
//  Created by MacBook on 03.12.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase

class GroupTableViewController: UITableViewController {
    
    @IBOutlet var groupTableView: UITableView!
    
    var service = RequestsServer()
    var persistence = RealmCacheService()
    
    private var notificationToken: NotificationToken? = nil
    private var communitesFirebase = [FireBaseGroup]()
    private let ref = Database.database().reference(withPath: "Communities")
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
        
        ref.observe(.value, with: { snapshot in
            var communities: [FireBaseGroup] = []
            print(snapshot, "++++++++++++++++++++++++++++++++++++++++++")
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let group = FireBaseGroup(snapshot: snapshot)
                {
                    communities.append(group)
                }
            }
            print("Обнавлен список добавленных групп")
            communities.forEach { print($0.groupName) }
            print(communities.count)
        })
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
                        let fireCom = FireBaseGroup(name: group.name.lowercased(), id: group.id)
                        let comRef = self.ref.child(group.name.lowercased())
                        comRef.setValue(fireCom.toAnyObject())
                    }
                }
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
