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
    private let refreshControl = UIRefreshControl()
    
    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNews()
        setupTableView()
        AppUtility.lockOrientation(.portrait)
        tableViewNews.register(UINib(nibName: "ImagePostCell", bundle: nil), forCellReuseIdentifier: "ImagePostCell")
        tableViewNews.register(UINib(nibName: "TextPostCell", bundle: nil), forCellReuseIdentifier: "TextPostCell")
        tableViewNews.register(UINib(nibName: "VideoPostCell", bundle: nil), forCellReuseIdentifier: "VideoPostCell")
        tableViewNews.register(UINib(nibName: "ImageRePostCell", bundle: nil), forCellReuseIdentifier: "ImageRePostCell")
        tableViewNews.register(UINib(nibName: "TextRePostCell", bundle: nil), forCellReuseIdentifier: "TextRePostCell")
        tableViewNews.register(UINib(nibName: "VideoRePostCell", bundle: nil), forCellReuseIdentifier: "VideoRePostCell")
        
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
    
    private func setupTableView() {
        tableViewNews.delegate = self
        tableViewNews.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Resreshing...")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableViewNews.refreshControl = refreshControl
    }
    
    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        defer {
            sender.endRefreshing()
        }
        loadNews { [weak self] newPosts in
            guard let self = self else { return }
            self.news = newPosts
            self.tableViewNews.reloadData()
        }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.global().async {
            let procent = Double(indexPath.row) / Double(self.news.count)
            if procent >= 0.8 {
                self.loadNews { [weak self] newPosts in
                    guard let self = self else { return }
                    self.news.append(contentsOf: newPosts)
                    
                    guard !newPosts.isEmpty else { return }
                    
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func loadNews(completion: @escaping ([News]) -> Void) {
        let queue = OperationQueue()
        let request = AF.request(String(describing: getUrl.getUrl(parametrs: .newsfeed)!))
        
        let getDataOperation = GetDataOperation(request: request)
        queue.addOperation(getDataOperation)
        
        let parseData = ParseData()
        parseData.addDependency(getDataOperation)
        parseData.completionBlock = {
            completion(parseData.outputData)
        }
        OperationQueue.main.addOperation(parseData)
    }
}
extension UILabel {
    
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}

