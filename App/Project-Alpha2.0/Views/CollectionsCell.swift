//
//  CollectionsCell.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class CollectionsCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var titleName: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    static let collectionsCustomReuseIdentifier = "collectionsCustomReuseIdentifier"
    
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
        backgroundColor = .gray
        layer.masksToBounds = true
        layer.cornerRadius = 15
    }
    
    private func setupUIViews() {
        addSubview(titleImageView)
        addSubview(titleName)
        
        titleImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleName.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
    }
    
}
