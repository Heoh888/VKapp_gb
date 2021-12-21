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
    
    @IBOutlet var tableViewNews: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewNews.estimatedRowHeight = 7
        tableViewNews.rowHeight = UITableView.automaticDimension
        tableViewNews.estimatedRowHeight = 229.0
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNews.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        tableView.separatorColor = UIColor.clear
        cell.userName.text = allNews.news[indexPath.row].nameUser
        cell.imageAvatar.image = allNews.news[indexPath.row].imageAvatar
        cell.imageAvatar.layer.cornerRadius = cell.imageAvatar.frame.height / 2
        cell.textPost.text = allNews.news[indexPath.row].textPost
        cell.imagePost.image = allNews.news[indexPath.row].imagePost
        cell.headerPost.layer.cornerRadius = cell.headerPost.frame.height / 2
        cell.likeText.text = String(allNews.news[indexPath.row].like)
        cell.likeBase.layer.cornerRadius = cell.likeBase.frame.height / 2
        if allNews.news[indexPath.row].likeStatus == false {
            cell.like.tintColor = UIColor.gray
        } else {
            cell.like.tintColor = UIColor.red
            if allNews.news[indexPath.row].animation == true {
                liked(sender: cell.like)
                allNews.news[indexPath.row].animation = false
            }
        }
        cell.commentsText.text = String(allNews.news[indexPath.row].comment.count)
        cell.commentsBase.layer.cornerRadius = cell.commentsBase.frame.height / 2
        cell.rePostText.text = String(allNews.news[indexPath.row].rePost)
        cell.rePostBase.layer.cornerRadius = cell.rePostBase.frame.height / 2
        cell.post.layer.cornerRadius = cell.post.frame.width / 20
        cell.views.text = String(allNews.news[indexPath.row].views)
        cell.shadow.layer.shadowColor = UIColor.gray.cgColor
        cell.shadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.shadow.layer.shadowOpacity = 4
        return cell
    }
    
    @IBAction func likeButton(_ sender:AnyObject)   {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let index = self.tableView.indexPathForRow(at: buttonPosition)
        if allNews.news[index![1]].likeStatus == false {
            allNews.news[index![1]].like += 1
            allNews.news[index![1]].likeStatus = true
            allNews.news[index![1]].animation = true
        } else {
            allNews.news[index![1]].like -= 1
            allNews.news[index![1]].likeStatus = false
        }
        tableViewNews.reloadData()
    }
    
    public func liked(sender:AnyObject)  {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = .init(name: .easeInEaseOut)
        animation.mass = 2
        animation.stiffness = 400
        sender.layer.add(animation, forKey: nil)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyoard.instantiateViewController(identifier: "PostViewController") as! PostViewController
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
