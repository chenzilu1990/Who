//
//  SBAudioPlayer.swift
//  who
//
//  Created by chenzilu on 16/7/16.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit
import AVFoundation

class SBAudioPlayer: NSObject {

    var curAudio : AVAudioPlayer?
    
    func playerWithName(name : String) {
        
        let url = NSBundle.mainBundle().URLForResource(name, withExtension: nil)
        
        if let urlE = url {
            
            do{
                let audio = try AVAudioPlayer.init(contentsOfURL: urlE)
                
                audio.enableRate = true
                audio.prepareToPlay()
                audio.play()
                curAudio = audio
            } catch {
                print(error)
            }
         
        }
        
        
        
    }
    
    
    func stop() {
        curAudio?.stop()
    }
    
    
    
    
    
    
    
    
}
