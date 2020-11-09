//
//  SearchView.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 8/1/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class SearchView: ThemedView {

    // MARK: - Public Properties
        
    weak var searchFromHistoryListDelegate: SearchFromHistoryListDelegate?
    
    // MARK: - Private Properties
    
    private var tableView = ThemedTable()
    private var customReuseIdentifier = "customReuseIdentifier"
    private var searchVM = SearchVM()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupUIViews()
        connectSearchVM()
    }
    
    override func handleDarkMode(theme: Theme) {
        backgroundColor = theme.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        isHidden = true
    }
    
    private func setupUIViews() {
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: customReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func connectSearchVM() {
        searchVM.updateDataDelegate = self
    }
    
    // MARK: - Public Methods
    
    func fetchSearchHistoryData() {
        
        searchVM.getSearchHistory()
    }
    
    // MARK: - Selector Actions
    
    @objc private func clearButtonPressed() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Clear Recent Searches", style: .destructive, handler: { (_) in
            self.searchVM.deleteAllHistory()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
}

// MARK: Implementing TableView DataSourceDelegate Protocol

extension SearchView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchVM.getCountOfData() > 0 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchVM.getCountOfData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customReuseIdentifier, for: indexPath)
        cell.textLabel?.text = searchVM.getDataOfArray(at: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Recent"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = SectionHeaderView()
        headerView.titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.clearButton.isHidden = false
        headerView.clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        
        return headerView
    }
    
}

// MARK: - Implementing TableViewDelegate Protocol

extension SearchView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchFromHistoryListDelegate?.search(query: searchVM.getDataOfArray(at: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Implementing UpdateDataDelegate Protocol

extension SearchView: UpdateDataDelegate {
    
    func updateData() {
        tableView.reloadData()
    }
    
}
