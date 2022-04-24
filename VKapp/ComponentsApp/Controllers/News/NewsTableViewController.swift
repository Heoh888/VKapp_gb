//
//  NewsTableViewController.swift
//  VKapp
//
//  Created by MacBook on 15.12.2021.
//

import UIKit

enum TypeModel: String {
    case textCell
    case photoCell
    case videoCell
    case noPost
}

class NewsTableViewController: UITableViewController {
    
    @IBOutlet var tableViewNews: UITableView!
    
    var news: [News] = []
    
    private var service = RequestsServer()
    
    var group = DispatchGroup()
    
    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNews()
        AppUtility.lockOrientation(.portrait)
        tableViewNews.register(UINib(nibName: "NewsPhotoCell", bundle: nil), forCellReuseIdentifier: "NewsPhotoCell")
        tableViewNews.register(UINib(nibName: "NewsTextCell", bundle: nil), forCellReuseIdentifier: "NewsTextCell")
        tableViewNews.register(UINib(nibName: "NewsVideoCell", bundle: nil), forCellReuseIdentifier: "NewsVideoCell")
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch parsingModel(model: news[indexPath.row]) {
        case .textCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell") as! NewsTextCell
            cell.configure(item: news[indexPath.row])
            return cell
        case .photoCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell") as! NewsPhotoCell
            cell.configure(item: news[indexPath.row])
            return cell
        case .videoCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsVideoCell") as! NewsVideoCell
            cell.configure(item: news[indexPath.row])
            return cell
        case .noPost:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell") as! NewsTextCell
            return cell
        }
    }
}

extension NewsTableViewController {
    
    func fetchNews() {
        service.loadNews{  [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                self.news = news.response.items
                DispatchQueue.main.async {
                    self.tableViewNews.reloadData()
                }
            case .failure(_):
                return
            }
        }
    }
    
    func  parsingModel(model: News) -> TypeModel {
        var result: TypeModel = .noPost
        if model.attachments == nil &&  model.copyHistory == nil{
            result = .noPost
        } else {
            if model.attachments != nil {
                if model.attachments![0].photo != nil {
                    result = .photoCell
                } else if model.attachments![0].video != nil {
                    result = .videoCell
                } else {
                    result = .textCell
                }
            }
            
            if model.copyHistory != nil {
                if model.copyHistory![0].attachments != nil {
                    if model.copyHistory![0].attachments![0].photo != nil {
                        result = .photoCell
                    } else if model.copyHistory![0].attachments![0].video != nil {
                        result = .videoCell
                    } else {
                        result = .textCell
                    }
                }
            }
        }
        return result
    }
}
