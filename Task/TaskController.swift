//
//  TaskController.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TaskController: UIViewController, BarButtonsConfigarable {
    let taskReusableCellInfoID = "taskReusableCellInfo"
    var selectedSort = UserDefaults.standard.string(forKey: "sorting") ?? "date"
    var selectedOrder = UserDefaults.standard.bool(forKey: "order")
    var tasksUnfinished = [TasksUnfinished]()
    var tasksFinished = [TasksFinished]()
    
    lazy var taskTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskReusableCellInfo.self, forCellReuseIdentifier: taskReusableCellInfoID)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUnfinished()
        fetchFinished()
        setupTaskTable(taskTable: taskTable)
        addBarButtonItems(ofPosition: [.right, .right], ofTitle: ["Nový", "Nastavení"])
    }
    
    func fetchUnfinished() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let tasksUnfFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksUnfinished")
        tasksUnfFetch.sortDescriptors = [NSSortDescriptor.init(key: selectedSort, ascending: selectedOrder)]
        tasksUnfinished = try! managedContext.fetch(tasksUnfFetch) as! [TasksUnfinished]
    }
    
    func fetchFinished() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let tasksFFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksFinished")
        tasksFinished = try! managedContext.fetch(tasksFFetch) as! [TasksFinished]
    }
    
    func secondBarButtonAction(_ sender: AnyObject) {
        let taskSettingsVC = TaskSettingsController()
        let navigationController = UINavigationController(rootViewController: taskSettingsVC)
        taskSettingsVC.delegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func firstBarButtonAction(_ sender: AnyObject) {
        let taskCreateVC = TaskCreateController()
        let navigationController = UINavigationController(rootViewController: taskCreateVC)
        taskCreateVC.delegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func deleteObject(location: IndexPath, entity: String, oldObject: NSManagedObject, identifier: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let tasksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let objects = try! managedContext.fetch(tasksFetch) as! [NSManagedObject]
            for object in objects {
                if object == oldObject {
                    let center = UNUserNotificationCenter.current()
                    center.removePendingNotificationRequests(withIdentifiers: [identifier])
                    managedContext.delete(object)
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
    
    func moveObject(entity: String, name: String, notification: Bool, date: Date, category: String, color: String, identifier: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
        let task = NSManagedObject(entity: entity,insertInto: managedContext)
        task.setValue(name, forKeyPath: "name")
        task.setValue(false, forKeyPath: "notification")
        task.setValue(date, forKeyPath: "date")
        task.setValue(category, forKeyPath: "category")
        task.setValue(color, forKeyPath: "color")
        task.setValue(identifier, forKeyPath: "identifier")
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func moveToFinished(indexPath: IndexPath) {
        self.moveObject(entity: "TasksFinished", name: self.tasksUnfinished[indexPath.row].name!, notification: self.tasksUnfinished[indexPath.row].notification, date: self.tasksUnfinished[indexPath.row].date!, category: self.tasksUnfinished[indexPath.row].category!, color: self.tasksUnfinished[indexPath.row].color!, identifier: self.tasksUnfinished[indexPath.row].identifier!)
        self.fetchFinished()
        self.taskTable.insertRows(at: [IndexPath(row: self.tasksFinished.count - 1, section: 1)], with: .top)
        
        self.deleteObject(location: indexPath, entity: "TasksUnfinished", oldObject: self.tasksUnfinished[indexPath.row], identifier: self.tasksUnfinished[indexPath.row].identifier!)
        self.fetchUnfinished()
        self.taskTable.deleteRows(at: [indexPath], with: .top)
    }
    
    func remove(indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.deleteObject(location: indexPath, entity: "TasksUnfinished", oldObject: self.tasksUnfinished[indexPath.row], identifier: self.tasksUnfinished[indexPath.row].identifier!)
            self.fetchUnfinished()
        } else {
            self.deleteObject(location: indexPath, entity: "TasksFinished", oldObject: self.tasksFinished[indexPath.row], identifier: self.tasksFinished[indexPath.row].identifier!)
            self.fetchFinished()
        }
        self.taskTable.deleteRows(at: [indexPath], with: .top)
    }
}

extension TaskController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let finished = UITableViewRowAction(style: .normal, title: "Dokončené") { action, index in
            self.moveToFinished(indexPath: indexPath)
        }
        finished.backgroundColor = .black
        
        let delete = UITableViewRowAction(style: .normal, title: "Smazat") { action, index in
            self.remove(indexPath: indexPath)
        }
        delete.backgroundColor = .red
        
        if indexPath.section == 0 {
            return [finished, delete]
        } else {
            return [delete]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let taskEditVC = TaskEditController()
        let navigationController = UINavigationController(rootViewController: taskEditVC)
        taskEditVC.delegate = self
        if indexPath.section == 0 {
            taskEditVC.selectedDate = tasksUnfinished[indexPath.row].date!
            taskEditVC.selectedName = tasksUnfinished[indexPath.row].name!
            taskEditVC.selectedNotification = tasksUnfinished[indexPath.row].notification
            taskEditVC.selectedCategory = tasksUnfinished[indexPath.row].category!
            taskEditVC.selectedIdentifier = tasksUnfinished[indexPath.row].identifier!
            taskEditVC.selectedColor = tasksUnfinished[indexPath.row].color!
            taskEditVC.selectedIndexPath = indexPath
        } else {
            taskEditVC.selectedDate = tasksFinished[indexPath.row].date!
            taskEditVC.selectedName = tasksFinished[indexPath.row].name!
            taskEditVC.selectedNotification = tasksFinished[indexPath.row].notification
            taskEditVC.selectedCategory = tasksFinished[indexPath.row].category!
            taskEditVC.selectedColor = tasksFinished[indexPath.row].color!
            taskEditVC.selectedIdentifier = tasksFinished[indexPath.row].identifier!
        }
        taskEditVC.selectedSection = indexPath.section
        present(navigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tasksUnfinished.count
        } else {
            return tasksFinished.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskReusableCellInfoID) as! TaskReusableCellInfo
        
        if indexPath.section == 0 {
            cell.nameLabel.text = tasksUnfinished[indexPath.row].name
            cell.dateLabel.text = covertDate(date: tasksUnfinished[indexPath.row].date!)
            cell.categoryColor.backgroundColor = getColor(color: tasksUnfinished[indexPath.row].color!)
        } else {
            cell.nameLabel.text = tasksFinished[indexPath.row].name
            cell.dateLabel.text = covertDate(date: tasksFinished[indexPath.row].date!)
            cell.categoryColor.backgroundColor = getColor(color: tasksFinished[indexPath.row].color!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Nedokončené"
        } else {
            return "Dokončené"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

