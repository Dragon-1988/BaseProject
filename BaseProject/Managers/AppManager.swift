//
//  AppManager.swift
//  BaseProject
//
//  Created by Michael Seven on 2/16/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

/*
 Class AppManager is singleton class
 - It store settings, IDs, Token
 - It also create Controller objects for other purpose
 */

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SwiftyJSON
import KeychainAccess

class AppManager {
    static let shared = AppManager()
    
    var setting: JSON?
    
    //declare user variable
    //var user: UserModel?
    
    var accessToken: String? {
        didSet {
            // Set it's value to Memory
            standardUserDefaults.set(accessToken, forKey: kAccessToken)
        }
    }
    
    //MARK: - Init
    init() {
//        let jsonPath = Bundle.main.path(forResource: "app_config", ofType: "json")!
//        let jsonData = JSON(NSData(contentsOfFile: jsonPath))
//        setting = jsonData
    }
}
