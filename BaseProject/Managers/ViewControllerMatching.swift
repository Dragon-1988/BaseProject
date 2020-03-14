//
//  ViewControllerMatching.swift
//  BaseProject
//
//  Created by Michael Seven on 2/16/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

/**
 This class initial ViewController as key and return it
 **/

import Foundation
import UIKit

extension AppManager {
    
    func viewController(forKey key: String) -> UIViewController? {
        var viewController: UIViewController?
        
        switch key {
        case "f_social":
            viewController = SocialVC()
        default:
            viewController = nil
        }
        
        return viewController
    }
}
