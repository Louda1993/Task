//
//  TaskReusableControllerCategory.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit
import CoreData

class TaskReusableCategoryController: UIViewController {
    let taskReusableCellTypeID = "taskReusableCellType"
    let taskReusableCellEditableID = "taskReusableCellEditable"
    
    var selectedColor = String()
    var categories = [Categories]()
    var editCategory = false
    
    lazy var taskTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskReusableCellType.self, forCellReuseIdentifier: taskReusableCellTypeID)
        tableView.register(TaskReusableCellEditable.self, forCellReuseIdentifier: taskReusableCellEditableID)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    func fetchCategories() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if launchedBefore  {
            let managedContext = appDelegate.persistentContainer.viewContext
            let tasksCategories = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
            categories = try! managedContext.fetch(tasksCategories) as! [Categories]
        } else {
            let names = ["Velmi důležité", "Středně důležité", "Málo důležité", "Nedůležité"]
            let colors = ["Červená", "Zelená", "Modrá", "Hnědá"]
            for i in 0...3 {
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Categories", in: managedContext)!
                let task = NSManagedObject(entity: entity, insertInto: managedContext)
                
                task.setValue(names[i], forKeyPath: "name")
                task.setValue(colors[i], forKeyPath: "color")
                do {
                    try managedContext.save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            fetchCategories()
        }
        taskTable.reloadData()
    }
}

extension TaskReusableCategoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if editCategory == false {
            return categories.count
        } else {
            return categories.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != categories.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskReusableCellTypeID) as! TaskReusableCellType
            cell.descriptionLabel.text = categories[indexPath.row].name
            cell.categoryColor.backgroundColor = getColor(color: categories[indexPath.row].color!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskReusableCellEditableID) as! TaskReusableCellEditable
            cell.descriptionTextField.placeholder = "Zadejte název kategorie"
            cell.descriptionTextField.becomeFirstResponder()
            cell.descriptionTextField.text = ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
