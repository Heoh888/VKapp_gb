//
//  PostViewController.swift
//  VKapp
//
//  Created by MacBook on 17.12.2021.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var postHeight: NSLayoutConstraint!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var shadowImage: UIView!
    
    @IBOutlet weak var buttomComment: UIButton!
    
    @IBOutlet weak var viewComment: UIView!
    
    
    
//     TODO: Переделать
//
    var commentState: Bool = false
    var index = IndexPath(item: 0, section: 0)
    let width:CGFloat = 314

    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        initialiSetup()
        AppUtility.lockOrientation(.portrait)
    }

    // MARK: - Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                self.tableViewHeight.constant = newSize.height
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func getLableHeightRuntime() -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = postText.text!.boundingRect(with: constraintRect,
                                                      options: .usesLineFragmentOrigin,
                                                      attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: 15)!],
                                                      context: nil)
        return ceil(boundingBox.height)
    }

    // MARK: - Private functions
    private func initialiSetup() {
        shadowImage.layer.shadowColor = UIColor.gray.cgColor
        shadowImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowImage.layer.shadowOpacity = 4
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard)))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        self.postHeight.constant =  getLableHeightRuntime() + 280
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

    // MARK: - Actions
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
}

// MARK: - Table view data source
extension PostViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.textComment.text = "Первый!"
        return cell
    }

}

// MARK: - extension UILabel
extension UILabel{
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}
