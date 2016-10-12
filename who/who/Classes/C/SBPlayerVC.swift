//
//  SBPlayerVC.swift
//  who
//
//  Created by chenzilu on 16/7/16.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit


@objc   protocol SBPlayerVCDelegate : NSObjectProtocol {
    
    func playerVCDidSavePlayer(_ name : String)
}

class SBPlayerVC: UIViewController {
    
    var delegate : SBPlayerVCDelegate?
    
    var players : NSMutableArray?
    
    @IBOutlet weak var playerName: UITextField!
    
    
    func cancleItemDidClick() {

        if playerName.canResignFirstResponder {
            playerName.resignFirstResponder()
        }
        dismiss(animated: true, completion: nil)
    }
    
    lazy var cancleItem : UIBarButtonItem = {
        let item = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SBPlayerVC.cancleItemDidClick))
        return item
    }()
    
    
    lazy var saveItem : UIBarButtonItem = {
    
        let item = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action:#selector(SBPlayerVC.saveItemDidClick))
        return item
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        func setupNavBar() {
            navigationController?.navigationBar.tintColor = UIColor.red
            navigationItem.leftBarButtonItem = cancleItem
            navigationItem.rightBarButtonItem = saveItem
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        if playerName.canBecomeFirstResponder {
            playerName.becomeFirstResponder()
        }

        setupNavBar()
        
    }

    
    
    
    
    func saveItemDidClick() {
        playerName.resignFirstResponder()
        
        func nameIsRepeat() -> Bool {
                     
            if let playersE = players {
//                let arr = playersE
//                let nameArr = arr.value(forKey: "name") as! NSArray
                
                if (playersE.contains(playerName.text!)) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }

        }
            
        
        if nameIsRepeat() == true {
            
         let alert = UIAlertView.init(title: "玩家已经存在", message: nil, delegate: nil, cancelButtonTitle: nil)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(800 * NSEC_PER_MSEC)) / Double(NSEC_PER_SEC), execute: {
                alert.dismiss(withClickedButtonIndex: 0, animated: true)
            })
            
            alert.show()
            return
        } else {
            delegate?.playerVCDidSavePlayer(playerName.text!)
            
            dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
