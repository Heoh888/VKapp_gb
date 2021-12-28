//
//  AllGroupTableViewController.swift
//  VKapp
//
//  Created by MacBook on 07.12.2021.
//

import UIKit

class AllGroupTableViewController: UITableViewController {
    
    var allGroup = Group()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Group.init().grups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCroupTableViewCell", for: indexPath) as! AllCroupTableViewCell
        tableView.separatorColor = UIColor.clear
        cell.nameGruop.text = allGroup.grups[indexPath.row].name
        cell.imageGroup.image = allGroup.grups[indexPath.row].image
        cell.shadow.layer.cornerRadius = cell.shadow.frame.height / 7
        cell.imageGroup.layer.cornerRadius = cell.imageGroup.frame.height / 2
        cell.shadow.layer.shadowColor = UIColor.gray.cgColor
        cell.shadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.shadow.layer.shadowOpacity = 4
        return cell
    }
}
