//
//  TaskReusableCellEditable.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit

class TaskReusableCellEditable: UITableViewCell {
    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Napište novou připomínku"
        textField.textColor = UIColor.init(red: 81/255, green: 83/255, blue: 102/255, alpha: 1)
        textField.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return textField
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        addSubview(descriptionTextField)
        descriptionTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        descriptionTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




