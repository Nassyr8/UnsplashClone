//
//  DefaultManager.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/7/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class Defaults {
    
    static let isDarkModeKey = "isDarkMode"
    
    static func getDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: isDarkModeKey)
    }
    
    static func setDarkMode(_ bool: Bool) {
        UserDefaults.standard.set(bool, forKey: isDarkModeKey)
    }
}
