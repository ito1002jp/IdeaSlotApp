//
//  AppDelegate.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/22.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Realm Migration
        let config = Realm.Configuration(
            schemaVersion: 14,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 14) {}
        })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        
        RealmInitializer.setUp()
        createMenuView()
        DropDown.startListeningToKeyboard()
        
        return true
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    fileprivate func createMenuView(){
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainMenu") as! MainViewController
        let leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenu") as! LeftMenuViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        let slideMenuController = SlideMenuViewController(mainViewController:nvc, leftMenuViewController:leftMenuViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true

        UINavigationBar.appearance().tintColor = UIColor.darkGray
        
        leftMenuViewController.mainViewController = nvc
        
//        slideMenuController.delegate = mainViewController
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
}

