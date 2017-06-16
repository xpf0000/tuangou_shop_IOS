//
//  TixianHistoryVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/16.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class TixianHistoryVC: UIViewController {
    
    let table = XTableView()
    var oid = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "提现历史"
        
        table.backgroundColor = UIColor.white
        
        table.frame = CGRect.init(x: 0, y: 0, width: SW, height: SH-64)
        self.view.addSubview(table)
        
        table.cellHeight = 74
        
        var url = Api.BaseUrl+"?ctl=biz_withdrawal&act=app_index&r_type=1&isapp=true"
        url += "&sid="+DataCache.Share.User.sid
        url += "&page=[page]"
        
        table.setHandle(url, pageStr: "[page]", keys: ["data"], model: TixianModel.self, CellIdentifier: "TixianCell")
        
        table.show()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
