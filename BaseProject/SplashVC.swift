//
//  SplashVC.swift
//  BaseProject
//
//  Created by Michael Seven on 12/23/19.
//  Copyright © 2019 Michael Seven. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import SnapKit
import MessageUI
import RxSwift
import Firebase
import GoogleSignIn


class SplashVC: UIViewController {
    
    let targetKey = "f_social"
//    let targetKey = "f_custom_scrollview"
    
    let disposeBag = DisposeBag()
    
    let contentView = UIView()
    let bgImage = UIImageView()
    let loginBtn = UIButton()
    let sendMailBtn = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupViews()
        subscribeEvent()
        setupGGSignIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        gotoStudentScreen()
//        if let vc = AppManager.shared.viewController(forKey: targetKey) {
//            present(vc, animated: true, completion: nil)
//        }
    }
}

// MARK: - Setup views
extension SplashVC {
    func setupViews() {
        self.view.addSubview(contentView)
        contentView.backgroundColor = .red
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.addSubview(bgImage)
        bgImage.image = UIImage(named: "iPhone-wallpaper-car-vintage")
        bgImage.contentMode = .scaleAspectFill
        bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        //add Login view
        contentView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }
        loginBtn.layer.cornerRadius = 8
        loginBtn.backgroundColor = .blue
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.setTitle("Login", for: .normal)
        
        //Add send email to get support
        contentView.addSubview(sendMailBtn)
        sendMailBtn.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }
        sendMailBtn.layer.cornerRadius = 8
        sendMailBtn.backgroundColor = .darkGray
        sendMailBtn.setTitleColor(.white, for: .normal)
        sendMailBtn.setTitle("Support", for: .normal)
    }
    
    /**
    Subscribes event
    **/
    private func subscribeEvent() {
        loginBtn.rx.tap.asDriver()
            .throttle(3)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
//                self.signInWithGG()
                self.googleSignInPressed()
//                if let vc = AppManager.shared.viewController(forKey: self.targetKey) {
//                    self.present(vc, animated: true, completion: nil)
//                }
            })
            .disposed(by: disposeBag)
        
        sendMailBtn.rx.tap.asDriver()
            .throttle(3)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showSendEmailScreen()
            })
            .disposed(by: disposeBag)
    }
    
    private func signInWithGG() {
        let string = "Go to Login"
        Log.shared.write(string)
        let socialVC = SocialVC()
        socialVC.viewModel.socialResult.asObservable()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if result == nil {
                    print("Failed to sign in with Google")
                } else {
                    self.navigationController?.popViewController(animated: true)
                    // Go to main screen
                    // ...
                }
            })
            .disposed(by: disposeBag)
        self.navigationController?.pushViewController(socialVC, animated: true)
    }
    
    private func showSendEmailScreen() {
        if let mail = FUtility.shared.sendEmail(attachFile: nil) {
            self.present(mail, animated: true, completion: nil)
            mail.mailComposeDelegate = self
        }
    }
    
    private func googleSignInPressed() {
        let user = Auth.auth().currentUser
        if user?.uid == nil {
            GIDSignIn.sharedInstance()?.signIn()
        } else {
            gotoChat()
        }
    }
}

// MARK: - Mail delegate
extension SplashVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("Complete send Email: \(result)")
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - GG signIn Delegate
extension SplashVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("7_ error: Failed to signin With GG!")
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let ggUserID = auth.idToken
        standardUserDefaults.set(ggUserID, forKey: "Google_IdToken")
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { [weak self] (authResult, error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.")
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
                if let user = Auth.auth().currentUser {
                    print("7_ user: \(user)")
                    self.gotoChat()
                }
            }
        }
    }
    
    func setupGGSignIn() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    func gotoChat() {
        let chatVC = ChatViewController()
//        self.navigationController?.pushViewController(chatVC, animated: true)
        self.present(chatVC, animated: true, completion: nil)
    }
    
    func gotoStudentScreen() {
        let studentVC = StudentManagerVC()
        self.navigationController?.pushViewController(studentVC, animated: true)
    }
}
