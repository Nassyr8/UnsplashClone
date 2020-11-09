//
//  ThemeManager.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/7/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

struct ThemeManager {
    static var currentTheme: Theme {
        return isDarkMode() ? .dark : .light
    }
    
    static func isDarkMode() -> Bool {
        return Defaults.getDarkMode()
    }
    
    static func enableDarkMode() {
        Defaults.setDarkMode(true)
        NotificationCenter.default.post(name: .darkModeHasChanged, object: nil)
    }
    
    static func disableDarkMode() {
        Defaults.setDarkMode(false)
        NotificationCenter.default.post(name: .darkModeHasChanged, object: nil)
    }
    
    static func addDarkModeObserver(to observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .darkModeHasChanged, object: nil)
    }
}
