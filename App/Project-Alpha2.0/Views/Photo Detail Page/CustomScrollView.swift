//
//  CustomScrollView.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/4/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class CustomScrollView: UIScrollView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .center
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
