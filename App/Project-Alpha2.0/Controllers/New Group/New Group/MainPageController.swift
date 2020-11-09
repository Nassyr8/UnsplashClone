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
    
    // MARK: - Private Properties
    
    private var tableView = ThemedTable()
    private var mainPageVM = MainPageVM()
    
    private var parallaxHeaderView: ParallaxHeaderTableView!
    private var parallaxSearchBar: UISearchBar!
    private var searchView: SearchView!
    private var settingsView: SettingsView!
    private let underSettingsView = UIView()
    
    private var headerHeightConstraint: NSLayoutConstraint!
    private var searchBarCurrentPosition = CGFloat()
    private lazy var headerHeight = (view.frame.height / 2) - 50
    private var keyboardHeight = CGFloat()
    
    private var parallaxRandomPhoto: Photo? {
        didSet {
            if let photo = parallaxRandomPhoto {
                parallaxHeaderView.authorNameLabel.text = "Photo by " + photo.user.name
                if let url = URL(string: photo.urls.regular) {
                    parallaxHeaderView.randomImageView.af_setImage(withURL: url)
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupUIViews()
        connectVM()
        getSearchHistory()
        getCollectionsData()
        getPhotosData()
        
        getRandomPhotoData()
        _ = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(executeFuncWithTimer), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        
        view.backgroundColor = .white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOutside(_:)))
        underSettingsView.addGestureRecognizer(tapGestureRecognizer)
        
        // MARK: - Listening keyboardWillShow Notification
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func setupUIViews() {
        
        // MARK: - Initialize ParallaxHeaderView
        
        parallaxHeaderView = ParallaxHeaderTableView(frame: .zero)
        parallaxHeaderView.settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        view.addSubview(parallaxHeaderView)
        
        headerHeightConstraint = parallaxHeaderView.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint.isActive = true
        
        parallaxHeaderView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()            
        }
        
        // MARK: - Initialize parallaxSearchBar
        
        self.parallaxSearchBar = parallaxHeaderView.searchBar
        self.parallaxSearchBar.delegate = self
        
        // MARK: - Registering TableView Cells
        
        tableView.register(CustomTableCellForCollections.self, forCellReuseIdentifier: CustomTableCellForCollections.customTableCellReuseIdentifier)
        tableView.register(CustomTableCellForPhotos.self, forCellReuseIdentifier: CustomTableCellForPhotos.customTableCellForPhotosReuseIdentifier)
        
        tableView.dataSource = self        
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(parallaxHeaderView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // MARK: - Initialize SearchView
        
        searchView = SearchView(frame: .zero)
        searchView.searchFromHistoryListDelegate = self
        view.addSubview(searchView)
        
        // MARK: - Initialize SettingsView
        
        settingsView = SettingsView()
        underSettingsView.isHidden = true
        underSettingsView.backgroundColor = .clear
        view.addSubview(underSettingsView)
        underSettingsView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.addSubview(settingsView)
        settingsView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topPadding + 40)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo((self.view.frame.width * 2) / 3)
            make.height.equalTo(100)
        }
        
    }
    
    private func connectVM() {
        
        mainPageVM.updateDataDelegate = self                
    }
    
    private func getCollectionsData() {
        
        mainPageVM.getCollections(pageNumber: mainPageVM.collectionsPageNumber) { (error) in
            if let unwrappedError = error {
                print("UnwrappedError with fetching collections:", unwrappedError.localizedDescription)
            }
        }
        
    }
    
    private func getPhotosData() {
        
        mainPageVM.getPhotos(pageNumber: mainPageVM.pageNumber) { [weak self] (error) in
            if let unwrappedError = error {
                print("UnwrappedError with fetching photos:", unwrappedError.localizedDescription)
            } else {
                self?.mainPageVM.pageNumber += 1
            }
        }
        
    }
    
    private func getRandomPhotoData() {
        
        mainPageVM.getRandomPhotoData { [weak self] (response, error) in
            if let unwrappedError = error {
                print("UnwrappedError with fetching photos:", unwrappedError.localizedDescription)
            } else if let data = response {
                self?.parallaxRandomPhoto = data
            }
        }
        
    }
    
    private func getSearchHistory() {
        
        searchView.fetchSearchHistoryData()
    }
    
    private func didSearch(query: String) {
        
        let vc = CollectionPhotosController()
        vc.query = query
        vc.title = query
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func animateHeader() {
        
        headerHeightConstraint.constant = headerHeight
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    // MARK: - Selector Actions
    
    @objc private func executeFuncWithTimer() {
        
        getRandomPhotoData()
    }
    
    
    @objc private func settingsButtonPressed() {

        UIView.animate(withDuration: 0.3, animations: {
            self.settingsView.isHidden.toggle()
            self.underSettingsView.isHidden.toggle()
        }) { (_) in
        }
        
    }
    
    @objc private func didTapOutside(_ sender: UITapGestureRecognizer) {

        guard !settingsView.isHidden else {
            return
        }

        let location = sender.location(in: self.view)

        if underSettingsView.frame.contains(location) {
            self.settingsView.isHidden.toggle()
            self.underSettingsView.isHidden.toggle()
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let size = CGRect(x: 0, y: (topPadding + 55), width: self.view.frame.width, height: self.view.frame.height - keyboardSize.height - bottomPadding - (topPadding + 55))
            self.searchView.frame = size
        }
        
    }
    
    @objc private func authorButtonPressed(_ sender: UIButton) {
        
        let vc = AuthorViewController()
        vc.authorInfo = mainPageVM.getAuthorInfo(at: sender.tag)
        vc.identifierForCache = mainPageVM.getDataOfPhotos(at: sender.tag).0
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: Implementing TableView DataSourceDelegate Protocol

extension MainPageController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return mainPageVM.getCountOfSectionTitles()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return mainPageVM.getTitleOfSections(at: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = SectionHeaderView()
        headerView.titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : mainPageVM.getCountOfPhotos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCellForCollections.customTableCellReuseIdentifier, for: indexPath) as! CustomTableCellForCollections
            cell.navigationController = self.navigationController
            cell.collections = mainPageVM.getAllCollections()
            cell.collectionView?.reloadData()
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCellForPhotos.customTableCellForPhotosReuseIdentifier, for: indexPath) as! CustomTableCellForPhotos
            
            cell.configureCell(with: mainPageVM.getPhoto(at: indexPath.row))
            
            cell.usernameButton.tag = indexPath.row
            cell.usernameButton.addTarget(self, action: #selector(authorButtonPressed(_:)), for: .touchUpInside)
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
}

// MARK: - Implementing TableViewDelegate Protocol

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
        vc.identifierForCache = mainPageVM.getDataOfPhotos(at: indexPath.row).0
        vc.titleName = mainPageVM.getAuthorInfo(at: indexPath.row).name
        vc.photoID = mainPageVM.photos[indexPath.row].id
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Implementing ScrollViewDelegate Protocol

extension MainPageController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // MARK: Implementing Parallax Header View
        
        if scrollView.contentOffset.y < 0 {
            
            self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
            
            parallaxHeaderView.showElements()
            
        } else if scrollView.contentOffset.y > 0 && self.headerHeightConstraint.constant >= (topPadding + 55) {
            
            self.headerHeightConstraint.constant -= scrollView.contentOffset.y / 100
            
            if self.headerHeightConstraint.constant < (topPadding + 55) {
                self.headerHeightConstraint.constant = (topPadding + 55)
                
                parallaxHeaderView.hideElements()
            }
            
        }
        
        // MARK: Implementing Infinite ScrollView
        
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maxOffset - offset <= 500 {            
            if !mainPageVM.isLoading {
                mainPageVM.isLoading = true

                mainPageVM.loadMorePhotos(offset: mainPageVM.getCountOfPhotos()) { [weak self] (response, error) in

                    if let unwrappeddError = error {

                        print("UnwrappeddError from loadMorePhotos:", unwrappeddError.localizedDescription)
                    } else if let data = response {

                        data.forEach({ (photo) in
                            let row = self?.mainPageVM.getCountOfPhotos()
                            let indexPath = IndexPath(row: row ?? Int(), section: 1)
                            self?.mainPageVM.photos.append(photo)
                            
                            self?.tableView.insertRows(at: [indexPath], with: .automatic)
                        })

                        self?.mainPageVM.isLoading = false
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if self.headerHeightConstraint.constant > headerHeight {
            animateHeader()
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.headerHeightConstraint.constant > headerHeight {
            animateHeader()
        }
        
    }
    
}

// MARK: - Implementing UISearchBarDelegate Protocol

extension MainPageController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        searchBar.text = ""
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBarCurrentPosition = searchBar.frame.origin.y
        
        UIView.animate(withDuration: 0.1, animations: {
            if searchBar.frame.origin.y > 19.5 {
                searchBar.frame.origin.y = 19.5
            }
            searchBar.showsCancelButton = true
        }) { (_) in
            self.searchView.isHidden = false
            self.parallaxHeaderView.hideElements()
        }
        
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        UIView.animate(withDuration: 0.1, animations: {
            
            if self.searchBarCurrentPosition > 19.5 {
                
                self.parallaxHeaderView.showElements()
                searchBar.frame.origin.y = self.searchBarCurrentPosition
            }
            self.searchView.isHidden = true
            searchBar.showsCancelButton = false
        }) { (_) in
            
        }
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text != nil && searchBar.text != "" {
            guard let query = searchBar.text else { return }
            
            searchBar.text = ""
            
            didSearch(query: query)        
            
            var historyList: [String] = []
            if let array = UserDefaults.standard.value(forKey: "historyOfSearch") as? [String] {
                historyList = array
            }
            if !historyList.contains(query.lowercased()) && !historyList.contains(query) {
                historyList.append(query)
            }
            
            UserDefaults.standard.set(historyList, forKey: "historyOfSearch")
            searchView.fetchSearchHistoryData()
        }
    }
    
}

// MARK: - Implementing SearchFromHistoryListDelegate Protocol

extension MainPageController: SearchFromHistoryListDelegate {
    
    func search(query: String) {
        didSearch(query: query)
    }
    
}

// MARK: - Implementing UpdateDataDelegate Protocol

extension MainPageController: UpdateDataDelegate {
    
    func updateData() {
        tableView.reloadData()
    }
    
}
