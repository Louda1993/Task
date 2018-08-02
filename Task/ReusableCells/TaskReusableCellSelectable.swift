//
//  TaskReusableCellSelectable.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit

class TaskReusableCellSelectable: UITableViewCell {
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.init(red: 81/255, green: 83/255, blue: 102/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.init(red: 81/255, green: 83/255, blue: 102/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        addSubview(descriptionLabel)
        addSubview(stateLabel)
        
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        stateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stateLabel.leftAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.rightAnchor, constant: 8).isActive = true
        stateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
