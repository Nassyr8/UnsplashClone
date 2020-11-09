//
//  CustomSectionHeaderView.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/1/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class CustomSectionHeaderView: ThemedView {
    
    private let items = ["Photos" , "Likes", "Collections"]
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: items)
        
        return segmentedControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSegmentedControl()
    }
    
    override func handleDarkMode(theme: Theme) {
        backgroundColor = theme.backgroundColor
        segmentedControl.backgroundColor = theme.backgroundColor
        segmentedControl.tintColor = theme.textColor
    }
    
    private func setupSegmentedControl() {
        
        segmentedControl.layer.cornerRadius = 5.0
        
        addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
