//
//  RouteContentListTableCellView.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/11/8.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

struct RouteContentListItem {
    let content: String
}

class RouteContentTableCellView: NSTableCellView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func set(item: RouteContentListItem) {
        textField?.stringValue = item.content
    }
}
