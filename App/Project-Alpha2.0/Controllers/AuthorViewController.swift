//
//  AuthorViewController.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 7/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class AuthorViewController: UIViewController {
    
    let viewModel = AuthorVM()

    var authorInfo: SponsorAndUser?
    var identifierForCache: String!
    var cellType: CellType = .photo
    var selectedIndex = 0
    
    let indicatorView = UIActivityIndicatorView()
    let tableView = ThemedTable()
    
    lazy var headerView: CustomHeaderView = {
        let headerView = CustomHeaderView()
        
        viewModel.getAvatar(authorInfo)
        
        headerView.frame.size.height = 230
        headerView.headerImageView.image = ImageCacheManager.shared.fetchImage(with: identifierForCache)
        headerView.nameLabel.text = authorInfo?.name
        headerView.locationLabel.text = authorInfo?.location
        headerView.urlLabel.text = authorInfo?.portfolioUrl
        headerView.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        
        if authorInfo?.location != "" {
            headerView.setupLocationIcon()
        }
        if authorInfo?.portfolioUrl != "" {
            headerView.setupBrowserIcon()
        }
        
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootView()
        setupTableView()
        
        getPhotoData(type: .userPhoto, username: authorInfo?.username ?? "")
    }
    
    private func setupRootView() {
        viewModel.delegate = self
        navigationController?.isNavigationBarHidden = true
        navigationItem.title = authorInfo?.username
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.register(CustomTableCellForPhotos.self, forCellReuseIdentifier: CustomTableCellForPhotos.customTableCellForPhotosReuseIdentifier)
        tableView.register(CustomTableCellForCollections.self, forCellReuseIdentifier: CustomTableCellForCollections.customTableCellReuseIdentifier)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func getPhotoData(type: PhotoRequestType, username: String) {
        
        viewModel.fetchUserPhotosData(type: type, pageNumber: 1, username: username) { [weak self] (error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                if type == .userPhoto {
                    self?.viewModel.current = (self?.viewModel.photos)!
                } else if type == .likesPhoto {
                    self?.viewModel.current = (self?.viewModel.likes)!
                }
                
                self?.tableView.reloadData()
            }
        }
        
    }
    
    private func getCollectionData(type: CollectionRequestType, username: String) {
        
        viewModel.fetchUserCollectionData(type: type, pageNumber: 1, username: username) {  [weak self] (error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                
                self?.tableView.reloadData()
            }
        }
        
    }
    
    @objc private func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            cellType = .photo
            selectedIndex = 0
            viewModel.current = viewModel.photos
            tableView.reloadData()
        case 1:
            cellType = .photo
            selectedIndex = 1
            viewModel.current = viewModel.likes
            getPhotoData(type: .likesPhoto, username: authorInfo?.username ?? "")
        case 2:
            selectedIndex = 2
            cellType = .collection
            getCollectionData(type: .userCollection, username: authorInfo?.username ?? "")
        default:
            break
        }
    }
    
    @objc private func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

enum CellType {
    case photo
    case collection
}

extension AuthorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CustomSectionHeaderView()
        view.segmentedControl.addTarget(self, action: #selector(AuthorViewController.indexChanged(_:)), for: .valueChanged)
        view.segmentedControl.selectedSegmentIndex = selectedIndex
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellType {
        case .photo:
            return viewModel.getCountOfPhotos()
        case .collection:
            return viewModel.getCountOfCollection()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cellType {
        case .collection:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCellForCollections.customTableCellReuseIdentifier, for: indexPath) as! CustomTableCellForCollections
            cell.navigationController = self.navigationController
            cell.collections = viewModel.getDataOfCollection()
            cell.collectionView?.reloadData()
            
            return cell
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCellForPhotos.customTableCellForPhotosReuseIdentifier, for: indexPath) as! CustomTableCellForPhotos
            cell.mainImageView.image = nil
            if let url = URL(string: viewModel.getDataOfPhotos(at: indexPath.row).0) {
                cell.mainImageView.af_setImage(withURL: url) { (result) in
                    guard let image = result.value else { return }
                    ImageCacheManager.shared.addImage(image: image, with: self.viewModel.getDataOfPhotos(at: indexPath.row).0)
                }
            }
            
            if selectedIndex == 1 {
                cell.usernameButton.setTitle(viewModel.getDataOfPhotos(at: indexPath.row).1, for: .normal)
            } else {
                cell.usernameButton.setTitle("", for: .normal)
            }
            
            
            return cell
        }

    }
}

extension AuthorViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let ofsetY = -scrollView.contentOffset.y
        let maxHeight = max(headerView.bounds.height, headerView.bounds.height + ofsetY)
        headerView.headerImageView.snp.updateConstraints { (make) in
            make.height.equalTo(maxHeight)
        }
        
        if ofsetY <= -130 {
            navigationController?.isNavigationBarHidden = false
        }else {
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch cellType {
        case .photo:
            return viewModel.getSizeOfPhoto(at: indexPath.row)
        case .collection:
            return 170
        }
        
    }
}

extension AuthorViewController: AuthorVMDelegate {
    func setAvatarImage() {
        headerView.avatarImageView.image = viewModel.avatarImage
    }
}
