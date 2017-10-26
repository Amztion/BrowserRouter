//
//  RouteManager.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/25.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

class RouteManager: NSObject {
    private static let sharedInstance = RouteManager()
    
    var routes = [Route]()
    
    class func shared() -> RouteManager {
        return sharedInstance
    }
    
    func add(_ route: Route) {
        routes.append(route)
    }
    
    func remove(_ route: Route) throws {
        if let index = routes.index(where: {$0.identifier() == route.identifier()}) {
            routes.remove(at: index)
        } else {
            //TODO: Throws Error
        }
    }
    
    
    func matched(with url: String) -> Route? {
        return routes.filter{$0.match(url)}.first
    }
}
