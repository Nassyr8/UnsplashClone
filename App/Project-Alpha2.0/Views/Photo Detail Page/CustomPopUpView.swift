//
//  CustomPopUpView.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 7/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class CustomPopUpView: UIView {
    
    lazy var cameraLabel: UILabel = {
        let cameraLabel = UILabel()
        
        cameraLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cameraLabel.text = "Camera"
        cameraLabel.textColor = .white
        
        return cameraLabel
    }()
    
    lazy var makeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Make \n-"
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var modelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Model \n-"
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var shutterSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Shutter Speed \n-"
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var apertureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Aperture \n-"
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var focalLengthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Focal Length \n-"
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var isoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "ISO \n-"
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var dimensionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Dimensions \n-"
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var hiddenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.isHidden = true
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var publishedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.text = "Published on"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addBlur()
        setupUIViews()        
    }
    
    private func setupUIViews() {
        
        addSubviews([cameraLabel])
        
        cameraLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        let firstRowStackView = createStackView(views: [makeLabel, focalLengthLabel], distribution: .fillEqually, axis: .horizontal, spacing: 0)
        let secondRowStackView = createStackView(views: [modelLabel, isoLabel], distribution: .fillEqually, axis: .horizontal, spacing: 0)
        let thirdRowStackView = createStackView(views: [shutterSpeedLabel, dimensionsLabel], distribution: .fillEqually, axis: .horizontal, spacing: 0)
        let fourthRowStackView = createStackView(views: [apertureLabel, hiddenLabel], distribution: .fillEqually, axis: .horizontal, spacing: 0)
        
        let allRowStackView = createStackView(views: [firstRowStackView, secondRowStackView, thirdRowStackView, fourthRowStackView], distribution: .fillEqually, axis: .vertical, spacing: 20)
        
        addSubview(allRowStackView)
        allRowStackView.snp.makeConstraints { (make) in
            make.top.equalTo(cameraLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(190)
        }
        
        addSubview(publishedLabel)
        publishedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(allRowStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)        
        }
    }
    
    private func addBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    private func createLabels(named: String...) -> [UILabel] {
        return named.map { name in
            let label = UILabel()
            label.textColor = .white
            return label
        }
    }
    
    private func createStackView(views: [UIView], distribution: UIStackView.Distribution, axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.distribution = distribution
        stackView.axis = axis
        stackView.spacing = spacing
        
        return stackView
    }
    
    private func addSubviews(_ view: [UIView] ) {
        for i in view {
            addSubview(i)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
