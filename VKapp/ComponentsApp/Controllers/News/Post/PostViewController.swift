//
//  PostViewController.swift
//  VKapp
//
//  Created by MacBook on 17.12.2021.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var comment: UIView!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var buttomComment: UIButton!
    
    var comments = News()
    
    var commentState: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        initialiSetup()
    }
    
    private func initialiSetup() {
        comment.layer.cornerRadius = comment.frame.width /  20
        buttomComment.layer.cornerRadius = buttomComment.frame.height / 2
        comment.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func commentButton(_ sender: Any) {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = .init(name: .easeInEaseOut)
        animation.mass = 1
        animation.stiffness = 400
        buttomComment.layer.add(animation, forKey: nil)
        self.view.frame.origin.y = 0
        commentState = false
        self.view.endEditing(true)
    }
    
    @objc private func hideKeyBoard() {
        self.view.endEditing(true)
        
    }
     
    @objc private func keyboardWillShow(notification: NSNotification) {
        if commentState == false {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.view.frame.origin.y -= keyboardHeight - self.viewComment.frame.height * 2
            }
        }
        commentState = true
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        commentState = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}
extension PostViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.news[0].comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.textComment.text = comments.news[0].comment[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
