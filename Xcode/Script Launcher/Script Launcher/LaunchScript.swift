//
//  LaunchScript.swift
//  ScriptLauncher
//
//  Created by 윤태민 on 7/24/21.
//  Copyright © 2021 Taemin Yun. All rights reserved.
//

//  Class for methods related with launching script:
//  - Update path

import Cocoa

class LaunchScript: NSMenuItem {
    func update(_ fileEditor: inout FileEditor, path: String? = nil) {
        self.isEnabled = path == nil ? false : true
        fileEditor.fileDirectory = path
    }
}
