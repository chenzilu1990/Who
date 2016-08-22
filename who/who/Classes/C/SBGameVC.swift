//
//  SBGameVC.swift
//  who
//
//  Created by chenzilu on 16/7/16.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit

class SBGameVC: UITableViewController, UIAlertViewDelegate, SBWordDisplayVCDelegate {
    
    let rowHeight = 80
    let ID = "playerCell"
    
    var players : [SBPlayer]?
    var wodiCount : Int?
     
    var curPlayers : [SBPlayer]?
    var isGameOver : Bool?
    
        
    lazy var WDPlayers = [SBPlayer]()
    lazy var PMPlayers = [SBPlayer]()
    lazy var audioPlayer = SBAudioPlayer()
    lazy var outPlayerIndex = NSIndexPath()
    
    var words : [[String : String]]{
        
        func getWords() -> NSArray? {
            let path1 = NSBundle.mainBundle().bundlePath
            let path2 = path1.stringByAppendingString("/word130.plist")
            
            return NSArray.init(contentsOfFile: path2)
        }
        
        
        return getWords() as! [[String : String]]
        
    }
    
    lazy var refreshItem : UIBarButtonItem = {
       
        let item = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(SBGameVC.gameRefresh))
        return item
        
    }()
        
        
        

    

//    MARK: 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setupTableView() {
            tableView.registerNib(UINib.init(nibName: "SBGameCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: ID)
            tableView.tableFooterView = UIView.init()
            tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
            
        }
        func setupNavBar() {
            navigationItem.title = "谁是卧底"
            navigationItem.rightBarButtonItem = refreshItem
        }

        setupTableView()
        setupNavBar()
        gameRefresh()
        
    }
    
    
    
    
    func gameRefresh() {
        WDPlayers.removeAll()
        PMPlayers.removeAll()
        isGameOver = false
        
        let a = Int(arc4random_uniform(UInt32(words.count)))
        
        let arr = SBRandom().randomWithRange(players!.count, count: wodiCount!)
        
        
        let dic = words[a]
        
        for (idx , player) in (players?.enumerate())! {
            if arr.contains(idx) {
                player.word = dic["WD"]
                player.isWD = true
                WDPlayers.append(player)
            } else {
                player.word = dic["PM"]
                player.isWD = false
                PMPlayers.append(player)
            }
            player.isRead = false
            
        }
        
        
        let alert = UIAlertView.init(title: "更新词汇...", message: nil, delegate: nil, cancelButtonTitle: nil)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            alert.dismissWithClickedButtonIndex(0, animated: true)
        }
        
        alert.show()
        curPlayers = players
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = curPlayers?.count {
            return count
        } else {
            return 0
        }
        
       
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let playerCell = tableView.dequeueReusableCellWithIdentifier(ID) as! SBGameCell
        
        playerCell.player = curPlayers![indexPath.row]
        
        
        return playerCell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let player = curPlayers![indexPath.row]
        player.isRead = true
        let vc = SBWordDisplayVC()
        vc.navigationItem.title = player.name
        vc.word = player.word
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "处死"
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        outPlayerIndex = indexPath
        
        func pandunWithIndex(indexPath : NSIndexPath) {
            let player = curPlayers![indexPath.row]
            curPlayers?.removeAtIndex((curPlayers?.indexOf(player))!)
            
            if (player.isWD)! == true {
                WDPlayers.removeAtIndex((WDPlayers.indexOf(player))!)
                
                if WDPlayers.count == 0 {
                    isGameOver = true
                    
                    let alert = UIAlertView.init(title: "平民胜利", message: "", delegate: self, cancelButtonTitle: "再来一局", otherButtonTitles: "重新设定")
                    
                    alert.show()
                    
                } else {
                    
                    audioPlayer.playerWithName("欢沁.wav")
                    
                    let alert = UIAlertView.init(title: "终于捉到卧底了", message: nil, delegate: self, cancelButtonTitle: "去死吧,卧底")
                    alert.show()
                    
                }
                
                
                
            } else {
                
                PMPlayers.removeAtIndex((PMPlayers.indexOf(player))!)
                
                if PMPlayers.count == WDPlayers.count {
                    isGameOver = true
                    
                    let alert = UIAlertView.init(title: "卧底胜利", message: "", delegate: self, cancelButtonTitle: "再来一局", otherButtonTitles: "重新设定")
                    
                    alert.show()
                } else {
                    
                    audioPlayer.playerWithName("再见警察.wav")
                    
                    let alert = UIAlertView.init(title: "这世上又少了一个好人", message: nil, delegate: self, cancelButtonTitle: "再见,平民")
                    alert.show()
                    
                }
                
            }
            
            
        }
        pandunWithIndex(indexPath)
    }
    
    
    
    
    func wordDisplayDidRemeberPlayer() {
        tableView.reloadData()
    }
    
  
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if isGameOver == true {
            if buttonIndex == 0 {
                gameRefresh()
            } else {
                navigationController?.popViewControllerAnimated(true)
            }
        } else {
            
            tableView.deleteRowsAtIndexPaths([outPlayerIndex], withRowAnimation: UITableViewRowAnimation.Top)
            
            audioPlayer.stop()
            
        }
    }
    
    
    
    
    
}