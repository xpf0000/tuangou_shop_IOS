//
//  CommentListVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/16.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CommentListVC: UIViewController {

    
    let table = XTableView()
    var oid = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "评论管理"
        
        table.backgroundColor = UIColor.white
        
        table.frame = CGRect.init(x: 0, y: 0, width: SW, height: SH-64)
        self.view.addSubview(table)
        
        var url = Api.BaseUrl+"?ctl=biz_dealr&act=app_dp_list&r_type=1&isapp=true"
        url += "&sid="+DataCache.Share.User.sid
        url += "&page=[page]"
        
        table.setHandle(url, pageStr: "[page]", keys: ["data"], model: CommentModel.self, CellIdentifier: "CommentCell")
        
        table.show()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
