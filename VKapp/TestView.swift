//
//  TestView.swift
//  VKapp
//
//  Created by MacBook on 08.12.2021.
//

import UIKit

class TestView: UIView {

/* Покрасить
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(UIColor.orange.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 50, height: 50))
    }
*/
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(UIColor.orange.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 50, height: 50))
    }

}
