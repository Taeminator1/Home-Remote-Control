//
//  AppDelegate.swift
//  ScriptLauncher
//
//  Created by Taemin Yun on 7/21/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var openAtLogin: NSMenuItem!
    
    let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let helperBundleName = "com.Taeminator.ScriptLauncher-Launch"       // for Opeing at Login
    var foundHelper: Bool = true                                        // for Opeing at Login
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: "MenubarIcon")
        icon?.isTemplate = true
        statusBar.button?.image = icon
        statusBar.menu = menu
        
        // 현재 실행중인 파일 중 helperBundleName이 있다면 true 반환
        foundHelper = NSWorkspace.shared.runningApplications.contains { $0.bundleIdentifier == helperBundleName }
        openAtLogin.state = foundHelper ? .on : .off
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func selectFileClicked(_ sender: Any) {
        print("Select File Clicked")
    }
    
    @IBAction func launchScriptClicked(_ sender: Any) {
        print("Launch Script Clicked")
    }
    
    @IBAction func openAtLoginClicked(_ sender: Any) {
        print("Open at Login Clicked")
        openAtLogin.state = openAtLogin.state == .on ? .off : .on
        SMLoginItemSetEnabled(helperBundleName as CFString, openAtLogin.state == .on)
    }
    
    @IBAction func quitClicked(_ sender: Any) {
        print("Quit Clicked")
        NSApplication.shared.terminate(self)
    }
    
    
    func makeScript(commands: String ...) -> String {
        return commands.reduce("") { $0 + $1 + "\n" }
    }
}

