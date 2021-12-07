import Foundation
import UIKit

struct User {
    var image:UIImage
    var name:String
}

class PulUsers {
    
    var users = [User]()
    
    init() {
        setup()
    }
    
    func setup(){
        let p1 = User(image: UIImage(named: "TheСat")!, name: "Тот самый кот")
        let p2 = User(image: UIImage(named: "President")!, name: "Самый главный")
        let p3 = User(image: UIImage(named: "Mr.Propit")!, name: "Mr.Propit")
        self.users = [p1,p2,p3]
    }
}
