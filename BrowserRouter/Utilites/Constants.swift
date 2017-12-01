//
//  Constants.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/28.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

extension URL {
    struct Scheme {
        static let http = "http"
        static let https = "https"
    }
}

extension Browser {
    struct Identifier {
        static let safari = "com.apple.Safari"
        static let chrome = "com.google.Chrome"
    }
}

extension RouteTableCellView {
    struct CellViewIdentifier {
        static let RouteList = "RouteList"
    }
}

extension RouteContentListTableCellView {
    struct CellViewIdentifier {
        static let RouteList = "RouteList"
    }
}
