//
//  NewsTableViewController.swift
//  VKapp
//
//  Created by MacBook on 15.12.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var allNews = News()
    var like = NewsTableViewCell()
    
    var textNews: [String] = []
    var news: [News1] = []
    
    private var service = RequestsServer()
    
    @IBOutlet var tableViewNews: UITableView!
    
    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNews()
        tableViewNews.estimatedRowHeight = 7
        tableViewNews.rowHeight = UITableView.automaticDimension
        tableViewNews.estimatedRowHeight = 229.0
        AppUtility.lockOrientation(.portrait)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        // Предварительно очистим все пространства
        cell.headerSpace.subviews.forEach { $0.removeFromSuperview() }
        cell.textSpace.subviews.forEach { $0.removeFromSuperview() }
        cell.imageSpace.subviews.forEach { $0.removeFromSuperview() }
        tableView.separatorColor = UIColor.clear
        cell.configure(news: news[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyoard.instantiateViewController(identifier: "PostViewController") as! PostViewController
        vc.index = IndexPath(row: indexPath[1], section: 0)
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Actions
    @IBAction func likeButton(_ sender:AnyObject)   {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let index = self.tableView.indexPathForRow(at: buttonPosition)
//        if allNews.news[index![1]].likeStatus == false {
//            allNews.news[index![1]].like += 1
//            allNews.news[index![1]].likeStatus = true
//            allNews.news[index![1]].animation = true
//        } else {
//            allNews.news[index![1]].like -= 1
//            allNews.news[index![1]].likeStatus = false
//        }
        tableView.reloadRows(at: [IndexPath(row: index![1], section: index![0])],
                             with: .automatic)
    }
    
    @IBAction func rePostButton(_ sender: AnyObject) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let index = self.tableView.indexPathForRow(at: buttonPosition)
        let items:[Any] = [allNews.news[index![1]].imagePost]
        allNews.news[index![1]].rePost += 1
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(avc, animated: true, completion: nil)
        tableViewNews.reloadData()
    }
    
}
extension NewsTableViewController {
    func creatingArrayPhotos(arrayNews: [News1]) {
        for item in arrayNews {
            textNews.append(item.text ?? "" )
        }
        DispatchQueue.main.async {
            self.tableViewNews.reloadData()
        }
    }
    
    func fetchNews() {
        service.loadNews{  [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                self.news = news.response.items
                self.creatingArrayPhotos(arrayNews: news.response.items)
            case .failure(_):
                return
            }
        }
        
    }
}

