//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Isaac Olmedo on 07/08/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let rootViewController = MapModule.build()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
}

