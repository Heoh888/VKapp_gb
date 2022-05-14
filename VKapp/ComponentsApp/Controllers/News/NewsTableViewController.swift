//
//  NewsTableViewController.swift
//  VKapp
//
//  Created by MacBook on 15.12.2021.
//

import UIKit
import Alamofire

enum TypeModel: String {
    case textCell
    case photoCell
    case videoCell
    case noPost
}

class NewsTableViewController: UIViewController {
    
    @IBOutlet var tableViewNews: UITableView!
    
    var news: [News] = []
    var group = DispatchGroup()
    
    private var getUrl = ConfigureUrl()
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
    
    func fetchNews() {
        let queue = OperationQueue()
        let request = AF.request(String(describing: getUrl.getUrlNews()!))
        
        let getDataOperation = GetDataOperation(request: request)
        queue.addOperation(getDataOperation)
        
        let parseData = ParseData()
        parseData.addDependency(getDataOperation)
        parseData.completionBlock = {
            self.news = parseData.outputData
        }
        queue.addOperation(parseData)
        
        let reloadTableController = ReloadTableController(controller: self)
        reloadTableController.addDependency(parseData)
        OperationQueue.main.addOperation(reloadTableController)
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
extension NewsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch parsingModel(model: news[indexPath.row]) {
        case .textCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell") as! NewsTextCell
            cell.itemId = news[indexPath.row].postId!
            cell.ownerId = news[indexPath.row].sourceId!
            cell.type = news[indexPath.row].type!
            cell.configure(model: news, indexPath: indexPath.row)
            return cell
        case .photoCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell") as! NewsPhotoCell
            cell.itemId = news[indexPath.row].postId!
            cell.ownerId = news[indexPath.row].sourceId!
            cell.type = news[indexPath.row].type!
            cell.configure(model: news, indexPath: indexPath.row)
            return cell
        case .videoCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsVideoCell") as! NewsVideoCell
            cell.itemId = news[indexPath.row].postId!
            cell.ownerId = news[indexPath.row].sourceId!
            cell.type = news[indexPath.row].type!
            cell.configure(model: news, indexPath: indexPath.row)
            return cell
        case .noPost:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell") as! NewsTextCell
            cell.textPost.text = "Запись удалина"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyoard.instantiateViewController(identifier: "PostViewController") as! PostViewController
        vc.index = IndexPath(row: indexPath[1], section: 0)
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
