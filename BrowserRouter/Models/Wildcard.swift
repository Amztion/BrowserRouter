//
//  Wildcard.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/6/30.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

struct Wildcard {
    let url: String
    private let regex: Regex
    private let charactersMap = [
        "/": "\\/",
        ".": "\\.",
        "?": "\\?"
    ]
    
    static let emptyList = [Wildcard]()
    
    init?(url: String) {
        self.url = url
        
        var replacedUrl = url
        
        for key in self.charactersMap.keys {
            guard let replacedChar = self.charactersMap[key] else {
                continue
            }
            
            replacedUrl = replacedUrl.replacingOccurrences(of: key, with: replacedChar)
        }
        
        replacedUrl = replacedUrl.replacingOccurrences(of: "*", with: "[^ ]*")
        
        print(url)
        print(replacedUrl)
        
        guard let rege = Regex(pattern: replacedUrl) else {
            return nil
        }
        
        regex = rege
    }
    
    func match(_ url: String) -> Bool {
        return self.regex.match(url)
    }
}
