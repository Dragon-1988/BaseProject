//
//  ViewController.swift
//  BaseProject
//
//  Created by Michael Seven on 11/28/19.
//  Copyright © 2019 Michael Seven. All rights reserved.
//

import UIKit
import SnapKit
import FlexLayout

class ViewController: UIViewController {

    let targetKey = "f_social"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        if let vc = AppManager.shared.viewController(forKey: targetKey) {
//            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
        }
    }

    func gotoCustomView() {
        //go to Self resizing cell in UICollectionView
        let vc = SelfResizingCellInCollectionView()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}

