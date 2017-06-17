//
//  CheckHistoryVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/17.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CheckHistoryVC: UIViewController {

    let table = XTableView()
    var oid = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "验证历史"
        
        table.backgroundColor = UIColor.white
        
        table.frame = CGRect.init(x: 0, y: 0, width: SW, height: SH-64)
        self.view.addSubview(table)
        
        table.cellHeight = 135
        
        var url = Api.BaseUrl+"?ctl=biz_dealv&act=app_used_history&r_type=1&isapp=true"
        url += "&sid="+DataCache.Share.User.sid
        url += "&aid="+DataCache.Share.User.id
        url += "&page=[page]"
        
        table.setHandle(url, pageStr: "[page]", keys: ["data"], model: CheckHistoryModel.self, CellIdentifier: "HistoryCell")
        
        table.show()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}
