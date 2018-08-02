//
//  TaskSettingsCategoryController.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit
import CoreData

class TaskSettingsCategoryController: TaskReusableCategoryController, BarButtonsConfigarable {
    weak var delegate: TaskSettingsController?
    var colorsArray:[UIColor] = [.red, .green, .blue, .brown, .black]
    var buttonsArray = [UIBarButtonItem]()
    
    override func viewDidLoad() {
        taskTable.allowsSelection = false
        hideKeyboardWhenTappedAround()
        setupTaskTable(taskTable: taskTable)
        fetchCategories()
        addBarButtonItems(ofPosition: [.left, .right], ofTitle: ["Zpět", "Přidat kategorii"])
    }
    
    func firstBarButtonAction(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    func secondBarButtonAction(_ sender: AnyObject) {
        editCategory = true
        taskTable.insertRows(at: [IndexPath(row: categories.count, section: 0)], with: .top)
        addColorItems()
    }
    
    func addColorItems() {
        for i in 0...4 {
            let categoryColor = UIButton()
            categoryColor.backgroundColor = colorsArray[i]
            categoryColor.layer.cornerRadius = 15
            categoryColor.layer.borderWidth = 2
            categoryColor.layer.borderColor = colorsArray[i].cgColor
            categoryColor.heightAnchor.constraint(equalToConstant: 30).isActive = true
            categoryColor.widthAnchor.constraint(equalToConstant: 30).isActive = true
            categoryColor.tag = i
            categoryColor.addTarget(self, action: #selector(chooseColor), for: .touchUpInside)
            
            let colorCircle = UIBarButtonItem(customView: categoryColor)
            buttonsArray.append(colorCircle)
        }
        navigationItem.rightBarButtonItems = buttonsArray
    }
    
    @objc func chooseColor(_ button: UIButton) {
        selectedColor = getColorName(color: colorsArray[button.tag])
        
        let addBarButtonItem = UIBarButtonItem(title: "Přidat", style: .done, target: self, action: #selector(add))
        let againBarButtonItem = UIBarButtonItem(title: "Znovu", style: .done, target: self, action: #selector(again))
        
        navigationItem.rightBarButtonItems = nil
        navigationItem.rightBarButtonItems = [addBarButtonItem, againBarButtonItem]
    }
    
    @objc func add() {
        let cellName = taskTable.cellForRow(at: IndexPath(row: categories.count, section: 0)) as! TaskReusableCellEditable
        let name = cellName.descriptionTextField.text!
        
        guard !name.isEmpty else {
            cellName.shake()
            return
        }
        
        buttonsArray.removeAll()
        editCategory = false
        navigationItem.rightBarButtonItems = nil
        addBarButtonItems(ofPosition: [.left, .right], ofTitle: ["Zpět", "Přidat kategorii"])
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Categories", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        task.setValue(name, forKeyPath: "name")
        task.setValue(selectedColor, forKeyPath: "color")
        
        do {
            try managedContext.save()
            fetchCategories()
            cellName.resignFirstResponder()
            taskTable.reloadData()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @objc func again() {
        buttonsArray.removeAll()
        addColorItems()
    }
}

