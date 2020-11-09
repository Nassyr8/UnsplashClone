//
//  CustomHeaderView.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/1/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {
    
    let locationIcon = UIImageView()
    let browserIcon = UIImageView()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.textColor = .white
        
        return nameLabel
    }()
    
    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        
        locationLabel.font = UIFont.systemFont(ofSize: 15)
        locationLabel.textColor = .gray
        
        return locationLabel
    }()
    
    lazy var urlLabel: UILabel = {
        let urlLabel = UILabel()
        
        urlLabel.font = UIFont.systemFont(ofSize: 15)
        urlLabel.textColor = .gray
        
        return urlLabel
    }()
    
    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 30
        
        return avatarImageView
    }()
    
    lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView()
        
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        
        return headerImageView
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton()
        
        let origImage = UIImage(named: "close")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = .white
        
        return backButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeaderImageView()
        setupLabels()
        setupAvatarImageView()
        setupButton()
    }
    
    private func setupHeaderImageView() {
        addSubview(headerImageView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = headerImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerImageView.addSubview(blurEffectView)
        
        headerImageView.snp.makeConstraints { (make) in
            make.bottom.trailing.leading.equalToSuperview()
            make.height.equalTo(230)
        }
    }
    
    private func setupAvatarImageView() {
        headerImageView.addSubview(avatarImageView)
        
        avatarImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(nameLabel.snp.top).offset(-10)
            make.width.height.equalTo(60)
        }
    }
    
    private func setupLabels() {
        headerImageView.addSubview(nameLabel)
        headerImageView.addSubview(locationLabel)
        headerImageView.addSubview(urlLabel)
        
        urlLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(urlLabel.snp.top).offset(-5)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(locationLabel.snp.top).offset(-5)
        }
        
    }
    
    private func setupButton() {
        addSubview(backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    func setupLocationIcon() {
        headerImageView.addSubview(locationIcon)
        
        locationIcon.image = UIImage(named: "location_icon")
        locationIcon.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(locationLabel.snp.leading).offset(-4)
            make.bottom.equalTo(urlLabel.snp.top).offset(-8)
            make.size.equalTo(12)
        }
    }
    
    func setupBrowserIcon() {
        headerImageView.addSubview(browserIcon)

        browserIcon.image = UIImage(named: "url_icon")
        browserIcon.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(urlLabel.snp.leading).offset(-4)
            make.bottom.equalToSuperview().offset(-18)
            make.size.equalTo(12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
