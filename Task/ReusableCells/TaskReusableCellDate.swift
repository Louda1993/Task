//
//  TaskReusableCellDate.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit

class TaskReusableCellDate: UITableViewCell {
    lazy var customDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        addSubview(customDatePicker)
        
        customDatePicker.topAnchor.constraint(equalTo: topAnchor).isActive = true
        customDatePicker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        customDatePicker.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        customDatePicker.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
