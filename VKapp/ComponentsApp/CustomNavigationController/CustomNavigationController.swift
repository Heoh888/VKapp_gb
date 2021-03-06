//
//  CustomNavigationController.swift
//  VKapp
//
//  Created by MacBook on 26.12.2021.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    private let interactiveTransition = InteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}
extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.isStarted ? interactiveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            if navigationController.viewControllers.first != toVC {
                interactiveTransition.viewController = toVC
            }
            return PopAnimator()
        case .push:
            interactiveTransition.viewController = toVC
            return PushAnimator()
        default:
            return nil
        }
    }
}
