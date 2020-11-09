//
//  SectionHeaderView.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/31/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class SectionHeaderView: ThemedView {
    
    // MARK: - Public Properties
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .left
        
        return label
    }()
    
    var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.isHidden = true
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func handleDarkMode(theme: Theme) {
        backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.textColor
        clearButton.setTitleColor(theme.textColor, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUIViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUIViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
}
