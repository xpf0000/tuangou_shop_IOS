//
//  Api.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

typealias ApiBlock<T> = (T)->Void

class Api: NSObject {
    
    static let BaseUrl  = "http://tg01.sssvip.net/mapi/"
    static let Pagesize = 10
    
    
    class func dologin(account_name:String,account_password:String,block:@escaping ApiBlock<UserModel>)
    {
        var url = BaseUrl+"?ctl=biz_user&act=app_dologin&r_type=1&isapp=true"
        url += "&account_name="+account_name
        url += "&account_password="+account_password
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = UserModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func order_list(sid:String,page:String,block:@escaping ApiBlock<[OrderModel]>)
    {
        var url = BaseUrl+"?ctl=biz_dealo&act=app_index&r_type=1&isapp=true"
        url += "&sid="+sid
        url += "&page="+page
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [OrderModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = OrderModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)

                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func dp_list(sid:String,page:String,block:@escaping ApiBlock<[CommentModel]>)
    {
        var url = BaseUrl+"?ctl=biz_dealr&act=app_dp_list&r_type=1&isapp=true"
        url += "&sid="+sid
        url += "&page="+page
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [CommentModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = CommentModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    class func dp_submit(sid:String,aid:String,data_id:String,reply_content:String,block:@escaping ApiBlock<Bool>)
    {
        var url = BaseUrl+"?ctl=biz_dealr&act=app_do_reply_dp&r_type=1&isapp=true"
        url += "&sid="+sid
        url += "&aid="+aid
        url += "&data_id="+data_id
        url += "&reply_content="+reply_content
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let status = json["status"].int ?? 0
                
                if status != 1
                {
                    let msg = json["info"].string ?? "回复提交失败"
                    XMessage.show(msg)
                    block(false)
                }
                else
                {
                    block(true)
                }
                
            case .failure(let error):
                print(error)
                block(false)
                XMessage.show(error.localizedDescription)
            }

        }
        
    }
    
    
    
    
    class func accounts_count(sid:String,block:@escaping ApiBlock<AccountsModel>)
    {
        var url = BaseUrl+"?ctl=biz_balance&r_type=1&isapp=true"
        url += "&sid="+sid
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = AccountsModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func accounts_list(sid:String,page:String,block:@escaping ApiBlock<[MoneyInfoModel]>)
    {
        var url = BaseUrl+"?ctl=biz_balance&act=detail&r_type=1&isapp=true"
        url += "&sid="+sid
        url += "&page="+page
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [MoneyInfoModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = MoneyInfoModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    class func bank_info(sid:String,block:@escaping ApiBlock<BankModel>)
    {
        var url = BaseUrl+"?ctl=biz_user&act=bank_info&r_type=1&isapp=true"
        url += "&sid="+sid
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = BankModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func do_save_bank(
                            sid:String,
                            bank_name:String,
                            bank_info:String,
                            bank_user:String,
                            tel:String,
                            code:String,
                            block:@escaping ApiBlock<Bool>)
    {
        var url = BaseUrl+"?ctl=biz_user&act=do_save_bank&r_type=1&isapp=true"
        url += "&sid="+sid
        url += "&bank_name="+bank_name
        url += "&bank_info="+bank_info
        url += "&bank_user="+bank_user
        url += "&tel="+tel
        url += "&code="+code
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let status = json["status"].int ?? 0
                
                if status != 1
                {
                    let msg = json["info"].string ?? "提交失败"
                    XMessage.show(msg)
                    block(false)
                }
                else
                {
                    block(true)
                }
                
            case .failure(let error):
                print(error)
                block(false)
                XMessage.show(error.localizedDescription)
            }
        }
        
    }
    
    
    class func do_tixian_submit(
        sid:String,
        money:String,
        sms_verify:String,
        block:@escaping ApiBlock<Bool>)
    {
        var url = BaseUrl+"?ctl=biz_withdrawal&act=app_do_submit&r_type=1&isapp=true"
        url += "&sid="+sid
        url += "&money="+money
        url += "&sms_verify="+sms_verify
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let status = json["status"].int ?? 0
                
                if status != 1
                {
                    let msg = json["info"].string ?? "提交失败"
                    XMessage.show(msg)
                    block(false)
                }
                else
                {
                    block(true)
                }
                
            case .failure(let error):
                print(error)
                block(false)
                XMessage.show(error.localizedDescription)
            }
        }
        
    }
    
    
    
    class func tixian_list(sid:String,page:String,block:@escaping ApiBlock<[TixianModel]>)
    {
        var url = BaseUrl+"?ctl=biz_withdrawal&act=app_index&r_type=1&isapp=true"
        url += "&sid="+sid
        url += "&page="+page
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [TixianModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = TixianModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func user_init(id:String,
                         sid:String,
                         a:String,
                         block:@escaping ApiBlock<String>)
    {
        var url = BaseUrl+"?ctl=biz_user&act=app_init_user&r_type=1&isapp=true"
        url += "&id="+id
        url += "&sid="+sid
        url += "&a="+a
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let str = json["data"].stringValue
                
                block(str)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func user_logout(block:@escaping ApiBlock<String>)
    {
        let url = BaseUrl+"?ctl=biz_user&act=app_init_user&r_type=1&isapp=true"
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                break
                
            case .failure(let error):
                
                break
            }
        }
        
    }
    
    
    
    class func shops_list(block:@escaping ApiBlock<[ShopsModel]>)
    {
        let url = BaseUrl+"?ctl=biz_dealv&act=app_index&r_type=1&isapp=true"
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [ShopsModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = ShopsModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    class func check_coupon(location_id:String,coupon_pwd:String,block:@escaping ApiBlock<CouponCheckModel>)
    {
        var url = BaseUrl+"?ctl=biz_dealv&act=app_check_coupon&r_type=1&isapp=true"
        url += "&location_id="+location_id
        url += "&coupon_pwd="+coupon_pwd
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = CouponCheckModel.parse(json: json["data"], replace: nil)
                
                block(model)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    class func use_coupon(
        location_id:String,
        coupon_pwd:String,
        coupon_use_count:String,
        block:@escaping ApiBlock<CouponCheckModel>)
    {
        var url = BaseUrl+"?ctl=biz_dealv&act=use_coupon&r_type=1&isapp=true"
        url += "&location_id="+location_id
        url += "&coupon_pwd="+coupon_pwd
        url += "&coupon_use_count="+coupon_use_count
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let status = json["status"].int ?? 0
                
                if status != 1
                {
                    let msg = json["info"].string ?? "验证失败"
                    XMessage.show(msg)
                }
                else
                {
                    let model = CouponCheckModel.parse(json: json["data"], replace: nil)
                    block(model)
                }
  
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    
    class func used_history(
        sid:String,
        aid:String,
        page:String,
        block:@escaping ApiBlock<[CheckHistoryModel]>)
    {
        var url = BaseUrl+"?ctl=biz_dealv&act=app_used_history&r_type=1&isapp=true"
        url += "&sid="+sid
        url += "&aid="+aid
        url += "&page="+page
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                var list : [CheckHistoryModel] = []
                if let arr = json["data"].array
                {
                    for item in arr
                    {
                        let model = CheckHistoryModel.parse(json: item, replace: nil)
                        list.append(model)
                    }
                }
                
                block(list)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    class func sms_send_code(
        mobile:String,
        block:@escaping ApiBlock<Bool>)
    {
        var url = BaseUrl+"?ctl=sms&act=send_sms_code&r_type=1&isapp=true&unique=0"
        url += "&mobile="+mobile
        
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let status = json["status"].int ?? 0
                
                if status != 1
                {
                    let msg = json["info"].string ?? "验证码发送失败"
                    XMessage.show(msg)
                    block(false)
                }
                else
                {
                    block(true)
                }
                
            case .failure(let error):
                print(error)
                block(false)
                XMessage.show(error.localizedDescription)
            }
        }
        
    }
    


}
