//
//  LoginVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/16.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class LoginVC: UITableViewController {

    @IBOutlet weak var account: UITextField!
    
    @IBOutlet weak var pass: UITextField!
    
    @IBAction func do_login(_ sender: Any) {
        
        if !account.checkNull() || !pass.checkNull()
        {
            return
        }
        
        if !pass.checkLength("密码", min: 6, max: 24)
        {
            return
        }
        
        Api.dologin(account_name: account.text!.trim(), account_password: pass.text!.trim()) { [weak self](user) in
            
            
            DataCache.Share.User = user
            DataCache.Share.User.save()
            
            self?.to_main()
            
        }
        
        
        
    }
    
    func to_main()
    {
        
        let home = "HomeVC".VC(name: "Main")
        let nv = XNavigationController.init(rootViewController: home)
        
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.window?.rootViewController = nv
        app.window?.makeKeyAndVisible()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        account.addEndButton()
        pass.addEndButton()
        
        if DataCache.Share.User.id != ""
        {
            to_main()
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 ||  indexPath.row == 2
        {
            cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15)
            cell.layoutMargins=UIEdgeInsetsMake(0, 15, 0, 15)
        }
        else
        {
            cell.separatorInset=UIEdgeInsetsMake(0, SW, 0, 0)
            cell.layoutMargins=UIEdgeInsetsMake(0, SW, 0, 0)
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        tableView.separatorInset=UIEdgeInsets.zero
        tableView.layoutMargins=UIEdgeInsets.zero
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    deinit {
        
        print("LoginVC deinit !!!!!!!!!!!!!!!!")
        
    }

    
}
