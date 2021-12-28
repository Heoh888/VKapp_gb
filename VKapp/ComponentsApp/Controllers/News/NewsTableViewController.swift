//
//  NewsTableViewController.swift
//  VKapp
//
//  Created by MacBook on 15.12.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var allNews = News()
    
    @IBOutlet var tableViewNews: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewNews.estimatedRowHeight = 7
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
        cell.imagePost.image = allNews.news[indexPath.row].imagePost
        cell.headerPost.layer.cornerRadius = cell.headerPost.frame.height / 2
        cell.likeText.text = String(allNews.news[indexPath.row].like)
        cell.likeBase.layer.cornerRadius = cell.likeBase.frame.height / 2
        if allNews.news[indexPath.row].likeStatus == false {
            cell.like.tintColor = UIColor.gray
        } else {
            cell.like.tintColor = UIColor.red
        }
        cell.commentsText.text = String(allNews.news[indexPath.row].comment.count)
        cell.commentsBase.layer.cornerRadius = cell.commentsBase.frame.height / 2
        cell.rePostText.text = String(allNews.news[indexPath.row].rePost)
        cell.rePostBase.layer.cornerRadius = cell.rePostBase.frame.height / 2
        cell.post.layer.cornerRadius = cell.post.frame.height / 20
        cell.views.text = String(allNews.news[indexPath.row].views)
        cell.shadow.layer.shadowColor = UIColor.gray.cgColor
        cell.shadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.shadow.layer.shadowOpacity = 4
        return cell
    }
    
    @IBAction func likeButton(_ sender:AnyObject) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let index = self.tableView.indexPathForRow(at: buttonPosition)
        if allNews.news[index![1]].likeStatus == false {
            allNews.news[index![1]].like += 1
            allNews.news[index![1]].likeStatus = true
        } else {
            allNews.news[index![1]].like -= 1
            allNews.news[index![1]].likeStatus = false
        }
        tableViewNews.reloadData()
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
