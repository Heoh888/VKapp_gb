//
//  TestViewController.swift
//  VKapp
//
//  Created by MacBook on 19.02.2022.
//
import WebKit
import UIKit
import FirebaseDatabase

class TestViewController: UIViewController {
    
    let webKit = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webKit)
        guard let url = URL(string: "https://vk.com/video_ext.php?oid=-108477741&id=456251309&hash=6a8a9448cdb54fd2&__ref=vk.api&api_hash=16452327233c2589efb3af01ef3d_GQ4DGNRZGU4TI") else { return }
        webKit.load(URLRequest(url: url))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webKit.frame = view.bounds
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
