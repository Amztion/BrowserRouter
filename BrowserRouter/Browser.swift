//
//  Browser.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/6/3.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

struct Browser {
    public let identifier: String
    public let bundle: Bundle
    public var icon: NSImage?
    public var name: String!
    
    init(bundle: Bundle, identifier: String) {
        self.identifier = identifier
        self.bundle = bundle
    }
    
    func open(_ url: String) {
        NSWorkspace.shared().open([URL(string: url)!], withAppBundleIdentifier: identifier, options: [], additionalEventParamDescriptor: nil, launchIdentifiers: nil)
    }
}
