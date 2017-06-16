//
//  TixianVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/16.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class TixianVC: UITableViewController {

    @IBOutlet weak var tmoney: UILabel!
    
    @IBOutlet weak var bname: UILabel!
    
    @IBOutlet weak var baccount: UILabel!
    
    @IBOutlet weak var money: UITextField!
    
    @IBOutlet weak var code: UITextField!
    
    @IBOutlet weak var codebtn: UIButton!
    
    var timer:Timer?
    var timeModel:PostTimeModel = PostTimeModel()
    var surplusTime:Int = -1
    
    var model:BankModel?
    {
        didSet
        {
            bname.text = model?.bank_name
            baccount.text = model?.bank_info
        }
    }
    
    var amodel:AccountsModel?
    {
        didSet
        {
            if let m = amodel
            {
                let d = (m.money * (1.0 - m.bili) ) .roundDouble()
                tmoney.text = "\(d)"
            }
            
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
        
        if amodel == nil || model == nil
        {
            XMessage.show("余额信息获取失败，请重试")
            return
        }
        
        if model?.bank_info == "" || model?.bank_user == "" || model?.bank_name == ""
        {
            XMessage.show("请先完善银行账户信息")
            return
        }
        
        if !money.checkNull() || !code.checkNull()
        {
            XMessage.show("请完善信息")
            return
        }
        
        let m = money.text!.trim().numberValue.doubleValue
        let d = (amodel!.money * (1.0 - amodel!.bili) ) .roundDouble()
        
        if m <= 0 || m > d
        {
            XMessage.show("提现金额有误！")
            return
        }
        

        sender.isEnabled = false
        XWaitingView.show()
        
        let sid = DataCache.Share.User.sid
        
       Api.do_tixian_submit(sid: sid, money: money.text!.trim(), sms_verify: code.text!.trim()) {[weak self] (res) in
            sender.isEnabled = true
            if res
            {
                XAlertView.show("提交成功，请等待审核！", block: {[weak self] in
                    self?.pop()
                })
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
        
        
        
        let button=UIButton(type: UIButtonType.custom)
        button.frame=CGRect(x: 0, y: 0, width: 24, height: 24);
        button.setBackgroundImage("history.png".image(), for: UIControlState())
        button.isExclusiveTouch = true
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        button.click {[weak self] (btn) in
            
            let vc = TixianHistoryVC()
            
            self?.show(vc, sender: nil)
            
        }

        
        
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
        
        Api.accounts_count(sid: DataCache.Share.User.sid) {[weak self] (m) in
            
            self?.amodel = m
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 ||  indexPath.row == 3
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
