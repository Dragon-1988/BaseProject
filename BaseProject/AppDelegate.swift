//
//  AppDelegate.swift
//  BaseProject
//
//  Created by Michael Seven on 11/28/19.
//  Copyright © 2019 Michael Seven. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setRootVC()
        setupFirebase()
        let fcmPushNotication = FCMNotificationManager()
        fcmPushNotication.registerForPushNotification()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        
    }
    
    func setRootVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let splashVC = SplashVC()
        let nav = UINavigationController(rootViewController: splashVC)
        window?.rootViewController = nav
        nav.isNavigationBarHidden = true
        window?.makeKeyAndVisible()
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = GIDSignIn.sharedInstance().handle(url)
        return handled
        // return GIDSignIn.sharedInstance().handle(url,
        // sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
        // annotation: [:])
    }
    
    private func setupFirebase() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
    }
    
}

