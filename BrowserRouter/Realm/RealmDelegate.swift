//
//  RealmDelegate.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2018/1/11.
//  Copyright © 2018年 Liang Zhao. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDelegate {
    static let shared = RealmDelegate()
    
    private let databaseQueue = DispatchQueue(label: "DatabaseQueue")
    private var loaded = false
    private var results: Results<RouteModel>?
    
    func load(completion:@escaping ((Bool, [RouteModel])->Void)) {
        databaseQueue.async {
            let realm = try? Realm()
            
            guard self.loaded == false else {
                guard let results = self.results else {
                    completion(false, [RouteModel]())
                    return
                }
                
                completion(true, Array(results))
                return
            }
            
            guard let results = realm?.objects(RouteModel.self) else {
                completion(false, [RouteModel]())
                return
            }
            
            completion(true, Array(results))
            self.loaded = true
        }
    }
    
    func save(route: Route, at index: Int) {
        databaseQueue.async {
            let realm = try? Realm()
            try! realm?.write {
                realm?.add(RouteModel(route: route))
            }
        }
    }
    
    func fetchRoute() {
        
    }
}
