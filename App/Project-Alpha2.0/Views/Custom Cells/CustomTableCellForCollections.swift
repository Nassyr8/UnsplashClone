//
//  CustomTableCellForCollections.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class CustomTableCellForCollections: ThemedCell {
    
    // MARK: - Public Properties
    
    var collectionView: UICollectionView?
    var collections = [Collection]()
    var mainPageVM = MainPageVM()
    static let customTableCellReuseIdentifier = "customTableCellReuseIdentifier"
    weak var navigationController: UINavigationController?
    let layout = UICollectionViewFlowLayout()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUIViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    override func handleDarkMode(theme: Theme) {
        backgroundColor = theme.backgroundColor
    }
    
    private func setupUIViews() {
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(CollectionsCell.self, forCellWithReuseIdentifier: CollectionsCell.collectionsCustomReuseIdentifier)
        
        addSubview(collectionView ?? UIView())
        collectionView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: Implementing CollectionView DataSourceDelegate Protocol

extension CustomTableCellForCollections: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionsCell.collectionsCustomReuseIdentifier, for: indexPath) as! CollectionsCell
        
        cell.titleName.text = nil
        cell.titleImageView.image = nil
        
        cell.titleName.text = collections[indexPath.row].title
        cell.titleImageView.backgroundColor = UIColor.init(hex: collections[indexPath.row].coverPhoto.color)
        if let url = URL(string: collections[indexPath.row].coverPhoto.urls.full) {
            cell.titleImageView.af_setImage(withURL: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CollectionPhotosController()
        vc.title = collections[indexPath.row].title
        vc.collection = collections[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Implementing CollectionViewDelegateFlowLayout Protocol

extension CustomTableCellForCollections: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width - 40, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let maxOffset = scrollView.contentSize.width - scrollView.frame.size.width
        
        if maxOffset - offset <= 0 {
            if !mainPageVM.collectionsIsLoading {
                mainPageVM.collectionsIsLoading = true
                
                mainPageVM.loadMoreCollections(offset: mainPageVM.getCountOfCollections()) { [weak self] (response, error) in
                    if let unwrappedError = error {
                        print("UnwrappeddError from loadMorePhotos:", unwrappedError.localizedDescription)
                    } else if let data = response {
                        data.forEach({ (collection) in
                            let row = self?.mainPageVM.getCountOfCollections()
                            let indexPath = IndexPath(row: row ?? Int(), section: 0)
                            self?.collections.append(collection)
                            
                            self?.collectionView?.insertItems(at: [indexPath])
                        })
                        self?.mainPageVM.collectionsIsLoading = false
                    }
                }
            }
        }
        
    }
    
}

