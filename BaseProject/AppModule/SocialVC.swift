//
//  SocialVC.swift
//  BaseProject
//
//  Created by Michael Seven on 2/16/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import UIKit
import RxSwift
import MessageUI

class SocialVC: UIViewController {
    
    let viewModel = SocialVM()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        printAndLog()
        sendFileToMail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initComponents()
    }
}

// MARK: - Init components
extension SocialVC {
    func initComponents() {
        let stackView = UIStackView()
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints( {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        } )
        
        // create SNS button
        let googleBtn = UIButton()
        googleBtn.setTitle("Sign in with Google", for: .normal)
        googleBtn.backgroundColor = .gray
        googleBtn.tintColor = .blue
        googleBtn.setTitleColor(.blue, for: .normal)
        stackView.addArrangedSubview(googleBtn)
        
        googleBtn.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.doLoginEvent.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Print & Log in file
extension SocialVC {
    func printAndLog() {
        let str = "777___: Super long string here"
        let filename = getDocumentsDirectory().appendingPathComponent("output.txt")

        do {
            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("7_ path: \(paths[0])")
        return paths[0]
    }
    
    func sendFileToMail() {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services is not available")
            return
        }
        let mail = MFMailComposeViewController()
        mail.setToRecipients(["baydv@paditech.org"])
        mail.setSubject("Test sending mail")
        mail.setMessageBody("This mail is sent from an BaseProject app", isHTML: true)
        mail.mailComposeDelegate = self
        
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
        present(mail, animated: true, completion: nil)
    }
}

extension SocialVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("result: \(result)")
    }
}
