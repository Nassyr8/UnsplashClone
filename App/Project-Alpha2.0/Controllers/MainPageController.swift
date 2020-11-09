//
//  MainPageController.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class MainPageController: UIViewController {
    
    var tableView = UITableView()
    var mainPageVM = MainPageVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupUIViews()
        connectVM()
        getCollectionsData()
        getPhotosData()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "Photos for everyone"
    }
    
    private func setupUIViews() {
        
        tableView.register(CustomTableCellForCollections.self, forCellReuseIdentifier: CustomTableCellForCollections.customTableCellReuseIdentifier)
        tableView.register(CustomTableCellForPhotos.self, forCellReuseIdentifier: CustomTableCellForPhotos.customTableCellForPhotosReuseIdentifier)
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func connectVM() {
        mainPageVM.updateDataDelegate = self
    }
    
    private func getCollectionsData() {
        
        mainPageVM.getCollections { (error) in
            if let unwrappedError = error {
                print("UnwrappedError with fetching collections:", unwrappedError.localizedDescription)
            }
        }
        
    }
    
    private func getPhotosData() {
        
        mainPageVM.getPhotos { (error) in
            if let unwrappedError = error {
                print("UnwrappedError with fetching photos:", unwrappedError.localizedDescription)
            }
        }
        
    }
    
}

extension MainPageController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return mainPageVM.getCountOfSectionTitles()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return mainPageVM.getTitleOfSections(at: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return section == 0 ? 1 : mainPageVM.getCountOfPhotos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCellForCollections.customTableCellReuseIdentifier, for: indexPath) as! CustomTableCellForCollections
            cell.collections = mainPageVM.getAllCollections()
            cell.collectionView?.reloadData()
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCellForPhotos.customTableCellForPhotosReuseIdentifier, for: indexPath) as! CustomTableCellForPhotos
            if let url = URL(string: mainPageVM.getDataOfPhotos(at: indexPath.row).0) {
                cell.mainImageView.af_setImage(withURL: url)
            }
            cell.usernameButton.setTitle(mainPageVM.getDataOfPhotos(at: indexPath.row).1, for: .normal)            
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
}

extension MainPageController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 170
        } else {            
            return mainPageVM.getSizeOfPhoto(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PhotoDetailViewController()
        vc.image = UIImage(named: "bg_image")
        vc.viewModel.titleName = mainPageVM.getAuthorInfo(at: indexPath.row).name
        vc.viewModel.photoID = mainPageVM.photos[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainPageController: UpdateDataDelegate {
    
    func updateData() {
        tableView.reloadData()
    }
    
}
