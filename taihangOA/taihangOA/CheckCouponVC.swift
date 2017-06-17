//
//  CheckCouponVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/17.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CheckCouponVC: UITableViewController ,UIActionSheetDelegate,UIAlertViewDelegate{

    @IBOutlet weak var submit: UIButton!
    
    @IBOutlet weak var shop: UIButton!
    
    @IBOutlet weak var pass: UITextField!
    
    @IBOutlet weak var numtxt: UILabel!
    
    @IBOutlet weak var num: UITextField!
    
    var code = ""
    
    @IBAction func choose_shop(_ sender: Any) {
        
        sheet?.show(in: UIApplication.shared.keyWindow!)
        
    }
    
    var model : CouponCheckModel?
    {
        didSet
        {
            if let m = model
            {
                
                numtxt.text = "使用数量：(剩余\(m.count)张有效)"
                harr[4] = 62
                harr[5] = 50

                submit.isSelected = true
                
                tableView.reloadData()
                
                let alert = UIAlertView()
                alert.title = "提醒"
                alert.message = m.info+"\r\n请输入使用张数进行消费"
                alert.addButton(withTitle: "确定")
                alert.show()
                
            }
            else
            {
                
                pass.text = ""
                num.text = ""
                
                submit.isSelected = false
                
                harr[4] = 0
                harr[5] = 0
                
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func do_submit(_ sender: Any) {
        
        self.view.endEdit()
        
        if chooseShop == nil
        {
            XMessage.show("请选择门店")
            return
        }
        
        if !pass.checkNull()
        {
            return
        }
        
        if !submit.isSelected
        {
            
            let location_id = chooseShop!.id
            let coupon_pwd = pass.text!.trim()
            
            Api.check_coupon(location_id: location_id, coupon_pwd: coupon_pwd, block: { [weak self](m) in
                
                self?.model = m
                
            })
            
            
        }
        else
        {
            if !num.checkNull()
            {
                return
            }
            
            if let m = model
            {
                let n = num.text!.trim().numberValue.intValue
                
                if n < 0 || n > m.count
                {
                    XMessage.show("数量输入有误，请检查")
                    return
                }
                
                let alert = UIAlertView()
                
                alert.delegate = self
                alert.title = "提醒"
                alert.message = m.info+"\r\n确定使用【\(n)】 张?"
                alert.addButton(withTitle: "取消")
                alert.addButton(withTitle: "确定")
                alert.show()
                
                
                
            }
            
        }
        
        
    }
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1
        {
            
            let location_id = chooseShop!.id
            let coupon_pwd = pass.text!.trim()
            let n = num.text!.trim()
            
            Api.use_coupon(location_id: location_id, coupon_pwd: coupon_pwd, coupon_use_count: n, block: {[weak self] (m) in
                
                if m
                {
                    
                    XAlertView.show("消费成功", block: { [weak self] in

                        self?.model = nil
                    })

                }
                
            })

            
            
            
        }
        
    }
    
    
    @IBAction func to_scan(_ sender: Any) {
        
        let vc = ScannerViewController()
        vc.onScanResult { [weak self](res) in
            
            self?.pass.text = res
            
        }
        
        self.show(vc, sender: nil)
    }
    
    
    var arrs:[ShopsModel] = []
    
    var chooseShop:ShopsModel?
    {
        didSet
        {
            shop.setTitle(chooseShop?.name ?? "请选择门店", for: .normal)
        }
    }
    
    var sheet:UIActionSheet?
    
    var harr:[CGFloat] = [62,50,62,50,0,0,90]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消费券验证"
        self.addBackButton()

        let v = UIView()
        tableView.tableFooterView = v
        tableView.tableHeaderView = v
        
        shop.layer.masksToBounds = true
        shop.layer.cornerRadius = 5.0
        
        pass.layer.masksToBounds = true
        pass.layer.cornerRadius = 5.0
        
        num.layer.masksToBounds = true
        num.layer.cornerRadius = 5.0
        
        let lv = UIView()
        lv.frame = CGRect.init(x: 0, y: 0, width: 12, height: 50)
        pass.leftViewMode = .always
        pass.leftView = lv
        
        let rv = UIView()
        rv.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        pass.rightView = rv
        pass.rightViewMode = .always
        
        let lv1 = UIView()
        lv1.frame = CGRect.init(x: 0, y: 0, width: 12, height: 50)
        num.leftViewMode = .always
        num.leftView = lv1
        
        pass.addEndButton()
        num.addEndButton()
        
        pass.text = code
        
        getData()
        
        
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return harr[indexPath.row]
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
    
    
    
    
    func getData()
    {
        
        Api.shops_list {[weak self] (arr) in
            
            self?.arrs = arr
            
            self?.initshops()
        }
        
    }
    
    func   initshops()
    {
        if arrs.count == 0
        {
            return
        }
        
        let m = arrs[0]
        
        chooseShop = m
        
        sheet=UIActionSheet(title: "选择门店", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        
        for item in arrs
        {
            sheet?.addButton(withTitle: item.name)
        }
        
        sheet?.actionSheetStyle = UIActionSheetStyle.blackTranslucent;
    
        
    }
    
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex > 0
        {
            chooseShop = arrs[buttonIndex-1]
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    
    
    
    
}
