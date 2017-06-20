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
    
    static public func allInstalledBrowsers() -> [Bundle] {
        let handlers = LSCopyAllHandlersForURLScheme("http" as CFString)?.takeRetainedValue()
        
        var bundles = [Bundle]()
        for index in 0..<CFArrayGetCount(handlers) {
            let handlerIdentifier = unsafeBitCast(CFArrayGetValueAtIndex(handlers, index), to: CFString.self) as String
            if let path = NSWorkspace.shared().absolutePathForApplication(withBundleIdentifier: handlerIdentifier) {
                if let bundle = Bundle(path: path) {
                    bundles.append(bundle)
                }
            }
        }
        
        return bundles
    }
}
