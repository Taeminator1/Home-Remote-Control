//
//  AppDelegate.swift
//  ScriptLauncher Launch
//
//  Created by 윤태민 on 7/23/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

import Cocoa

@main
class LaunchAppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == "com.Taeminator.ScriptLauncher"
        }
            
        if !isRunning {
            var path = Bundle.main.bundlePath as NSString
            for _ in 1...4 {
                path = path.deletingLastPathComponent as NSString
            }
            NSWorkspace.shared.launchApplication(path as String)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

