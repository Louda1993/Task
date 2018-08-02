//
//  NavigationBar.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit

enum BarButtonItemPosition {
    case right, left
}

protocol BarButtonItemConfiguration: class {
    func addBarButtonItem(ofPosition position: BarButtonItemPosition, ofTitle title: String)
}

@objc protocol BarButtonAction {
    @objc func barButtonAction(_ sender:AnyObject)
}

extension BarButtonConfigarable where Self: UIViewController, Self: BarButtonAction {
    func addBarButtonItem(ofPosition position: BarButtonItemPosition, ofTitle title: String) {
        let button = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(Self.barButtonAction(_:)))
        switch position {
        case .left: self.navigationItem.setLeftBarButton(button, animated: true)
        case .right: self.navigationItem.setLeftBarButton(button, animated: true)
        }
    }
}

protocol BarButtonConfigarable: BarButtonItemConfiguration, BarButtonAction {}

protocol BarButtonsItemConfiguration: class {
    func addBarButtonItems(ofPosition position: [BarButtonItemPosition], ofTitle title: [String])
}

@objc protocol BarButtonActions {
    @objc func firstBarButtonAction(_ sender:AnyObject)
    @objc func secondBarButtonAction(_ sender:AnyObject)
}

extension BarButtonsConfigarable where Self: UIViewController, Self: BarButtonActions {
    func addBarButtonItems(ofPosition position: [BarButtonItemPosition], ofTitle title: [String]) {
        let firstButton = UIBarButtonItem(title: title[0], style: .done, target: self, action: #selector(Self.firstBarButtonAction(_:)))
        
        let secondButton = UIBarButtonItem(title: title[1], style: .done, target: self, action: #selector(Self.secondBarButtonAction(_:)))
        
        if position[0] == position[1] {
            if position[0] == .left {
                self.navigationItem.leftBarButtonItems = [firstButton, secondButton]
            } else {
                self.navigationItem.rightBarButtonItems = [firstButton, secondButton]
            }
        } else {
            switch position[0] {
            case .left: self.navigationItem.leftBarButtonItem = firstButton
            case .right: self.navigationItem.rightBarButtonItem = firstButton
            }
            
            switch position[1] {
            case .left: self.navigationItem.leftBarButtonItem = secondButton
            case .right: self.navigationItem.rightBarButtonItem = secondButton
            }
        }
    }
}

protocol BarButtonsConfigarable: BarButtonsItemConfiguration, BarButtonActions {}

