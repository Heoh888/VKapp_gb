//
//  PopAnimator.swift
//  VKapp
//
//  Created by MacBook on 26.12.2021.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        transitionContext.containerView.backgroundColor = UIColor(hex: "#E85E7E")
                
        setAnchorPoint(anchorPoint: CGPoint(x: 0, y: 0), forView: destination.view)
        destination.view.frame = CGRect(x: 0,
                                        y: 0,
                                        width: transitionContext.containerView.frame.height,
                                        height: transitionContext.containerView.frame.width)
//        destination.view.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        setAnchorPoint(anchorPoint: CGPoint(x: 1, y: 0), forView: source.view)
        source.view.frame = transitionContext.containerView.frame
        
        UIView.animate(withDuration: duration,
                       animations: {
//            source.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
            destination.view.transform = .identity
        },
                       completion: { isCompleted in
            if isCompleted && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(isCompleted && !transitionContext.transitionWasCancelled)
            destination.view.isHidden = false
        })
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x,
                               y: view.bounds.size.height * anchorPoint.y)

        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x,
                               y: view.bounds.size.height * view.layer.anchorPoint.y)

        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)

        var position = view.layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
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
