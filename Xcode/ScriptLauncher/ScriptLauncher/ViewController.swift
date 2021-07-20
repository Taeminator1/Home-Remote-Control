//
//  ViewController.swift
//  ScriptLauncher
//
//  Created by Taemin Yun on 7/21/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if let path = Bundle.main.path(forResource: "test", ofType: "txt") {
//            NSWorkspace.shared.openFile(path, withApplication: "TextEdit")
//        }
        
        if let path = Bundle.main.path(forResource: "script", ofType: "command") {
            NSWorkspace.shared.openFile(path, withApplication: "Terminal")
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

