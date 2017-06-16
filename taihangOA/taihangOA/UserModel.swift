//
//  UserModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class UserModel: Reflect {

    var  id = ""
    var  account_name = ""
    var  account_password = ""
    var  sid = ""
    var  name = ""
    var  icon = ""
    var  status = 0
    var  mobile = ""
    var  sess_id = ""
    
    func reset()
    {
        id = ""
        account_name = ""
        account_password = ""
        sid = ""
        name = ""
        icon = ""
        status = 0
        mobile = ""
        sess_id = ""
        save()
    }
    
    func save()
    {
        _ = UserModel.save(obj: self, name: "User")
    }
    
    
}
