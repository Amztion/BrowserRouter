//
//  Browser.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/6/3.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

class Browser {
    public let handlerIdentifier: String
    public let bundle: Bundle
    public var icon: NSImage?
    public var name: String!
    
    init(bundle: Bundle, handlerIdentifier: String) {
        self.handlerIdentifier = handlerIdentifier
        self.bundle = bundle
    }
}
