//
//  ViewController.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 7/28/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let image = UIImage(named: "bg_image")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "next",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(nextController(_:)))
    }
    
    @objc private func nextController(_ sender: UIBarButtonItem) {
        let vc = AuthorViewController()
        vc.image = image
        navigationController?.pushViewController(vc, animated: true)
    }


}

