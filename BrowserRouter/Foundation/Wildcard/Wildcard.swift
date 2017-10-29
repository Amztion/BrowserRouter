//
//  Wildcard.swift
//  BrowserRouter
//
//  Created by Liang Zhao on 2017/6/30.
//  Copyright © 2017年 Liang Zhao. All rights reserved.
//

import Cocoa

struct Wildcard {
    private let url: String
    let regex: Regex
    let charactersMap = [
        "/": "\\/",
        ".": "\\.",
        "?": "\\?"
    ]
    
    init?(url: String) {
        print(url)
        
        var replacedUrl = url
        
        for key in self.charactersMap.keys {
            if let replacedChar = self.charactersMap[key] {
                replacedUrl = replacedUrl.replacingOccurrences(of: key, with: replacedChar)
            }
        }
        
        replacedUrl = replacedUrl.replacingOccurrences(of: "*", with: "[^ ]*")
        
        print(replacedUrl)
        self.url = replacedUrl
        
        if let rege = Regex(pattern: replacedUrl) {
            self.regex = rege
        } else {
            return nil
        }
    }
    
    func match(_ url: String) -> Bool {
        return self.regex.match(url)
    }
}
