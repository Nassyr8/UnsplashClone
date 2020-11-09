//
//  SettingsView.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 8/4/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class SettingsView: UIView {
    
    // MARK: - Public Properties
    
    var upView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 235/255, blue: 240/255, alpha: 0.99)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.transform = CGAffineTransform(rotationAngle: .pi / 4)
        
        return view
    }()
    
    var downView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 235/255, blue: 240/255, alpha: 0.99)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var darkModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark mode"
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    var switchMode: UISwitch = {
        let view = UISwitch()
        view.isOn = ThemeManager.isDarkMode()
        view.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupUIViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .clear
        clipsToBounds = true
        isHidden = true
    }
    
    private func setupUIViews() {
        
        addSubview(upView)
        addSubview(downView)
        
        upView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.size.equalTo(30)
        }
        
        downView.snp.makeConstraints { (make) in
            make.top.equalTo(upView.snp.bottom).offset(-20)
            make.leading.trailing.bottom.equalToSuperview()            
        }
        
        downView.addSubview(darkModeLabel)
        downView.addSubview(switchMode)
        
        darkModeLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        switchMode.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.bottom.trailing.equalToSuperview().offset(-20)
        }
        
    }
    
    @objc func handleSwitchAction(sender: UISwitch) {
        sender.isOn ? ThemeManager.enableDarkMode() : ThemeManager.disableDarkMode()
    }
    
}
