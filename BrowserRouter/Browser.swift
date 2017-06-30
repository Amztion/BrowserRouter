//
//  Browser.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/6/3.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

class Browser {
    public let handler: CFString
    
    init(_ bundle: Bundle, handler: CFString) {
        self.handler = handler
    }
}
