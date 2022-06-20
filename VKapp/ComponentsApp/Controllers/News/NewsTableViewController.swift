//
//  NewsTableViewController.swift
//  VKapp
//
//  Created by MacBook on 15.12.2021.
//

import UIKit

enum TypeModel: String {
    case textCell = "NewsTextCell"
    case photoCell = "NewsPhotoCell"
    case videoCell = "NewsVideoCell"
    case noPost = "noPost"
}

class NewsTableViewController: UITableViewController {
    
    @IBOutlet var tableViewNews: UITableView!
    
    var news: [News] = []
    
    private var service = RequestsServer()
    
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
        var cell: AnyObject!
        print(news[indexPath.row])
        if parsingModel(model: news[indexPath.row]).rawValue == "noPost" {
            cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
        }
        if parsingModel(model: news[indexPath.row]).rawValue == "NewsTextCell" {
             cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
            (cell as! NewsTextCell).configure(item: news[indexPath.row])

        }
        if parsingModel(model: news[indexPath.row]).rawValue == "NewsPhotoCell" {
             cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell", for: indexPath) as! NewsPhotoCell
            (cell as! NewsPhotoCell).configure(item: news[indexPath.row])

        }
        if parsingModel(model: news[indexPath.row]).rawValue == "NewsVideoCell" {
             cell = tableView.dequeueReusableCell(withIdentifier: "NewsVideoCell", for: indexPath) as! NewsVideoCell
            (cell as! NewsVideoCell).configure(item: news[indexPath.row])

        }
        return cell as! UITableViewCell
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
