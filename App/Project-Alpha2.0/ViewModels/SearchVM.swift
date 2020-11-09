//
//  SearchVM.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 8/3/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class SearchVM {
    
    // MARK: - Public Properties
    
    var searchHistoryList: [String] = []
    weak var updateDataDelegate: UpdateDataDelegate?
    
    // MARK: - Public Methods
    
    func getCountOfData() -> Int {
        
        return searchHistoryList.count
    }
    
    func getDataOfArray(at index: Int) -> String {
        
        return searchHistoryList[index]
    }
    
    func getSearchHistory() {
        if let array = UserDefaults.standard.value(forKey: "historyOfSearch") as? [String] {
            searchHistoryList = array
            updateDataDelegate?.updateData()
        }
    }
    
    func deleteAllHistory() {
        UserDefaults.standard.removeObject(forKey: "historyOfSearch")
        searchHistoryList.removeAll()
        updateDataDelegate?.updateData()
    }
    
}
