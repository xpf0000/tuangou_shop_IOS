//
//  ViewController.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Cartography
import SwiftyJSON
import Kingfisher

class HomeVC: UIViewController {
    
    
    @IBAction func to_scan(_ sender: Any) {
        
        
    }
    
    
    @IBAction func to_input(_ sender: Any) {
    }
    
    @IBAction func to_history(_ sender: Any) {
    }
    
    
    @IBAction func to_order(_ sender: Any) {
        
        let vc = OrderListVC()
        self.show(vc, sender: nil)
        
    }
    
    
    @IBAction func to_dp(_ sender: Any) {
        
        let vc = CommentListVC()
        self.show(vc, sender: nil)
        
    }
    
    @IBAction func to_caiwu(_ sender: Any) {
    }
    
    @IBAction func to_account(_ sender: Any) {
        
        let vc = "BankInfoVC".VC(name: "Main")
        self.show(vc, sender: nil)
    }
    
    @IBAction func to_tx(_ sender: Any) {
        
        let vc = "TixianVC".VC(name: "Main")
        self.show(vc, sender: nil)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(onTimeOut), name: NSNotification.Name(rawValue: "UserTimeOut"), object: nil)
        
        self.title = DataCache.Share.User.name
        
        let button=UIButton(type: UIButtonType.custom)
        button.frame=CGRect(x: 0, y: 0, width: 24, height: 24);
        button.setBackgroundImage("setup.png".image(), for: UIControlState())
        button.isExclusiveTouch = true
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        button.click {[weak self] (btn) in
            
            let vc = "APPSetupVC".VC(name: "Main")
            
            self?.show(vc, sender: nil)
        
        }
        
        
    }
    
    func onTimeOut()
    {
        XAlertView.show("用户登录已过期，请重新登录") { [weak self] in
            self?.pop()
        }
    }
    
    func dodeinit()
    {
        
   
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
        print("HomeVC deinit !!!!!!!!!!!!!!!!")
    }
    
    
    
}

