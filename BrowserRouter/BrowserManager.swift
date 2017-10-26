//
//  BrowserManager.swift
//  BrowserManager
//
//  Created by Liang Zhao on 2017/5/26.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

class BrowserManager {
    private static let sharedInstance = BrowserManager()
    
    class func shared() -> BrowserManager {
        return sharedInstance
    }
    
    var all = { () -> [Browser] in
        let handlers = LSCopyAllHandlersForURLScheme("http" as CFString)?.takeRetainedValue()
        
        var browsers = [Browser]()
        for index in 0..<CFArrayGetCount(handlers) {
            let handlerIdentifier = unsafeBitCast(CFArrayGetValueAtIndex(handlers, index), to: CFString.self) as String
            if let path = NSWorkspace.shared().absolutePathForApplication(withBundleIdentifier: handlerIdentifier) {
                if let bundle = Bundle(url: URL(fileURLWithPath: path)) {
                    var browser = Browser(bundle: bundle, identifier: handlerIdentifier)
                    browser.icon = NSWorkspace.shared().icon(forFile: path)
                    browser.name = (path as NSString).lastPathComponent
                    browsers.append(browser)
                }
            }
        }
        
        return browsers
    }()
    
    var `default`: Browser!
}
