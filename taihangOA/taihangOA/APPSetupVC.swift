//
//  APPSetupVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Kingfisher

class APPSetupVC: UITableViewController,UIAlertViewDelegate {

    let logoutAlert = UIAlertView()
    
    @IBOutlet weak var caches: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    
    
    @IBAction func btn_click(_ sender: Any) {
        
        logoutAlert.delegate = self
        logoutAlert.title = "注销登录"
        logoutAlert.message = "确定要登出账户吗?"
        logoutAlert.addButton(withTitle: "取消")
        logoutAlert.addButton(withTitle: "确定")
        logoutAlert.show()
        
    }
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1
        {
            
            DataCache.Share.User = UserModel()
            DataCache.Share.User.save()
            
            Api.user_logout(block: { (str) in
  
            })
            
            let vc = "LoginVC".VC(name: "Main")

            let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            app.window?.rootViewController = vc
            app.window?.makeKeyAndVisible()
            
        }
        
        
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "设置"
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       if indexPath.row == 2
       {
        
            KingfisherManager.shared.cache.clearDiskCache()
            caches.text = "0.0MB"
        
        }
        else if indexPath.row == 4
       {
            let vc = "AboutVC".VC(name: "Main")
            self.show(vc, sender: nil)
        }
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.separatorInset=UIEdgeInsetsMake(0, SW, 0, 0)
        cell.layoutMargins=UIEdgeInsetsMake(0, SW, 0, 0)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        tableView.separatorInset=UIEdgeInsets.zero
        tableView.layoutMargins=UIEdgeInsets.zero
        
    }
    
    func initUI()
    {
        let size = KingfisherManager.shared.cache.diskCachePath.CachesSize()
        
        caches.text = String(format: "%.2fM", size/1024.0/1024.0)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
}
