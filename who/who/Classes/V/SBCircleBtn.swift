//
//  SBCircleBtn.swift
//  who
//
//  Created by chenzilu on 16/7/16.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit

class SBCircleBtn: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = bounds.size.width * 0.5
        super.awakeFromNib()
    }
}
