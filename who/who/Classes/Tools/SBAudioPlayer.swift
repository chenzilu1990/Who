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
    
    func playerWithName(_ name : String) {
        
        let url = Bundle.main.url(forResource: name, withExtension: nil)
        
        if let urlE = url {
            
            do{
                let audio = try AVAudioPlayer.init(contentsOf: urlE)
                
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
