//
//  RouteManager.swift
//  RouteManager
//
//  Created by Liang Zhao on 2017/6/3.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

class RouteManager {
    private static let sharedInstance = RouteManager()
    
    class func shared() -> RouteManager {
        return sharedInstance
    }
    
    fileprivate var routeMap = [String: Route]()
    
    fileprivate let operationQueue = DispatchQueue(label: "RouteOperation")
    
    func add(_ route: Route, handler: ((Browser?) -> Void)?) {

    }
    
    func remove(_ route: Route) {

    }

    func handle(link: String) {

    }
}
