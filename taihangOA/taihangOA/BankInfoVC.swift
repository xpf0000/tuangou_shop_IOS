//
//  BankInfoVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/16.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class BankInfoVC: UITableViewController {

    @IBOutlet weak var bname: UITextField!
    @IBOutlet weak var baccount: UITextField!
    @IBOutlet weak var uname: UITextField!
    @IBOutlet weak var code: UITextField!
    
    @IBOutlet weak var codebtn: UIButton!
    
    var timer:Timer?
    var timeModel:PostTimeModel = PostTimeModel()
    var surplusTime:Int = -1
    
    var model:BankModel=BankModel()
    {
        didSet
        {
            bname.text = model.bank_name
            baccount.text = model.bank_info
            uname.text = model.bank_user
        }
    }
    
    @IBAction func send_code(_ sender: UIButton) {
        
        XWaitingView.show()
        
        sender.isEnabled = false
        
        let p = DataCache.Share.User.mobile
        
        Api.sms_send_code(mobile: p) { [weak self](b) in
            if self == nil {return}
            XWaitingView.hide()
            sender.isEnabled = true
            
            if(b)
            {
                self?.timeModel.time = NSNumber.init(value: Date().timeIntervalSince1970)
                _ = PostTimeModel.save(obj: self!.timeModel, name: "SmsPostTime")
                self?.surplusTime = SmsWaitTime
                
                self?.codebtn.setTitle("\(self!.surplusTime)秒后再次发送", for: .disabled)
                self?.codebtn.isEnabled = false
                
                self?.timer=Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(self!.timeChange), userInfo: nil, repeats: true)
                self?.timer!.fire()
                
            }
            
            
        }

        
    }
    
    
    @IBAction func do_submit(_ sender: UIButton) {
        
        self.view.endEdit()
        
        if !bname.checkNull() || !baccount.checkNull() || !uname.checkNull() || !code.checkNull()
        {
            XMessage.show("请完善信息")
            return
        }
        
        sender.isEnabled = false
        XWaitingView.show()
        
        Api.do_save_bank(sid: DataCache.Share.User.sid, bank_name: bname.text!.trim(), bank_info: baccount.text!.trim(), bank_user: uname.text!.trim(), tel: DataCache.Share.User.mobile, code: code.text!.trim()) {(res) in
            
            XWaitingView.hide()
            sender.isEnabled = true
            
            if res
            {
                XAlertView.show("信息更新成功")
            }
            
            
        }
        
        
        
        
    }
    
    
    
    func initSelf()
    {
        if let m = PostTimeModel.read(name: "SmsPostTime") as? PostTimeModel
        {
            timeModel = m
            
            if(timeModel.time != 0)
            {
                surplusTime = Int(Date().timeIntervalSince1970 - timeModel.time.doubleValue)
                surplusTime = SmsWaitTime-surplusTime
                
                if(surplusTime >= 0)
                {
                    self.timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeChange), userInfo: nil, repeats: true)
                    self.timer!.fire()
                }
                else
                {
                    PostTimeModel.delete(name: "postTime")
                }
                
                
            }
            
            
        }
        
        
        
    }

    
    
    func timeChange()
    {
        surplusTime -= 1
        if(surplusTime >= 0)
        {
            codebtn.setTitle("\(surplusTime)秒后再次发送", for: UIControlState.disabled)
            codebtn.isEnabled = false
        }
        else
        {
            self.timer?.invalidate()
            self.timer = nil
            codebtn.setTitle("发送验证码", for: .normal)
            codebtn.isEnabled = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账户信息"
        self.addBackButton()
        
        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        getData()
        
    }
    
    
    func getData()
    {
        Api.bank_info(sid: DataCache.Share.User.sid) { [weak self](m) in
            
            self?.model = m
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 ||  indexPath.row == 2 ||  indexPath.row == 3 ||  indexPath.row == 4
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
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initSelf()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    
}
