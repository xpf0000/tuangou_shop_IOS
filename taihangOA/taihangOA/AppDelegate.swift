//
//  AppDelegate.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Reachability

let netcheck = Reachability()!
var mapStarted = false

var NetConnected = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate {

    var window: UIWindow?

    func RegistPushNotice()
    {
        let settings:UIUserNotificationSettings=UIUserNotificationSettings(types: [.alert,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        netcheck.whenReachable = { reachability in
            DispatchQueue.main.async {
                NetConnected = true
            }
        }
        
        netcheck.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                NetConnected = false
            }
        }
        
        do {
            try netcheck.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
     
        
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.\
        
        print("applicationWillEnterForeground !!!!!!!!!")
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
        print("applicationDidBecomeActive !!!!!!!!!")
            
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

}

