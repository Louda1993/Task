//
//  TaskSettingsController.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class TaskSettingsController: UIViewController, BarButtonConfigarable, UNUserNotificationCenterDelegate {
    weak var delegate: TaskController?
    let taskReusableCellSwitchID = "taskSettingsCellSwitch"
    let taskReusableCellSelectableID = "taskSettingsCellSelectable"
    
    lazy var taskTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskReusableCellSwitch.self, forCellReuseIdentifier: taskReusableCellSwitchID)
        tableView.register(TaskReusableCellSelectable.self, forCellReuseIdentifier: taskReusableCellSelectableID)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        setupTaskTable(taskTable: taskTable)
        addBarButtonItem(ofPosition: .left, ofTitle: "Hotovo")
    }
    
    func barButtonAction(_ sender: AnyObject) {
        delegate?.selectedSort = UserDefaults.standard.string(forKey: "sorting") ?? "date"
        delegate?.selectedOrder = UserDefaults.standard.bool(forKey: "order")
        delegate?.fetchFinished()
        delegate?.fetchUnfinished()
        delegate?.taskTable.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func switchDidChange(_ sender: UISwitch) {
        if !sender.isOn {
            removeAllNotifications(entity: "TasksFinished")
        }
    }
    
    func removeAllNotifications(entity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var tasksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksFinished")
        do {
            let objects = try! managedContext.fetch(tasksFetch) as! [TasksFinished]
            for object in objects {
                object.setValue(false, forKeyPath: "notification")
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        tasksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksUnfinished")
        do {
            let objects = try! managedContext.fetch(tasksFetch) as! [TasksUnfinished]
            for object in objects {
                object.setValue(false, forKeyPath: "notification")
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        UserDefaults.standard.set(false, forKey: "notifications")
        
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
}

extension TaskSettingsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let taskSettingsCategoryVC = TaskSettingsCategoryController()
            taskSettingsCategoryVC.delegate = self
            navigationController?.pushViewController(taskSettingsCategoryVC, animated: true)
        }
        
        if indexPath.row == 2 {
            let taskSettingsSortVC = TaskSettingsSortController()
            taskSettingsSortVC.delegate = self
            navigationController?.pushViewController(taskSettingsSortVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 || indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskReusableCellSelectableID) as! TaskReusableCellSelectable
            cell.accessoryType = .disclosureIndicator
            if indexPath.row == 1 {
                cell.descriptionLabel.text = "Kategorie"
            }
            
            if indexPath.row == 2 {
                cell.descriptionLabel.text = "Řazení"
                let current = UserDefaults.standard.string(forKey: "sorting") ?? "date"
                if current == "name" {
                    cell.stateLabel.text = "Podle abecedy"
                } else {
                    cell.stateLabel.text = "Podle data"
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskReusableCellSwitchID) as! TaskReusableCellSwitch
            
            cell.selectionStyle = .none
            cell.notificationSwitch.isOn = UserDefaults.standard.bool(forKey: "notifications")
            cell.notificationSwitch.isEnabled = UserDefaults.standard.bool(forKey: "notifications")
            cell.notificationSwitch.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
            return cell
        }
    }
}
