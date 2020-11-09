//
//  ThemedCell.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/7/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class ThemedCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        ThemeManager.addDarkModeObserver(to: self, selector: #selector(handleDarkModeAction))
        handleDarkModeAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleDarkModeAction() {
        handleDarkMode(theme: ThemeManager.currentTheme)
    }
    
    func handleDarkMode(theme: Theme) {}
    
}
