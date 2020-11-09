//
//  EmptyResponseView.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 8/3/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class EmptyResponseView: UIView {

    // MARK: - Public Properties
    
    var responseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        
        return label
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
        
        backgroundColor = .white
    }
    
    private func setupUIViews() {
        
        addSubview(responseTitleLabel)
        responseTitleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}
