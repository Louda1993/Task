//
//  TaskEditController.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class TaskEditController: TaskReusableControllerDetail, BarButtonsConfigarable, BarButtonConfigarable {
    weak var delegate: TaskController?
    
    override func viewDidLoad() {
        setupMain()
        if !selectedIndexPath.isEmpty {
            addBarButtonItems(ofPosition: [.right, .right], ofTitle: ["Uložit", "Dokončené"])
        }
        addBarButtonItem(ofPosition: .left, ofTitle: "Zrušit")
    }
    
    func edit() {
        let cellName = taskTable.cellForRow(at: IndexPath(row: 0, section: 0)) as! TaskReusableCellEditable
        let cellNotification = taskTable.cellForRow(at: IndexPath(row: 1, section: 0)) as! TaskReusableCellSwitch
        let cellDate = taskTable.cellForRow(at: IndexPath(row: 2, section: 0)) as! TaskReusableCellDate
       
        selectedName = cellName.descriptionTextField.text!
        selectedNotification = cellNotification.notificationSwitch.isOn
        selectedDate = cellDate.customDatePicker.date
        
        guard !selectedName.isEmpty else {
            cellName.shake()
            return
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        let newDate = calendar.date(byAdding: .minute, value: 2, to: currentDate)
        
        if selectedNotification {
            guard cellDate.customDatePicker.date > currentDate else {
                cellDate.customDatePicker.date = newDate!
                return
            }
        }
        
        if selectedNotification {
            let unitFlags = Set<Calendar.Component>([.hour, .minute, .day, .month, .second])
            var calendar = Calendar.current
            calendar.timeZone = .current
            let components = calendar.dateComponents(unitFlags, from: selectedDate)
            localNotification(dateComponents: components, title: "Připomínka", subTitle: selectedName, identifier: selectedIdentifier) { (true) in
                UserDefaults.standard.set(true, forKey: "notifications")
                print("Notifikace nastavena na: \(components)")
            }
        } else {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [selectedIdentifier])
        }
        
        editTask(entity: "TasksUnfinished")
        delegate?.fetchFinished()
        delegate?.fetchUnfinished()
        delegate?.taskTable.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func barButtonAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func firstBarButtonAction(_ sender: AnyObject) {
        edit()
    }
    
    func secondBarButtonAction(_ sender: AnyObject) {
        delegate?.moveToFinished(indexPath: selectedIndexPath)
        delegate?.fetchUnfinished()
        delegate?.fetchFinished()
        delegate?.taskTable.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 3 {
            let taskEditCategoryVC = TaskEditCategoryController()
            taskEditCategoryVC.delegate = self
            navigationController?.pushViewController(taskEditCategoryVC, animated: true)
        }
    }
    
    func editTask(entity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let tasksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let objects = try! managedContext.fetch(tasksFetch) as! [TasksUnfinished]
            for object in objects {
                if object.identifier == selectedIdentifier {
                    object.name = selectedName
                    object.notification = selectedNotification
                    object.date = selectedDate
                    object.category = selectedCategory
                    object.color = selectedColor
                }
                
                if objects.count == 1 {
                    UserDefaults.standard.set(false, forKey: "notifications")
                }
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
