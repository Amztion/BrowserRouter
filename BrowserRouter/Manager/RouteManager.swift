//
//  RouteManager.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/10/25.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

class RouteManager: NSObject {
    static let shared = RouteManager()
    var routes: [Route] {
        return _routes
    }
    
    private var _routes = Route.emptyList
    
    func add(_ route: Route) {
        add(route, at: _routes.count)
    }
    
    func add(_ route: Route, at index: Int) {
        guard self.index(of: route) == nil else {
            print("The route has already been exist.")
            return
        }
        
        guard _routes.count - 1 <= index else{
            print("")
            return
        }
        
        _routes.insert(route, at: index)
    }
    
    func remove(_ route: Route) throws {
        if let index = index(of: route) {
            try remove(at: index)
        } else {
            //TODO: Throws Error
        }
    }
    
    func remove(at index: Int) throws {
        guard index < _routes.count else {
            // TODO: Throws Error
            return
        }
        
        _routes.remove(at: index)
    }
    
    func replace(_ route: Route, at index: Int) throws {
        try remove(at: index)
        add(route, at: index)
    }
    
    func index(of route: Route) -> Int? {
        return _routes.index {$0 == route}
    }
    
    func matched(with url: String) -> Route? {
        return _routes.filter{$0.match(url)}.first
    }
}
