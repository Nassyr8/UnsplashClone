//
//  ThemedNavigation.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/7/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class ThemedNavigation: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        ThemeManager.addDarkModeObserver(to: self, selector: #selector(handleDarkModeAction))
        handleDarkModeAction()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @objc private func handleDarkModeAction() {
        handleDarkMode(theme: ThemeManager.currentTheme)
    }
    
    func handleDarkMode(theme: Theme) {
        
        navigationBar.barTintColor = theme.backgroundColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
        navigationController?.navigationBar.tintColor = theme.textColor
        navigationBar.tintColor = theme.textColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
