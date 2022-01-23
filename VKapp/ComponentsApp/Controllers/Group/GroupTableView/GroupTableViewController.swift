//
//  GroupTableViewController.swift
//  VKapp
//
//  Created by MacBook on 03.12.2021.
//

import UIKit

class GroupTableViewController: UITableViewController {
    
    @IBOutlet var groupTableView: UITableView!
    
    var groups: [GroupsSection] = []
    var filteredGroups: [GroupsSection] = []
    var lettersOfNames: [String] = []
    var service = GroupServiceManager()
    
    // MARK: - lifeСycle
    override func viewDidLoad() {
        fetchGroups()
        super.viewDidLoad()
        groupTableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "CellViewGroup")
        AppUtility.lockOrientation(.portrait)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredGroups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups[section].data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellViewGroup", for: indexPath) as! GroupTableViewCell
        tableView.separatorColor = UIColor.clear

        let section = filteredGroups[indexPath.section]
        let name = section.data[indexPath.row].name
        let photo = section.data[indexPath.row].photo50
        cell.nameGroup.text = name
        service.loadImage(url: photo) { image in
            cell.imageGroup.image = image
        }
        cell.imageGroup.layer.cornerRadius = cell.imageGroup.frame.height / 5
        cell.cellViewGroup.layer.cornerRadius = 15
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
}
extension GroupTableViewController {
    func loadLatters() {
        for user in groups {
            lettersOfNames.append(String(user.key))
        }
    }
    
    func fetchGroups() {
        service.loadGroup { [weak self] groups in
            guard let self = self else { return }
            self.groups = groups
            self.filteredGroups = groups
            self.loadLatters()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
