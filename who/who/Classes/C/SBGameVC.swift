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
    
    var playerNames : [String]?
    
    var players = [SBPlayer]()
    var wodiCount : Int?
     
    var curPlayers : [SBPlayer]?
    var isGameOver : Bool?
    
        
    lazy var WDPlayers = [SBPlayer]()
    lazy var PMPlayers = [SBPlayer]()
    lazy var audioPlayer = SBAudioPlayer()
    lazy var outPlayerIndex = IndexPath()
    
    var words : [[String : String]]{
        
        func getWords() -> NSArray? {
            let path1 = Bundle.main.bundlePath
            let path2 = path1 + "/word130.plist"
            
            return NSArray.init(contentsOfFile: path2)
        }
        
        
        return getWords() as! [[String : String]]
        
    }
    
    lazy var refreshItem : UIBarButtonItem = {
       
        let item = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(SBGameVC.gameRefresh))
        return item
        
    }()
        
        
        

    

//    MARK: 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setupTableView() {
            tableView.register(UINib.init(nibName: "SBGameCell", bundle: Bundle.main), forCellReuseIdentifier: ID)
            tableView.tableFooterView = UIView.init()
            tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
            
        }
        func setupNavBar() {
            navigationItem.title = "谁是卧底"
            navigationItem.rightBarButtonItem = refreshItem
        }

        setupTableView()
        setupNavBar()
        
        for obj in playerNames! {
            let player = SBPlayer.init(name: obj, word: nil)
            players.append(player)
            
        }
        
        
        
        gameRefresh()
        
    }
    
    
    
    
    func gameRefresh() {
        WDPlayers.removeAll()
        PMPlayers.removeAll()
        isGameOver = false
        
        let a = Int(arc4random_uniform(UInt32(words.count)))
        
        let arr = SBRandom().randomWithRange(players.count, count: wodiCount!)
        
        
        let dic = words[a]
        
        for (idx , player) in (players.enumerated()) {
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            alert.dismiss(withClickedButtonIndex: 0, animated: true)
        }
        
        alert.show()
        curPlayers = players
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = curPlayers?.count {
            return count
        } else {
            return 0
        }
        
       
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playerCell = tableView.dequeueReusableCell(withIdentifier: ID) as! SBGameCell
        
        playerCell.player = curPlayers![(indexPath as NSIndexPath).row]
        
        
        return playerCell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = curPlayers![(indexPath as NSIndexPath).row]
        player.isRead = true
        let vc = SBWordDisplayVC()
        vc.navigationItem.title = player.name
        vc.word = player.word
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "处死"
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        outPlayerIndex = indexPath
        
        func pandunWithIndex(_ indexPath : IndexPath) {
            let player = curPlayers![(indexPath as NSIndexPath).row]
            curPlayers?.remove(at: (curPlayers?.index(of: player))!)
            
            if (player.isWD)! == true {
                WDPlayers.remove(at: (WDPlayers.index(of: player))!)
                
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
                
                PMPlayers.remove(at: (PMPlayers.index(of: player))!)
                
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
    
  
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if isGameOver == true {
            if buttonIndex == 0 {
                gameRefresh()
            } else {
                navigationController?.popViewController(animated: true)
            }
        } else {
            
            tableView.deleteRows(at: [outPlayerIndex], with: UITableViewRowAnimation.top)
            
            audioPlayer.stop()
            
        }
    }
    
    
    
    
    
}


class SBGameCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var msgBtn: SBCircleBtn!
    
    
    var player : SBPlayer? {
        
        
        get{
            return self.player
        }
        
        
        set{
            
            func setupPlayer() {
                nameLabel.text = newValue?.name
                msgBtn.isHidden = (newValue?.isRead)!
            }
            
            setupPlayer()
            
            
            
        }
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    
    
}

