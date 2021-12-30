//
//  Animator.swift
//  VKapp
//
//  Created by MacBook on 26.12.2021.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        let containerViewFrame = transitionContext.containerView.frame
        
        let sourceFrame = CGRect(x: -containerViewFrame.width,
                                 y: -containerViewFrame.height,
                                 width: source.view.frame.width,
                                 height: source.view.frame.height)
        
        let destinationFrame  = source.view.frame
        
        destination.view.frame = CGRect(x: containerViewFrame.width,
                                      y: containerViewFrame.height,
                                      width: source.view.frame.width,
                                      height: source.view.frame.height)
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.backgroundColor = .red
        
        UIView.animate(withDuration: duration,
                       animations: {
            source.view.frame = sourceFrame
            destination.view.frame = destinationFrame
        },
                       completion: { isComplited in
            source.removeFromParent()
            transitionContext.completeTransition(isComplited)
        })
        
    }
    
}
