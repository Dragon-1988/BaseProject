//
//  SocialManager.swift
//  BaseProject
//
//  Created by Michael Seven on 2/16/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import Foundation
import GoogleSignIn

enum SocialType: Int {
    case apple = 1
    case facebook = 2
    case google = 3
    case twitter = 4
}


typealias SocialLoginResult = (id: String, token: String, secretToken: String)
//typealias SocialData = (type: SocialType, info: SocialLoginResult)

class SocialManager: NSObject {
    
    typealias LoginResult = (SocialLoginResult?) -> Void
    
    var googleLoginResult: LoginResult?
    
    override init() {
        super.init()
        self.setupGoogleSignIn()
    }
    
    func login(socialType type: SocialType, viewController: UIViewController?, result: @escaping LoginResult) {
        switch type {
        case .google: // google login
            googleLogin(result: result)
        default:
            break
        }
    }
}

// MARK: - Setup Google Sign In
extension SocialManager {
    private func setupGoogleSignIn() {
        let googleClientID = "1000413915310-raq2o95t4r899q39ivrls3oemguuur1i.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().clientID = googleClientID
        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    private func googleLogin(result: @escaping LoginResult) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        self.googleLoginResult = result
    }
}

// MARK: - Google Delegate
extension SocialManager: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            self.googleLoginResult?((user.userID, user.authentication.accessToken, ""))
        } else {
            self.googleLoginResult?(nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.googleLoginResult?(nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
    }
}
