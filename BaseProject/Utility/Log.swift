//
//  Log.swift
//  BaseProject
//
//  Created by Michael Seven on 3/15/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import Foundation
class Log {
    static let shared = Log()
    
    func write(_ string: String = "") {
        let date = Date()
        let formateData = Date.getFormattedDate(date: date, format: "yyyy-MM-dd HH:mm:ss")
        let content = "\n" + formateData + ":" + "\n" + string
        
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
        print("log: \(log)")
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write(content.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? content.data(using: .utf8)?.write(to: log)
        }
    }
    
    private init() {}
}
