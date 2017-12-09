//
//  Regex.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/6/30.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

struct Regex {
    private let regularExpression: NSRegularExpression
    
    init?(pattern: String) {
        
        guard let regularExpression = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines) else {
            return nil
        }
        
        self.regularExpression = regularExpression
    }
    
    func match(_ pattern: String) -> Bool {
        return self.regularExpression.matches(in: pattern, options: .anchored, range: NSRange(location: 0, length: pattern.count)).count > 0
    }
}

