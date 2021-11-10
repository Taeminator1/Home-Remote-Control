//
//  AppDelegate.swift
//  HRC
//
//  Created by 윤태민 on 9/30/21.
//

//  Decide view controller by using code:
//  - UINavigationViewController

import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let url: String = PersonalInfo.strURL        // "http://..."

    static let wkWebView = WKWebView()
    static let request: URLRequest = URLRequest.init(url: NSURL.init(string: AppDelegate.url)! as URL)
    
    var a: Int = 3
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
//        window?.rootViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navigationController

        navigationController.navigationBar.prefersLargeTitles = true
        
        return true
    }
}

