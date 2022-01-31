//
//  GroupTableViewController.swift
//  VKapp
//
//  Created by MacBook on 03.12.2021.
//

import UIKit

class GroupTableViewController: UITableViewController {
    
    @IBOutlet var groupTableView: UITableView!
    
    var userGroups = [WeatherModel]()
    var service = RequestsServer()
    
    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.service.loadGroups()
        groupTableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "CellViewGroup")
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellViewGroup", for: indexPath) as! GroupTableViewCell
        tableView.separatorColor = UIColor.clear
        cell.nameGroup.text = userGroups[indexPath.row].name
        cell.imageGroup.image = userGroups[indexPath.row].image[0]
        cell.imageGroup.layer.cornerRadius = cell.imageGroup.frame.height / 2
        cell.cellViewGroup.layer.cornerRadius = 10
        cell.cellViewGroup.layer.shadowColor = UIColor.gray.cgColor
        cell.cellViewGroup.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.cellViewGroup.layer.shadowOpacity = 4
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Actions
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            guard let allGroupController = segue.source as? AllGroupTableViewController else { return }
            if let indexPath = allGroupController.tableView.indexPathForSelectedRow {
                let group = allGroupController.fillteredAllGroup[indexPath.row]
                print(indexPath)
                if userGroups.count == 0 {
                    userGroups.append(group)
                    tableView.reloadData()
                } else {
                    var item:Bool = false
                    for i in userGroups {
                        if i.name == group.name {
                            item = false
                            break
                        } else {
                            item = true
                        }
                    }
                    if item == true {
                        userGroups.append(group)
                        tableView.reloadData()
                        item = false
                    }
                }
            }
        }
    }
}
