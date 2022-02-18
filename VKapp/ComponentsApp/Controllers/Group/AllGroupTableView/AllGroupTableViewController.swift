//
//  AllGroupTableViewController.swift
//  VKapp
//
//  Created by MacBook on 07.12.2021.
//

import UIKit

struct GroupsSearchModel {
    let id: Int
    let name: String
    let imageUrl: String
}

class AllGroupTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var groupArrayModel = [Group]()
    var fillteredAllGroup = [GroupsSearchModel]()
    var service = RequestsServer()
    var searchController = UISearchController(searchResultsController: nil)

    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fillteredAllGroup = []
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        AppUtility.lockOrientation(.portrait)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fillteredAllGroup.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCroupTableViewCell", for: indexPath) as! AllCroupTableViewCell
        tableView.separatorColor = UIColor.clear
        cell.configure(group: fillteredAllGroup[indexPath.row])
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! != "" {
            service.loadGroupsSearch(q: searchController.searchBar.text!) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let group):
                    self.fillteredAllGroup = self.createArrayGroupSearch(model: group.response.items)
                    self.groupArrayModel = group.response.items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    return
                }
            }
        }
    }
}
extension AllGroupTableViewController {
    func createArrayGroupSearch(model: [Group]) -> [GroupsSearchModel] {
        var result: [GroupsSearchModel] = []
        for item in model {
            result.append(GroupsSearchModel(id: item.id, name: item.name, imageUrl: item.photo50))
        }
        return result
    }
}
