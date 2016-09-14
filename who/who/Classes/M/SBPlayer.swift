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
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: "name")
        aCoder.encode(word, forKey: "word")
        if let iswd = isWD {
            aCoder.encode(iswd, forKey: "isWD")
        }
        
        if let isread = isRead {
            aCoder.encode(isread, forKey: "isRead")
        }
//        aCoder.encodeBool(isWD!, forKey: "isWD")
//        aCoder.encodeBool(isRead!, forKey: "isRead")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        word = aDecoder.decodeObject(forKey: "word") as? String
        isWD = aDecoder.decodeBool(forKey: "isWD")
        isRead = aDecoder.decodeBool(forKey: "isRead")
        super.init()
        
    }
    
}
