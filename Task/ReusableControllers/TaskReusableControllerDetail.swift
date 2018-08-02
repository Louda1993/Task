//
//  TaskReusableControllerDetail.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class TaskReusableControllerDetail: UIViewController {
    let taskReusableCellIDEditable = "taskReusableCellEditable"
    let taskReusableCellIDSwitch = "taskReusableCellSwitch"
    let taskReusableCellIDSelectable = "taskReusableCellSelectable"
    let taskReusableCellIDDate = "taskReusableCellDate"
    
    var selectedName = String()
    var selectedNotificationState = Bool()
    var selectedDate = Date()
    var selectedCategory = String("Velmi důležité")
    var selectedColor = String("Červená")
    var selectedNotification = Bool()
    var selectedIdentifier = String()
    var selectedSection = Int()
    var selectedIndexPath = IndexPath()
    
    lazy var taskTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskReusableCellEditable.self, forCellReuseIdentifier: taskReusableCellIDEditable)
        tableView.register(TaskReusableCellSwitch.self, forCellReuseIdentifier: taskReusableCellIDSwitch)
        tableView.register(TaskReusableCellSelectable.self, forCellReuseIdentifier: taskReusableCellIDSelectable)
        tableView.register(TaskReusableCellDate.self, forCellReuseIdentifier: taskReusableCellIDDate)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    func setupMain() {
        hideKeyboardWhenTappedAround()
        setupTaskTable(taskTable: taskTable)
    }
    
    @objc func switchDidChange(_ sender: UISwitch) {
        selectedNotification = sender.isOn
    }
}

extension TaskReusableControllerDetail: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 200
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskReusableCellIDEditable) as! TaskReusableCellEditable
            cell.descriptionTextField.text = selectedName
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskReusableCellIDSwitch) as! TaskReusableCellSwitch
            cell.descriptionLabel.text = "Připomenout v daný den"
            cell.selectionStyle = .none
            cell.notificationSwitch.isOn = selectedNotification
            cell.notificationSwitch.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskReusableCellIDDate) as! TaskReusableCellDate
            cell.customDatePicker.date = selectedDate
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskReusableCellIDSelectable) as! TaskReusableCellSelectable
            cell.descriptionLabel.text = "Kategorie"
            cell.stateLabel.text = selectedCategory
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}
