//
//  CustomTableCellForPhotos.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class CustomTableCellForPhotos: ThemedCell {
    
    // MARK: - Public Properties
    
    var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray        
        
        return imageView
    }()
    
    var usernameButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Loading...", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    static let customTableCellForPhotosReuseIdentifier = "customTableCellForPhotosReuseIdentifier"
    
    // MARK: - Lifecycle
    
    override func handleDarkMode(theme: Theme) {
        backgroundColor = theme.backgroundColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUIViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUIViews() {
        addSubview(mainImageView)
        addSubview(usernameButton)
        
        mainImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        usernameButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(frame.width - 20)
        }
        
    }
    
    // MARK: - Public Methods
    
    func configureCell(with photo: Photo?) {
        if let photo = photo {
            mainImageView.image = nil
            usernameButton.setTitle(nil, for: .normal)
            
            mainImageView.backgroundColor = UIColor.init(hex: photo.color)
            
            if let url = URL(string: photo.urls.regular) {
                mainImageView.af_setImage(withURL: url) { (result) in
                    guard let image = result.value else { return }
                    ImageCacheManager.shared.addImage(image: image, with: photo.urls.regular)
                }
            }
            
            var buttonTitle = photo.user.name
            if photo.sponsorship.id != "" {
                if photo.sponsorship.name != "" {
                    if photo.sponsorship.name != photo.user.name {
                        buttonTitle = buttonTitle + " \n" + "Sponsored by" + " " + photo.sponsorship.name
                    } else {
                        buttonTitle = buttonTitle + " \n" + "Sponsored"
                    }
                }
            }
            
            usernameButton.setTitle(buttonTitle, for: .normal)                        
        }
    }
    
    
}
