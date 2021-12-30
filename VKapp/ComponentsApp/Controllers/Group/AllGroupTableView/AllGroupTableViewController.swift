//
//  AllGroupTableViewController.swift
//  VKapp
//
//  Created by MacBook on 07.12.2021.
//

import UIKit

class AllGroupTableViewController: UITableViewController, UISearchResultsUpdating {

    var allGroup = Group()
    
    var fillteredAllGroup = [WeatherModel]()
    
    var searchController = UISearchController(searchResultsController: nil)

    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fillteredAllGroup = allGroup.grups
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fillteredAllGroup.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCroupTableViewCell", for: indexPath) as! AllCroupTableViewCell
        tableView.separatorColor = UIColor.clear
        cell.nameGruop.text = fillteredAllGroup[indexPath.row].name
        cell.imageGroup.image = fillteredAllGroup[indexPath.row].image[0]
        cell.imageGroup.layer.cornerRadius = cell.imageGroup.frame.height / 2
        cell.shadow.layer.cornerRadius = 10
        cell.shadow.layer.shadowColor = UIColor.gray.cgColor
        cell.shadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.shadow.layer.shadowOpacity = 4
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            fillteredAllGroup = allGroup.grups
            tableView.reloadData()
        } else {
            fillteredAllGroup = allGroup.grups.filter({$0.name.lowercased().contains(searchController.searchBar.text!.lowercased())})
            tableView.reloadData()
        }
    }
}
