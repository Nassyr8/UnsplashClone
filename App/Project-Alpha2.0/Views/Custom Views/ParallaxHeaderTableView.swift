//
//  ParallaxHeaderTableView.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/31/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class ParallaxHeaderTableView: ThemedView {
    
    // MARK: - Public Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos for everyone"
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    var randomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var authorNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        
        return label
    }()

    var settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "icons8-settings"), for: .normal)
        
        return button
    }()
    
    var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search photos"
        search.searchBarStyle = UISearchBar.Style.minimal
        search.autocapitalizationType = .none
        
        return search
    }()
    
    var viewIsHidden = false
    
    // MARK: - Lifecycle
    
    override func handleDarkMode(theme: Theme) {
        backgroundColor = theme.backgroundColor
    }
    
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
        backgroundColor = UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUIViews() {                
        
        addSubview(randomImageView)
        randomImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        searchBar = changeSearchBarStyle(isHidden: false)
        
        addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }                
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(searchBar.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        addSubview(settingsButton)
        settingsButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topPadding + 5)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        addSubview(authorNameLabel)
        authorNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    private func changeSearchBarStyle(isHidden: Bool) -> UISearchBar {
        
        let newSearchBar = self.searchBar
        let textFieldInsideSearchBar = newSearchBar.value(forKey: "searchField") as? UITextField
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        
        if isHidden {
            newSearchBar.tintColor = .black
            newSearchBar.setImage(UIImage(named: "icons8-search-50-gray"), for: .search, state: .normal)
            textFieldInsideSearchBar?.textColor = UIColor.black
            textFieldInsideSearchBarLabel?.textColor = UIColor.gray
        } else {
            newSearchBar.tintColor = .white
            newSearchBar.setImage(UIImage(named: "icons8-search-50-white"), for: .search, state: .normal)
            textFieldInsideSearchBar?.textColor = UIColor.white
            textFieldInsideSearchBarLabel?.textColor = UIColor.white
        }
        
        return newSearchBar
    }
    
    // MARK: - Public Methods
    
    func hideElements() {
        searchBar = changeSearchBarStyle(isHidden: true)
        
        randomImageView.isHidden = true
        titleLabel.isHidden = true
        authorNameLabel.isHidden = true
        settingsButton.isHidden = true
    }
    
    func showElements() {
        searchBar = changeSearchBarStyle(isHidden: false)
        
        randomImageView.isHidden = false
        titleLabel.isHidden = false
        authorNameLabel.isHidden = false
        settingsButton.isHidden = false
    }
    
}
