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
        tableViewNews.register(UINib(nibName: "ImagePostCell", bundle: nil), forCellReuseIdentifier: "ImagePostCell")
        tableViewNews.register(UINib(nibName: "TextPostCell", bundle: nil), forCellReuseIdentifier: "TextPostCell")
        tableViewNews.register(UINib(nibName: "VideoPostCell", bundle: nil), forCellReuseIdentifier: "VideoPostCell")
        tableViewNews.register(UINib(nibName: "ImageRePostCell", bundle: nil), forCellReuseIdentifier: "ImageRePostCell")
    }
    
    func fetchNews() {
        let queue = OperationQueue()
        let request = AF.request(String(describing: getUrl.getUrl(parametrs: .newsfeed)!))
        
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
}
extension NewsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentData = news[indexPath.row]
        guard
            let cellIdentifier = currentData.postType?.rawValue,
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        else { return UITableViewCell() }
        
        (cell as? PostCellProtocol)?.set(value: currentData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyoard.instantiateViewController(identifier: "PostViewController") as! PostViewController
        vc.index = IndexPath(row: indexPath[1], section: 0)
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
