//
//  TaskSettingsSortController.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit
import UIKit

class TaskSettingsSortController: UIViewController, UITableViewDelegate, UITableViewDataSource, BarButtonConfigarable {
    weak var delegate: TaskSettingsController?
    let taskReusableCellTextID = "taskSortCell"
    var sortArray = ["Podle abecedy", "Podle data"]
    
    lazy var taskTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskReusableCellText.self, forCellReuseIdentifier: taskReusableCellTextID)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        setupTaskTable(taskTable: taskTable)
        addBarButtonItem(ofPosition: .left, ofTitle: "Zpět")
    }
    
    func barButtonAction(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskReusableCellTextID) as! TaskReusableCellText
        
        cell.descriptionLabel.text = sortArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            UserDefaults.standard.set("name", forKey: "sorting")
            UserDefaults.standard.set(true, forKey: "order")
        } else {
            UserDefaults.standard.set("date", forKey: "sorting")
            UserDefaults.standard.set(false, forKey: "order")
        }
        let cell = delegate?.taskTable.cellForRow(at: IndexPath(row: 2, section: 0)) as! TaskReusableCellSelectable
        cell.stateLabel.text = sortArray[indexPath.row]
        navigationController?.popViewController(animated: true)
    }
}



