//
//  PhotoDetailViewController.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 7/28/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class PhotoDetailViewController: UIViewController, DateConvertable {
    
    let viewModel = PhotoDetailVM()
    var identifierForCache: String?
    var photoID: String?
    var titleName: String?
    
    let indicatorView = UIActivityIndicatorView()
    
    lazy var customView: CustomPopUpView = {
        let customView = CustomPopUpView(frame: .init(x: 0, y: viewModel.height, width: UIScreen.main.bounds.width, height: viewModel.height + 100))
        
        customView.layer.cornerRadius = 8
        
        return customView
    }()
    
    lazy var scrollView: CustomScrollView = {
        let scrollView = CustomScrollView()
        
        scrollView.delegate = self
        scrollView.backgroundColor = .black
        scrollView.imageView.image = ImageCacheManager.shared.fetchImage(with: identifierForCache!)
        
        return scrollView
    }()
    
    lazy var infoButton: UIButton = {
        let infoButton = UIButton(type: UIButton.ButtonType.infoLight)
        
        infoButton.isHidden = true
        infoButton.addTarget(self, action: #selector(didInfoButtonPressed(_:)), for: .touchUpInside)
        infoButton.tintColor = .white
        
        return infoButton
    }()
    
    lazy var downloadButton: UIButton = {

        let downloadButton = UIButton()
        let image = UIImage(named: "download-arrow")
        downloadButton.backgroundColor = .white
        downloadButton.clipsToBounds = false
        downloadButton.setImage(image, for: .normal)
        downloadButton.layer.cornerRadius = 25
        downloadButton.addTarget(self, action: #selector(didDownloadButtonPressed(_:)), for: .touchUpInside)
        
        return downloadButton
    }()
    
    var photoDetail: Photo? {
        didSet {
            if let photo = photoDetail {                
                if photo.exif.make != "" {
                    customView.makeLabel.text = "Make \n" + photo.exif.make
                }
                if photo.exif.focalLength != "" {
                    customView.focalLengthLabel.text = "Focal Length \n" + photo.exif.focalLength
                }
                if photo.exif.model != "" {
                    customView.modelLabel.text = "Model \n" + photo.exif.model
                }
                if photo.exif.iso != "" {
                    customView.isoLabel.text = "ISO \n" + photo.exif.iso
                }
                if photo.exif.exposuretTime != "" {
                    customView.shutterSpeedLabel.text = "Shutter Speed \n" + photo.exif.exposuretTime
                }
                if photo.exif.aperture != "" {
                    customView.apertureLabel.text = "Aperture \n" + photo.exif.aperture
                }
                
                customView.dimensionsLabel.text = "Dimensions \n" + photo.height.description + " x " + photo.width.description
                customView.publishedLabel.text = "Published on " +  convertToDate(date: photo.createdAt)
            }
            
        }
    }
    
    lazy var navBar = navigationController?.navigationBar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar(BgColor: .black, textColor: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setupNavigationBar(BgColor: .white, textColor: .black)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootView()
        
        tabBarController?.tabBar.isHidden = true
        
        setupNavigationBar()
        setupScrollView()
        setupIndicatorView()
        setupButtons()
        setupInfoView()
        getPhotoDetail()
    }
    
    private func setupRootView() {
        view.backgroundColor = .black
    }
    
    private func setupIndicatorView() {
        view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func setupNavigationBar() {        
        navigationItem.title = titleName
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didShareButtonPressed(_:)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(didBackButtonPressed(_:)))
    }
    
    private func setupNavigationBar(BgColor: UIColor, textColor: UIColor) {
        
        let navBar = self.navigationController?.navigationBar
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        navBar?.tintColor = textColor
        navBar?.barTintColor = BgColor
        if BgColor == .black {
            navBar?.setValue(true, forKey: "hidesShadow")
        }
        
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func setupButtons() {
        view.addSubview(infoButton)
        view.addSubview(downloadButton)
        
        downloadButton.snp.makeConstraints { (make) in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.size.equalTo(50)
        }
        
        infoButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func setupInfoView() {
        
        view.addSubview(customView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOutside(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragCustomView(_:)))
        customView.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    private func getPhotoDetail() {
        indicatorView.startAnimating()
        
        if let id = self.photoID {
            
            viewModel.fetchPhotoDetailData(id: id) { [weak self] (response, error) in
                if let unwrappedError = error {
                    self?.indicatorView.stopAnimating()
                    self?.infoButton.isHidden = false
                    print("Error from fetching photo details:", unwrappedError.localizedDescription)
                } else if let data = response {
                    self?.indicatorView.stopAnimating()
                    self?.infoButton.isHidden = false
                    
                    self?.photoDetail = data
                }
            }
            
        }
        
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / scrollView.imageView.bounds.width
        let heightScale = size.height / scrollView.imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    private func moveUpCustoView() {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.customView.frame.origin = CGPoint(x: 0, y: self.viewModel.height/2)
        }, completion: { _ in
            self.viewModel.isShow.toggle()
        })
    }
    
    private func hideAllObjects(){
        let alpha: CGFloat = viewModel.isHidden ? 1.0 : 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.infoButton.alpha = alpha
            self.downloadButton.alpha = alpha
            self.navigationController?.navigationBar.alpha = alpha
        }) { _ in
            self.viewModel.isHidden.toggle()
        }
    }
    
    private func saveImageToDevice() {
        let imageData = scrollView.imageView.image!.pngData()
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // selector actions
    
    @objc private func didBackButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didInfoButtonPressed(_ sender: UIButton) {
        moveUpCustoView()
    }
    
    @objc private func didDownloadButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0,
                       options: .curveLinear,
                       animations: {
                        self.downloadButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.downloadButton.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.saveImageToDevice()
            })
        })
    }
    
    @objc private func didShareButtonPressed(_ sender: UIBarButtonItem) {
        let activityVC = UIActivityViewController(activityItems: ["url of photo"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        present(activityVC, animated: true)
    }
    
    @objc private func didTapOutside(_ sender: UITapGestureRecognizer) {
        guard viewModel.isShow else {
            hideAllObjects()
            return
        }
        
        let location = sender.location(in: self.view)
        
        if !customView.frame.contains(location) {
            UIView.animate(withDuration: viewModel.normalTimeConstant, animations: {
                self.customView.frame.origin = CGPoint(x: 0, y: self.viewModel.height)
            }) { _ in
                self.viewModel.isShow.toggle()
            }
        }
    }
    
    @objc private func didDragCustomView(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: view)
        
        switch sender.state {
        case .began:
            viewModel.touchPosition = sender.location(in: customView)
        case .changed:
            let position = sender.location(in: view)
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
            guard customView.frame.origin.y >= topBarHeight  else { break }
            customView.frame.origin = CGPoint(x: 0, y: position.y - viewModel.touchPosition.y)
        case .ended:
            if customView.frame.origin.y >= viewModel.height/2 + 100 {
                let timeCalc = velocity.y >= 500.0 ? viewModel.fastTimeConstant : viewModel.normalTimeConstant
                UIView.animate(withDuration: timeCalc, animations: {
                    self.customView.frame.origin = CGPoint(x: 0, y: self.viewModel.height)
                }) { _ in
                    self.viewModel.isShow.toggle()
                }
            } else {
                UIView.animate(withDuration: viewModel.normalTimeConstant, animations: {
                    self.customView.frame.origin = CGPoint(x: 0, y: self.viewModel.height/2)
                }) { _ in
                    
                }
            }
        default:
            break
        }
    }

}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension PhotoDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scrollView.imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        view.layoutIfNeeded()
    }
}
