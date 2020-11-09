//
//  ThemedTable.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/7/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class ThemedTable: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        ThemeManager.addDarkModeObserver(to: self, selector: #selector(handleDarkModeAction))
        handleDarkModeAction()
        
    }
    
    @objc private func handleDarkModeAction() {
        handleDarkMode(theme: ThemeManager.currentTheme)
    }
    
    func handleDarkMode(theme: Theme) {
        backgroundColor = theme.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
