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
        guard index(of: route) == nil else {
            print("The route has already been exist.")
            return;
        }
        
        routes.append(route)
    }
    
    func remove(_ route: Route) throws {
        if let index = index(of: route) {
            routes.remove(at: index)
        } else {
            //TODO: Throws Error
        }
    }
    
    func index(of route: Route) -> Int? {
        return routes.index {$0 == route}
    }
    
    func matched(with url: String) -> Route? {
        return routes.filter{$0.match(url)}.first
    }
}
