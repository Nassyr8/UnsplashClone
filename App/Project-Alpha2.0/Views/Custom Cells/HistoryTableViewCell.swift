//
//  HistoryTableViewCell.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/7/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class HistoryTableViewCell: ThemedCell {
    
    override func handleDarkMode(theme: Theme) {
        textLabel?.textColor = theme.textColor
        backgroundColor = theme.backgroundColor
    }
    
}
