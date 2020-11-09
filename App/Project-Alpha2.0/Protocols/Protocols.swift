//
//  Protocols.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

protocol UpdateDataDelegate: class {
    func updateData()
}

protocol AuthorVMDelegate: class {
    func setAvatarImage()
}

protocol SearchFromHistoryListDelegate: class {
    func search(query: String)
}

protocol DateConvertable {
    func convertToDate(date: String) -> String
}
