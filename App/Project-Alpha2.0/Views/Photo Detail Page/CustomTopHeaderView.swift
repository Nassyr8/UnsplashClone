//
//  CustomTopHeaderView.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/5/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class CustomTopHeaderView: UIView {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.textColor = .white
        
        return titleLabel
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton(frame: .init(x: 0, y: 0, width: 30, height: 30))
        
        backButton.backgroundColor = .orange
        
        return backButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .blue
        
    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        addSubview(backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
