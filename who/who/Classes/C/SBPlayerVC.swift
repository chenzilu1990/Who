//
//  SBPlayerVC.swift
//  who
//
//  Created by chenzilu on 16/7/16.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit


@objc   protocol SBPlayerVCDelegate : NSObjectProtocol {
    
    func playerVCDidSavePlayer(name : String)
}

class SBPlayerVC: UIViewController {
    
    var delegate : SBPlayerVCDelegate?
    
    var players : [SBPlayer]?
    
    @IBOutlet weak var playerName: UITextField!
    
    
    func cancleItemDidClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    lazy var cancleItem : UIBarButtonItem = {
        let item = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SBPlayerVC.cancleItemDidClick))
        return item
    }()
    
    
    lazy var saveItem : UIBarButtonItem = {
    
        let item = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(SBPlayerVC.saveItemDidClick))
        return item
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        func setupNavBar() {
            navigationController?.navigationBar.tintColor = UIColor.redColor()
            navigationItem.leftBarButtonItem = cancleItem
            navigationItem.rightBarButtonItem = saveItem
        }
        setupNavBar()
        
    }

    
    
    
    
    func saveItemDidClick() {
        
        func nameIsRepeat() -> Bool {
                     
            if let playersE = players {
                let arr = playersE as NSArray
                let nameArr = arr.valueForKey("name")
                if nameArr.containsObject(playerName.text) {
                    return true
                } else {
                    return false
                }
                
            }
            return false
            
        }
        if nameIsRepeat() == true {
            
         let alert = UIAlertView.init(title: "玩家已经存在", message: nil, delegate: nil, cancelButtonTitle: nil)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(800 * NSEC_PER_MSEC)), dispatch_get_main_queue(), {
                alert.dismissWithClickedButtonIndex(0, animated: true)
            })
            
            alert.show()
            return
        } else {
            delegate?.playerVCDidSavePlayer(playerName.text!)
            
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
