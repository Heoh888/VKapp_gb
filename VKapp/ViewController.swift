import Foundation
import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var devActiv: Bool = false
    var deviceTyp: String = "iPhone"
    var posIPhoneY: Int = 0
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoResult: UILabel!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
      
    // MARK: - lifeСycle
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceType()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            devActiv = true
            if deviceTyp == "iPhone" {
                scrollView.setContentOffset(CGPoint(x: 0, y: 350), animated: true)
                posIPhoneY = 450;
            }
            if deviceTyp == "iPad" {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                posIPhoneY = 330;
            }
        } else {
            devActiv = false
            if deviceTyp == "iPhone" {
                posIPhoneY = 300;
            }
            if deviceTyp == "iPad" {
                posIPhoneY = 0;
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func loginButton(_ sender: Any) {
        let bounds = button.bounds
        let storyoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyoard.instantiateViewController(identifier: "lowerBar")
        
        if loginInput.text == "admin" && passwordInput.text == "12345" {
            infoResult.textColor = UIColor(hex: "#0C7DE8")
            infoResult.text = "Вы вошли в систему"
            self.present(vc, animated: true, completion: nil)
        } else {
            infoResult.textColor = UIColor(hex: "#E85E7E")
            infoResult.text = "Неверный логин или пароль"
        }
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.15,
                       initialSpringVelocity: 10,
                       options: .transitionCurlDown) {
            self.button.bounds = CGRect(x: bounds.origin.x,
                                        y: bounds.origin.y,
                                        width: bounds.width,
                                        height: bounds.height  + 15)
        }
    }
    
    @IBAction func login(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: 0, y: posIPhoneY), animated: true)
    }
    
    @IBAction func password(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: 0, y: posIPhoneY), animated: true)
    }
    
    @IBAction func tap(_ sender: Any) {
        if deviceTyp == "iPhone" && devActiv == true {
            loginInput.resignFirstResponder()
            passwordInput.resignFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0, y: 350), animated: true)
        } else {
            loginInput.resignFirstResponder()
            passwordInput.resignFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}

// MARK: - Orientation of the device
extension ViewController {
    func deviceType() {
        if UIDevice.current.orientation.isLandscape {
            devActiv = true
            if UIDevice.current.userInterfaceIdiom == .pad {
                deviceTyp = "iPad"
                posIPhoneY = 330;
            } else {
                deviceTyp = "iPhone"
                posIPhoneY = 450;
            }
        } else {
            devActiv = false
            if UIDevice.current.userInterfaceIdiom == .pad {
                deviceTyp = "iPad"
                posIPhoneY = 0;
            } else {
                deviceTyp = "iPhone"
                posIPhoneY = 330;
            }
        }
    }
}

// MARK: - hex: Code
extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    var toHex: String? {
        return toHex()
    }
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
