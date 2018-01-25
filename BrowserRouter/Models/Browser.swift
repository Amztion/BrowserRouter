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
        icon = NSWorkspace.shared.icon(forFile: bundle.bundlePath)
        name = (bundle.bundlePath as NSString).lastPathComponent
    }
    
    func open(_ url: String) {
        NSWorkspace.shared.open([URL(string: url)!], withAppBundleIdentifier: identifier, options: [], additionalEventParamDescriptor: nil, launchIdentifiers: nil)
    }
}

extension Browser: Equatable {
    static func ==(lhs: Browser, rhs: Browser) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension Browser {
    public static var all = { () -> [Browser] in
        let handlers = LSCopyAllHandlersForURLScheme(URL.Scheme.http as CFString)?.takeRetainedValue()
        
        var browsers = [Browser]()
        for index in 0..<CFArrayGetCount(handlers) {
            let handlerIdentifier = unsafeBitCast(CFArrayGetValueAtIndex(handlers, index), to: CFString.self) as String
            
            guard let path = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: handlerIdentifier), let bundle = Bundle(url: URL(fileURLWithPath: path)) else {
                print("path of budnle not found for handler identifier \(handlerIdentifier)")
                continue
            }
            
            browsers.append(Browser(bundle: bundle, identifier: handlerIdentifier))
        }
        
        return browsers
    }()
    
    public static func browser(identifier: String) -> Browser? {
        return self.all.filter{return $0.identifier == identifier}.first
    }
    
    public static var `default`: Browser = safari ?? all.first! // Set Safari or the first one as default if there's no user setting.
}

extension Browser {
    public static var safari = browser(identifier: Identifier.safari)
    public static var chrome = browser(identifier: Identifier.chrome)
}
