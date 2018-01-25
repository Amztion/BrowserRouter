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

class WildcardModel: Object {
    @objc dynamic var url: String!
    
    init(wildcard: Wildcard) {
        url = wildcard.url
        
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
    
    let wildcards = List<WildcardModel>()
    
    init(route: Route) {
        identifier = route.identifier.uuidString
        wildcards.append(objectsIn:
            route.wildcards.map{
                return WildcardModel(wildcard: $0)
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
    init?(model: RouteModel) {
        guard let uuid = UUID(uuidString: model.identifier) else {
            return nil
        }
        
        self.identifier = uuid
        self.browser = Browser.browser(identifier: model.browserIdentifier) ?? Browser.default
        self.wildcards = model.wildcards.map{Wildcard(model: $0)!}
    }
}

extension Wildcard {
    init?(model: WildcardModel) {
        self.init(url: model.url)
    }
}
