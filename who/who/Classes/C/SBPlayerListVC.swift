//
//  SBPlayerListVC.swift
//  who
//
//  Created by chenzilu on 16/7/12.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit

let ScreenFrame = UIScreen.mainScreen().bounds

let ID = "playerCell"

let APPCache = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first


let playerPath = APPCache?.stringByAppendingString("/player.plist")



class SBPlayerListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SBPlayerVCDelegate {

    @IBOutlet weak var noteLabel: UILabel! {
        
        didSet {
            if players.count > 2 {
                noteLabel.hidden = true
            }
        }
        
    }
    
    
    lazy var players : [SBPlayer] = {
    
        let arr = NSKeyedUnarchiver.unarchiveObjectWithFile(playerPath!)
        
        if let players = arr {
            
            return players as! [SBPlayer]
        } else {
            return [SBPlayer]()
        }
        
    
    }()
    
    lazy var selPlayers = [SBPlayer]()
    
    lazy var addItem : UIBarButtonItem? = {
    
        let item = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(SBPlayerListVC.addItemDidClick))
        return item
        
       
        
    }()
    
    lazy var editItem : UIBarButtonItem = {
        
        let item = UIBarButtonItem.init(title: "选择", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SBPlayerListVC.editItemDidClick))
        return item
        
    }()
    
    lazy var starItem : UIBarButtonItem = {
       
        let item = UIBarButtonItem.init(title: "开始游戏", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SBPlayerListVC.starItemDidClick))
        
        return item
    }()
    
    
    lazy var tableView : UITableView = {
       
        let tableView = UITableView.init(frame: ScreenFrame, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ID)
        tableView.rowHeight = 80;
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        func setupNavBar() {
            navigationController?.navigationBar.tintColor = UIColor.redColor()
            navigationItem.title = "玩家"
            if players.count > 2 {
                
                navigationItem.leftBarButtonItem = editItem
            } else {
                navigationItem.leftBarButtonItem = nil
            }
            navigationItem.rightBarButtonItem = addItem
            
        }
        setupNavBar()
        
        func setupTooBar() {
            
            navigationController?.toolbar.tintColor = UIColor.redColor()
            
            let item = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            
            toolbarItems = [item, starItem, item]
            
        }
        setupTooBar()
        
        setEditing(false, animated: false)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setEditing(false, animated: false)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
            tableView.editing = editing
        if editing == true {
            
            starItem.enabled = false
            selPlayers.removeAll()

            navigationItem.rightBarButtonItem = nil

            editItem.title = "取消"
            tableView.contentInset = UIEdgeInsetsMake(64, 0, 45, 0)
        } else {
            navigationItem.rightBarButtonItem = addItem

            editItem.title = "选择"
            tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        }
        navigationController?.setToolbarHidden(!editing, animated: true)
    }
    
// MARK: 监听
    

    func addItemDidClick()  {
        
        
        let vc = SBPlayerVC.init()
        vc.delegate = self
        vc.players = players
        
        let nav = UINavigationController.init(rootViewController: vc)
        
        
        presentViewController(nav, animated: true, completion: nil)
        
        
    }
    
    func editItemDidClick() {
        
        if editItem.title == "完成" {
            setEditing(false, animated: true)
        } else {
            
            setEditing(!editing, animated: true)
        }
        
    }
    
    func starItemDidClick() {
        
        let vc = SBGameSetVC.init()
        vc.players = selPlayers
        
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.pushViewController(vc, animated: true)
        
             
    }
    
    
//MARK: 代理
    
    func playerVCDidSavePlayer(name : String) {
        
        let player = SBPlayer.init(name: name, word: nil)
        players.append(player)
        NSKeyedArchiver.archiveRootObject(players, toFile: playerPath!)
        func reloadData() {
            tableView .reloadData()
            if players.count > 2 {
                noteLabel.hidden = true
                navigationItem.leftBarButtonItem = editItem
            } else {
                noteLabel.hidden = false
                navigationItem.leftBarButtonItem = nil
            }
        }
        reloadData()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(ID) {
            
            let player = players[indexPath.row]
            
            cell.textLabel?.font = UIFont.systemFontOfSize(40)
            cell.textLabel?.text = player.name
            
            
            return cell
        } else {
            return UITableViewCell.init()
        }
         
        
    }
    
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        players.removeAtIndex(indexPath.row)
        NSKeyedArchiver.archiveRootObject(players, toFile: playerPath!)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        navigationItem.rightBarButtonItem = addItem
        if players.count > 2 {
            noteLabel.hidden = true
            editItem.title = "选择"
            } else {
            noteLabel.hidden = false
            navigationItem.leftBarButtonItem = nil
        }

    }
    
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        
        if tableView.editing == false {
            navigationItem.rightBarButtonItem = nil
            editItem.title = "完成"
            navigationItem.leftBarButtonItem = editItem

            return UITableViewCellEditingStyle.Delete
        } else {
            return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.Delete.rawValue | UITableViewCellEditingStyle.Insert.rawValue)!

        }
        
        
        
    }
    
    
 
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {


        selPlayers.append(players[indexPath.row])
        if selPlayers.count > 2 {
            starItem.enabled = true
        } else {
            starItem.enabled = false
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

        selPlayers.removeAtIndex(selPlayers.indexOf(players[indexPath.row])!)
        
        if selPlayers.count > 2 {
            starItem.enabled = true
        } else {
            starItem.enabled = false
        }
    }
    
    
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
