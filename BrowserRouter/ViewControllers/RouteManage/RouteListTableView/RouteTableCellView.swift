//
//  RouteTableCellView.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/29.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

class RouteTableCellView: NSTableCellView {
    
    func set(item: RouteTableItem) {
        imageView?.image = item.image
        textField?.stringValue = item.title
    }
}

struct RouteTableItem {
    var image: NSImage?
    var title: String
    
    init(route: Route) {
        image = route.browser.icon
        title = route.browser.name
    }
}
