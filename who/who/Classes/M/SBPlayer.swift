//
//  SBPalyer.swift
//  who
//
//  Created by chenzilu on 16/7/16.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit

class SBPlayer: NSObject,NSCoding {

    var name : String?
    var word : String?
    var isWD : Bool?
    var isRead : Bool?
 
    init(name : String?, word : String?) {
        self.name = name
        self.word = word
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(word, forKey: "word")
        if let iswd = isWD {
            aCoder.encodeBool(iswd, forKey: "isWD")
        }
        
        if let isread = isRead {
            aCoder.encodeBool(isread, forKey: "isRead")
        }
//        aCoder.encodeBool(isWD!, forKey: "isWD")
//        aCoder.encodeBool(isRead!, forKey: "isRead")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as? String
        word = aDecoder.decodeObjectForKey("word") as? String
        isWD = aDecoder.decodeBoolForKey("isWD")
        isRead = aDecoder.decodeBoolForKey("isRead")
        super.init()
        
    }
    
}
