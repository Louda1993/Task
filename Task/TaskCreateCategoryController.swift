//
//  TaskCreateCategoryController.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit

class TaskCreateCategoryController: TaskReusableCategoryController, BarButtonConfigarable {
    weak var delegate: TaskCreateController?
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        setupTaskTable(taskTable: taskTable)
        addBarButtonItem(ofPosition: .left, ofTitle: "Zpět")
        fetchCategories()
    }
    
    func barButtonAction(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = delegate?.taskTable.cellForRow(at: IndexPath(row: 3, section: 0)) as! TaskReusableCellSelectable
        cell.stateLabel.text = categories[indexPath.row].name!
        delegate?.selectedColor = categories[indexPath.row].color!
        delegate?.selectedCategory = categories[indexPath.row].name!
        navigationController?.popViewController(animated: true)
    }
}
