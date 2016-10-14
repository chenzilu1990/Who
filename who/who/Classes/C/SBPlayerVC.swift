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

class SBPlayerVC: UIViewController,UITextFieldDelegate {
    
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
//            saveItem.isEnabled = false
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        if playerName.canBecomeFirstResponder {
            playerName.becomeFirstResponder()
        }

        setupNavBar()
        
    }

    
    
    
    
    func saveItemDidClick() {
//        playerName.resignFirstResponder()
        
        func nameIsRepeat() -> Bool {
                     
            if let playersE = players {
 
                
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
            if playerName.canResignFirstResponder {
                playerName.resignFirstResponder()
            }

            dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    
    //MARK: UITextFieldDelegate 
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return true
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let str = textField.text! as NSString
//        if str.length > 0{
//            saveItem.isEnabled = true
//        } else {
//            saveItem.isEnabled = false
//        }
//    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let str = textField.text! as NSString
//        
//        print(range.location)
//        
////        if (str.length + 1) > 0{
////            saveItem.isEnabled = true
////        } else {
////            saveItem.isEnabled = false
////        }
////        print(str.length)
//        return true
//    }
//    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        return true
//    }
//   
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("qw")
//    }
    
    
    
    
}
