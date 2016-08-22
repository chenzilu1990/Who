//
//  SBGameCell.swift
//  who
//
//  Created by chenzilu on 16/7/16.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit

class SBGameCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var msgBtn: SBCircleBtn!
    
    
    var player : SBPlayer? {
        
        
        get{
            return self.player
        }
        
        
        set{
            
            nameLabel.text = newValue?.name
            msgBtn.hidden = (newValue?.isRead)!
            


        }
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    
    
}
