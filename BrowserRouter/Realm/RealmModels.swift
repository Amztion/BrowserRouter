//
//  RealmModels.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2018/1/10.
//  Copyright © 2018年 Liang Zhao. All rights reserved.
//

import Cocoa
import RealmSwift
import Realm

class PatternModel: Object {
    @objc dynamic var url: String!
    
    init(pattern: Pattern) {
        url = pattern.url
        
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

class RouteModel: Object {
    @objc dynamic var identifier: String!
    @objc dynamic var browserIdentifier: String!
    
    let patterns = List<PatternModel>()
    
    init(route: Route) {
        identifier = route.identifier.uuidString
        patterns.append(objectsIn:
            route.patterns.map{
                return PatternModel(pattern: $0)
            }
        )
        browserIdentifier = route.browser.identifier
        
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

extension Route {
    init(model: RouteModel) {
        if let uuid = UUID(uuidString: model.identifier) {
            self.identifier = uuid
        } else {
            self.identifier = UUID()
        }
        
        self.browser = Browser.browser(identifier: model.browserIdentifier) ?? Browser.default
        self.patterns = model.patterns.map{Pattern(model: $0)!}
    }
}

extension Pattern {
    init?(model: PatternModel) {
        self.init(url: model.url)
    }
}
