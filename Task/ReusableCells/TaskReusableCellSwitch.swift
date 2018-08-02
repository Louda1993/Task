//
//  TaskReusableCellSwitch.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit

class TaskReusableCellSwitch: UITableViewCell {
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vypnout všechny notifikace"
        label.numberOfLines = 1
        label.textColor = UIColor.init(red: 81/255, green: 83/255, blue: 102/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let notificationSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.setOn(false, animated: false)
        return switchButton
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        addSubview(descriptionLabel)
        addSubview(notificationSwitch)
        
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
        notificationSwitch.leftAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.rightAnchor, constant: 16).isActive = true
        notificationSwitch.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        notificationSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


