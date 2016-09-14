//
//  SBRandom.swift
//  who
//
//  Created by chenzilu on 16/7/16.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit

class SBRandom: NSObject {
    
    
    func randomWithRange( _ range : Int , count: Int) ->  Array <Int> {
        
        var rangeV = range
        var countV = count
        
        
        var result = [Int]()
        var arrM = [Int]()
        
        for index in 0...rangeV-1 {

            arrM.append(index)
            
        }
    
        
        while countV > 0 {
            let num = arc4random_uniform(UInt32(rangeV))
            result.append(arrM[Int(num)])
            arrM.remove(at: Int(num))
            rangeV -= 1
            countV -= 1
        }
        
        return result
        
    }
    
    
 
}
