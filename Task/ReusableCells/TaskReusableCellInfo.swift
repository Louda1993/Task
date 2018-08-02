//
//  TaskCell.swift
//  Task
//
//  Created by Jakub Louda on 02.08.18.
//  Copyright © 2018 Jakub Louda. All rights reserved.
//

import UIKit

class TaskReusableCellInfo: UITableViewCell {
    let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Název"
        label.numberOfLines = 1
        label.textColor = UIColor.init(red: 81/255, green: 83/255, blue: 102/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Datum"
        label.numberOfLines = 1
        label.textColor = UIColor.init(red: 136/255, green: 141/255, blue: 168/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    let categoryColor: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        addSubview(infoView)
        infoView.addSubview(nameLabel)
        infoView.addSubview(dateLabel)
        addSubview(categoryColor)
        
        infoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        infoView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 0).isActive = true
        nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 0).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: 0).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 0).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: 0).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 0).isActive = true
        
        categoryColor.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        categoryColor.leftAnchor.constraint(greaterThanOrEqualTo: infoView.rightAnchor, constant: 8).isActive = true
        categoryColor.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        categoryColor.widthAnchor.constraint(equalToConstant: 20).isActive = true
        categoryColor.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



