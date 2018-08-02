//
//  TaskCreateController.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TaskCreateController: TaskReusableControllerDetail, BarButtonsConfigarable {
    weak var delegate: TaskController?
    
    override func viewDidLoad() {
        setupMain()
        addBarButtonItems(ofPosition: [.left, .right], ofTitle: ["Zrušit", "Přidat"])
    }
    
    func firstBarButtonAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func secondBarButtonAction(_ sender: AnyObject) {
        createTask()
    }
    
    func createTask() {
        let cellName = taskTable.cellForRow(at: IndexPath(row: 0, section: 0)) as! TaskReusableCellEditable
        let cellNotification = taskTable.cellForRow(at: IndexPath(row: 1, section: 0)) as! TaskReusableCellSwitch
        let cellDate = taskTable.cellForRow(at: IndexPath(row: 2, section: 0)) as! TaskReusableCellDate
        
        let name = cellName.descriptionTextField.text!
        let notificationState = cellNotification.notificationSwitch.isOn
        let randomString = NSUUID().uuidString
        selectedDate = cellDate.customDatePicker.date
        
        guard !name.isEmpty else {
            cellName.shake()
            return
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        let newDate = calendar.date(byAdding: .minute, value: 2, to: currentDate)
        
        if notificationState {
            guard cellDate.customDatePicker.date > currentDate else {
                cellDate.customDatePicker.date = newDate!
                return
            }
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TasksUnfinished", in: managedContext)!
        let task = NSManagedObject(entity: entity,insertInto: managedContext)
        task.setValue(name, forKeyPath: "name")
        task.setValue(notificationState, forKeyPath: "notification")
        task.setValue(selectedDate, forKeyPath: "date")
        task.setValue(selectedCategory, forKeyPath: "category")
        task.setValue(selectedColor, forKeyPath: "color")
        task.setValue(randomString, forKeyPath: "identifier")
        do {
            try managedContext.save()
            if notificationState {
                let unitFlags = Set<Calendar.Component>([.hour, .minute, .day, .month, .second])
                var calendar = Calendar.current
                calendar.timeZone = .current
                let components = calendar.dateComponents(unitFlags, from: selectedDate)
                
                localNotification(dateComponents: components, title: "Připomínka", subTitle: name, identifier: randomString) { (true) in
                    print("Notifikace nastavena na: \(components)")
                    UserDefaults.standard.set(true, forKey: "notifications")
                }
            }
            
            delegate?.fetchFinished()
            delegate?.fetchUnfinished()
            delegate?.taskTable.reloadData()
            dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 3 {
            let taskCreateCategoryVC = TaskCreateCategoryController()
            taskCreateCategoryVC.delegate = self
            navigationController?.pushViewController(taskCreateCategoryVC, animated: true)
        }
    }
}
