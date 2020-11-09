//
//  ThemedController.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/7/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class ThemedController: UIViewController {
    
    var current = UIStatusBarStyle.default
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return current
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        ThemeManager.addDarkModeObserver(to: self, selector: #selector(handleDarkModeAction))
        handleDarkModeAction()
    }
    
    @objc private func handleDarkModeAction() {
        handleDarkMode(theme: ThemeManager.currentTheme)
    }
    
    func handleDarkMode(theme: Theme) {
        
        view.backgroundColor = theme.backgroundColor
        
        current = ThemeManager.isDarkMode() ? .lightContent : .default
        setNeedsStatusBarAppearanceUpdate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
