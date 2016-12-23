//
//  AppDelegate.swift
//  DigiDocs
//
//  Created by Lee Arromba on 21/12/2016.
//  Copyright © 2016 Pink Chicken Ltd. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
            debugPrint("DEBUG BUILD")
        #endif
        
        Fabric.with([Crashlytics.self])
        
        do {
            try Analytics.shared.setup()
        } catch _ {
            debugPrint("Analytics setup failed")
        }
        Analytics.shared.startSession()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Analytics.shared.endSession()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Analytics.shared.startSession()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
