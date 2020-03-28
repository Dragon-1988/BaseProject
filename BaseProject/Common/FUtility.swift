//
//  FUtility.swift
//  BaseProject
//
//  Created by Michael Seven on 3/14/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MessageUI

class FUtility: UIViewController {
    
    static let shared = FUtility()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Send Email
extension FUtility {
    func sendEmail(receiveEmail email: String = "", attachFile file: NSData?) -> MFMailComposeViewController? {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services is not available")
            return nil
        }
        let mail = MFMailComposeViewController()
        mail.setToRecipients(["baydv@paditech.org"])
        mail.setSubject("Test sending mail")
        mail.setMessageBody("This mail is sent from an BaseProject app", isHTML: true)

        let outputFilePath = getDocumentsDirectory().appendingPathComponent("output.txt")
//        let outputStr = outputFilePath.absoluteString
        let outputStr = "\(outputFilePath.path)"

        if let filePath = Bundle.main.path(forResource: "SampleData", ofType: "json") {
            if let data = NSData(contentsOfFile: filePath) {
                mail.addAttachmentData(data as Data, mimeType: "application/json", fileName: "SampleData.json")
            }
            if let data2 = NSData(contentsOfFile: outputStr) {
                mail.addAttachmentData(data2 as Data, mimeType: "text", fileName: "output.txt")
            }
        }
        return mail
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("7_ path: \(paths[0])")
        return paths[0]
    }
}

extension Date {
    static func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
}
