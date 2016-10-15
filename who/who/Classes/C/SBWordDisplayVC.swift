//
//  SBWordDisplayVC.swift
//  who
//
//  Created by chenzilu on 16/7/16.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit

protocol SBWordDisplayVCDelegate : NSObjectProtocol {
   func wordDisplayDidRemeberPlayer()
}


class SBWordDisplayVC: UIViewController {

    var word : String?
    
    
    @IBOutlet weak var wordLabel: UILabel!
    
    
    var delegate : SBWordDisplayVCDelegate?
    
    var leftItem : UIBarButtonItem = {
       
        let item = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        return item
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setupNavBar() {
            navigationItem.leftBarButtonItem = leftItem
        }
        setupNavBar()
        
        wordLabel.text = word
    }
    
    
    
    @IBAction func remeberBtnDidClick(_ sender: AnyObject) {
 
       navigationController?.popViewController(animated: true)
        
        delegate?.wordDisplayDidRemeberPlayer()
    }
 
    
    
    
}
