//
//  SBPlayerListVC.swift
//  who
//
//  Created by chenzilu on 16/7/12.
//  Copyright © 2016年 chenzilu. All rights reserved.
//

import UIKit

let ScreenFrame = UIScreen.main.bounds

let ID = "playerCell"

let APPCache = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first


let playerPath = (APPCache)! + "/player.plist"



class SBPlayerListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SBPlayerVCDelegate {

    @IBOutlet weak var noteLabel: UILabel! {
        
        didSet {
            if players.count > 2 {
                noteLabel.isHidden = true
            }
        }
        
    }
    
    
    lazy var players : [SBPlayer] = {
    
        let arr = NSKeyedUnarchiver.unarchiveObject(withFile: playerPath)
        
        if let players = arr {
            
            return players as! [SBPlayer]
        } else {
            return [SBPlayer]()
        }
        
    
    }()
    
    lazy var selPlayers = [SBPlayer]()
    
    lazy var addItem : UIBarButtonItem? = {
    
        let item = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(SBPlayerListVC.addItemDidClick))
        return item
        
       
        
    }()
    
    lazy var editItem : UIBarButtonItem = {
        
        let item = UIBarButtonItem.init(title: "选择", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SBPlayerListVC.editItemDidClick))
        return item
        
    }()
    
    lazy var starItem : UIBarButtonItem = {
       
        let item = UIBarButtonItem.init(title: "开始游戏", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SBPlayerListVC.starItemDidClick))
        
        return item
    }()
    
    
    lazy var tableView : UITableView = {
       
        let tableView = UITableView.init(frame: ScreenFrame, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ID)
        tableView.rowHeight = 80;
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        func setupNavBar() {
            navigationController?.navigationBar.tintColor = UIColor.red
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
            
            navigationController?.toolbar.tintColor = UIColor.red
            
            let item = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            
            toolbarItems = [item, starItem, item]
            
        }
        setupTooBar()
        
        setEditing(false, animated: false)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEditing(false, animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
//            tableView.isEditing = editing
        tableView.setEditing(editing, animated: true)
        if editing == true {
            
            starItem.isEnabled = false
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
        
        
        present(nav, animated: true, completion: nil)
        
        
    }
    
    func editItemDidClick() {
        
        if editItem.title == "完成" {
            setEditing(false, animated: true)
        } else {
            
            setEditing(!isEditing, animated: true)
        }
        
    }
    
    func starItemDidClick() {
        
        let vc = SBGameSetVC.init()
        vc.players = selPlayers
        
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.pushViewController(vc, animated: true)
        
             
    }
    
    
//MARK: 代理
    
    func playerVCDidSavePlayer(_ name : String) {
        
        let player = SBPlayer.init(name: name, word: nil)
        players.append(player)
        NSKeyedArchiver.archiveRootObject(players, toFile: playerPath)
        func reloadData() {
            tableView .reloadData()
            if players.count > 2 {
                noteLabel.isHidden = true
                navigationItem.leftBarButtonItem = editItem
            } else {
                noteLabel.isHidden = false
                navigationItem.leftBarButtonItem = nil
            }
        }
        reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ID) {
            
            let player = players[(indexPath as NSIndexPath).row]
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 40)
            cell.textLabel?.text = player.name
            
            
            return cell
        } else {
            return UITableViewCell.init()
        }
         
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        players.remove(at: (indexPath as NSIndexPath).row)
        NSKeyedArchiver.archiveRootObject(players, toFile: playerPath)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
        
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        navigationItem.rightBarButtonItem = addItem
        if players.count > 2 {
            noteLabel.isHidden = true
            editItem.title = "选择"
            } else {
            noteLabel.isHidden = false
            navigationItem.leftBarButtonItem = nil
        }

    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        
        if tableView.isEditing == false {
            navigationItem.rightBarButtonItem = nil
            editItem.title = "完成"
            navigationItem.leftBarButtonItem = editItem

            return UITableViewCellEditingStyle.delete
        } else {
            return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.delete.rawValue | UITableViewCellEditingStyle.insert.rawValue)!

        }
        
        
        
    }
    
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        selPlayers.append(players[(indexPath as NSIndexPath).row])
        if selPlayers.count > 2 {
            starItem.isEnabled = true
        } else {
            starItem.isEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        selPlayers.remove(at: selPlayers.index(of: players[(indexPath as NSIndexPath).row])!)
        
        if selPlayers.count > 2 {
            starItem.isEnabled = true
        } else {
            starItem.isEnabled = false
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
