//
//  CollectionPhotosController.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/30/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class CollectionPhotosController: ThemedController {
    
    // MARK: - Public Properties
    
    var collection: Collection?
    var query: String?
    
    // MARK: - Private Properties
    
    private var tableView = ThemedTable()
    private var collectionPhotosVM = CollectionPhotosVM()
    private var emptyResponseView: EmptyResponseView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        connectVM()
        getPhotos()
        setupView()
        setupUIViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if emptyResponseView != nil {
            emptyResponseView.removeFromSuperview()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setupUIViews() {
        
        // MARK: - Registering TableView Cells
        
        tableView.register(CustomTableCellForPhotos.self, forCellReuseIdentifier: CustomTableCellForPhotos.customTableCellForPhotosReuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func connectVM() {
        
        collectionPhotosVM.updateDataDelegate = self
    }
    
    func getPhotos() {
        
        if let collect = collection {
            collectionPhotosVM.getPhotos(pageNumber: collectionPhotosVM.pageNumber, id: collect.id, photoType: .collectionPhoto, query: nil) { [weak self] (isEmpty, error) in
                if let unwrappedError = error {
                    print("UnwrappedError with fetching photos:", unwrappedError.localizedDescription)
                }
                if isEmpty {
                    self?.showEmptyResponseView()
                }
            }
        } else if let searchWord = query {
            
            collectionPhotosVM.getPhotos(pageNumber: collectionPhotosVM.pageNumber, id: nil, photoType: .searchPhoto, query: searchWord) { [weak self] (isEmpty, error) in
                if let unwrappedError = error {
                    print("UnwrappedError with fetching photos:", unwrappedError.localizedDescription)
                }
                if isEmpty {
                    self?.showEmptyResponseView()
                }
            }
        }
        
    }
    
    private func showEmptyResponseView() {
        
        // MARK: - Initialize EmptyResponseView
        
        emptyResponseView = EmptyResponseView()
        view.addSubview(emptyResponseView)
        emptyResponseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    // MARK: - Selector Actions
    
    @objc private func authorButtonPressed(_ sender: UIButton) {
        
        let vc = AuthorViewController()
        vc.authorInfo = collectionPhotosVM.getAuthorInfo(at: sender.tag)
        vc.identifierForCache = collectionPhotosVM.getDataOfPhotos(at: sender.tag).0
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: Implementing TableView DataSourceDelegate Protocol

extension CollectionPhotosController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectionPhotosVM.getCountOfPhotos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCellForPhotos.customTableCellForPhotosReuseIdentifier, for: indexPath) as! CustomTableCellForPhotos
        cell.mainImageView.backgroundColor = UIColor.init(hex: collectionPhotosVM.getDataOfPhotos(at: indexPath.row).2)
        if let url = URL(string: collectionPhotosVM.getDataOfPhotos(at: indexPath.row).0) {
            cell.mainImageView.af_setImage(withURL: url) { (result) in
                guard let image = result.value else { return }
                ImageCacheManager.shared.addImage(image: image, with: self.collectionPhotosVM.getDataOfPhotos(at: indexPath.row).0)
            }
        }
    cell.usernameButton.setTitle(collectionPhotosVM.getDataOfPhotos(at: indexPath.row).1, for: .normal)
        cell.usernameButton.tag = indexPath.row
        cell.usernameButton.addTarget(self, action: #selector(authorButtonPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
}

// MARK: - Implementing TableViewDelegate Protocol

extension CollectionPhotosController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return collectionPhotosVM.getSizeOfPhoto(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PhotoDetailViewController()
        vc.identifierForCache = collectionPhotosVM.getDataOfPhotos(at: indexPath.row).0
        vc.titleName = collectionPhotosVM.getAuthorInfo(at: indexPath.row).name
        vc.photoID = collectionPhotosVM.photos[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maxOffset - offset <= 0 {
            if !collectionPhotosVM.isLoading {
                collectionPhotosVM.isLoading = true
                
                var photoType: PhotoRequestType!
                
                var photoId = Int()
                if let collect = collection {
                    photoId = collect.id
                    photoType = .collectionPhoto
                }
                
                var searchWord = String()
                if let word = query {
                    searchWord = word
                    photoType = .searchPhoto
                }
                
                collectionPhotosVM.loadMorePhotos(offset: collectionPhotosVM.getCountOfPhotos(), photoType: photoType, photoId: photoId, query: searchWord) { [weak self] (response, error) in
                    if let unwrappedError = error {
                        print("UnwrappeddError from loadMorePhotos:", unwrappedError.localizedDescription)
                    } else if let data = response {
                        data.forEach({ (photo) in
                            let row = self?.collectionPhotosVM.getCountOfPhotos() ?? Int()
                            let indexPath = IndexPath(row: row, section: 0)
                            self?.collectionPhotosVM.photos.append(photo)
                            
                            self?.tableView.insertRows(at: [indexPath], with: .automatic)
                        })
                    }
                    self?.collectionPhotosVM.isLoading = false
                }
                
            }
        }
        
    }
    
}

// MARK: - Implementing UpdateDataDelegate Protocol

extension CollectionPhotosController: UpdateDataDelegate {
    
    func updateData() {
        tableView.reloadData()
    }
    
}
