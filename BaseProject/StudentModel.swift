//
//  StudentModel.swift
//  BaseProject
//
//  Created by Michael Seven on 3/28/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import Foundation
import RealmSwift

class StudentModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var age: Int = 0
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
}
