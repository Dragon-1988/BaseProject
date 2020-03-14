//
//  SplashVC.swift
//  BaseProject
//
//  Created by Michael Seven on 12/23/19.
//  Copyright © 2019 Michael Seven. All rights reserved.
//

import Foundation
import UIKit
//import RxCocoa
import FlexLayout


class SplashVC: UIViewController {
    
    let bgImage = UIImageView()
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func viewDidLoad() {
        view.addSubview(bgImage)
    }
}

// MARK: - Setup views
extension SplashVC {
    func setupViews() {
//        var subView = UIView()
//        self.view.addSubview(subView)
//        subView.snp.makeConstraint {}
//
//        self.view.addSubview(bgImage)
//        bgImage.backgroundColor = .gray
////        bgImage.snp.makeConstraint {
////            $0.edge.equaltoSuperView
////        }
    }
}
