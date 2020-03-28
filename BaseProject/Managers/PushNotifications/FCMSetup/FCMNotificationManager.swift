//
//  FCMNotificationManager.swift
//  BaseProject
//
//  Created by Michael Seven on 3/25/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UserNotifications

class FCMNotificationManager: NSObject {
    
    override init() {
        super.init()
    }
    
    func registerForPushNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
}

// MARK: - Messaging Delegate
extension FCMNotificationManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcmToken: \(fcmToken)")
        self.sendFCMToken(fcmToken: fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("remoteMessage: \(remoteMessage.appData)")
    }
}

// MARK: - Send FCMToken to Server
extension FCMNotificationManager {
    func sendFCMToken(fcmToken: String) {
        // send fcmToken to your Server
    }
    
    // Store FCMToken into Firestore after that we can send push notification from device to device?
        /*func updateFirestorePushTokenIfNeeded() {
            if let token = Messaging.messaging().fcmToken {
                let usersRef = Firestore.firestore().collection("users_table").document("currently_logged_in_user_id")
                usersRef.setData(["fcmToken": token], merge: true)
            }
        }*/
}

// MARK: - Notificaton Delegate
extension FCMNotificationManager: UNUserNotificationCenterDelegate {
    // Handle notification when app is in Foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Noti_ willPresent: \(notification)")
    }
    
    // Handle notification when Users tap on notification banner
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Noti_ didReceive: \(response)")
    }
}

/**
 This delegate methods bellow must excute in AppDelegate class
**/
// MARK: - UIApplication Delegate
extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /**
         As Firebase guideline:
         Swizzling disabled: mapping your APNs token and registration token
         If you have disabled method swizzling, you'll need to explicitly map your APNs token to the FCM registration token.
        **/
        Messaging.messaging().apnsToken = deviceToken
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let apnsToken = tokenParts.joined()
        print("apnsToken: \(apnsToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register apnsToken: \(error.localizedDescription)")
    }
    
    // Handle notification when app is in background
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Noti_ background: \(userInfo)")
    }
}
