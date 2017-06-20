//
//  RouteManager.swift
//  RouteManager
//
//  Created by Liang Zhao on 2017/6/3.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa
import JLRoutes

class RouteManager {
    private static let sharedInstance = RouteManager()
    
    class func shared() -> RouteManager {
        return sharedInstance
    }
    
    fileprivate let routes = JLRoutes(forScheme: JLRouteWildcardComponentsKey)
    fileprivate var routeMap = [String: Route]()
    
    fileprivate let operationQueue = DispatchQueue(label: "RouteOperation")
    
    func add(_ route: Route, handler: ((Browser?) -> Void)?) {
        operationQueue.async {
            self.routes.addRoute(route.link, handler: { (parameters) -> Bool in
                
                return true
            })
            
            self.routeMap[route.link] = route
        }
    }
    
    func remove(_ route: Route) {
        operationQueue.async {
            self.routes.removeRoute(route.link);
            self.routeMap[route.link] = nil
        }
    }

    func handle(link: String) {
        guard self.routes.canRouteURL(URL(string: link)) else {
            return
        }
    }
}
