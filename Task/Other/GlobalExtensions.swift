//
//  GlobalExtensions.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self as? UIGestureRecognizerDelegate
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-15.0, 15.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension UIViewController {
    func covertDate(date: Date) -> String {
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM, HH:mm"
        return dateFormatter.string(from: date)
    }
}

extension UIViewController {
    func localNotification(dateComponents : DateComponents, title: String, subTitle: String, identifier: String, completion : @escaping (_ Success : Bool) -> ()){
        let notif = UNMutableNotificationContent()
        notif.title = title
        notif.subtitle = subTitle
        
        let notifTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: notif, trigger: notifTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil{
                print(error!)
                completion(false)
            }else{
                completion(true)
            }
        }
    }
}

extension UIViewController {
    func setupTaskTable(taskTable: UITableView) {
        view.addSubview(taskTable)
        taskTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        taskTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        taskTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        taskTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension UIViewController {
    func getColor(color: String) -> UIColor {
        if color == "Modrá" {
            return .blue
        } else if color == "Zelená" {
            return .green
        } else if color == "Červená" {
            return .red
        } else if color == "Hnědá" {
            return .brown
        } else {
            return .black
        }
    }
    
    func getColorName(color: UIColor) -> String {
        if color == .blue {
            return "Modrá"
        } else if color == .green {
            return "Zelená"
        } else if color == .red {
            return "Červená"
        } else if color == .brown {
            return "Hnědá"
        } else {
            return "Černá"
        }
    }
}
