//
//  SBGameSetVC.swift
//  who
//
//  Created by chenzilu on 16/7/16.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit

class SBGameSetVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var underPicker: UIPickerView!
    
    var players : [String]?
    var wodiCount : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        func setupNavBar() {
            navigationItem.title = "游戏设定"
        }
        
        func setupPicker() {
            underPicker.delegate = self
            underPicker.dataSource = self
        }
        
        func setupUI() {
            setupNavBar()
            setupPicker()
        }
       
        setupUI()
        
        wodiCount = 1
    }

    
    //MARK: delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (players!.count - 1) / 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(row + 1) "
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        wodiCount = row + 1
    }
    
    @IBAction func starBtnDidClick(_ sender: AnyObject) {
        
        let vc = SBGameVC()
        
        vc.players = players
        vc.wodiCount = wodiCount
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    
    
    
}
