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
    
    func load(completion:((Bool, [Route])->Void)?) {
        RealmDelegate.shared.load { (success, routeModels) in
            guard let completion = completion else {
                return
            }
            
            self._routes = routeModels.map({ (routeModel) -> Route in
                return Route(model: routeModel)
            })
            
            completion(success, self._routes)
        }
    }
    
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
        RealmDelegate.shared.save(route: route, at: index)
    }
    
    func remove(_ route: Route) throws {
        guard let index = index(of: route) else {
            //TODO: Throws Error
            print("index of route is nil")
            return
        }
        
        try remove(at: index)
    }
    
    func remove(at index: Int) throws {
        guard index < _routes.count else {
            // TODO: Throws Error
            return
        }
        
        RealmDelegate.shared.remove(route: _routes[index])
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
