//
//  ViewController.swift
//  BaseProject
//
//  Created by Michael Seven on 11/28/19.
//  Copyright © 2019 Michael Seven. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gotoCustomView()
    }

    func gotoCustomView() {
        
        //go to Self resizing cell in UICollectionView
        let vc = SelfResizingCellInCollectionView()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}

