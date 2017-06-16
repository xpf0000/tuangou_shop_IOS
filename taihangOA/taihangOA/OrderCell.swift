//
//  OrderCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    
    var model:OrderModel = OrderModel()
    {
        didSet
        {
             let url = URL.init(string: model.icon)
            img.kf.setImage(with: url)
            name.text = model.name
            time.text = "下单时间：\(model.create_time)"
            price.text = "￥\(model.total_price)"
            
            if(model.pay_status != "2")
            {
                status.text = "未付款"
            }
            else
            {
                if(model.order_status == "1")
                {
                    
                    if(model.dp_id > 0)
                    {
                        status.text = "已点评"
                    }
                    else
                    {
                        status.text = "已消费"
                    }
                    
                }
                else
                {
                    status.text = "未使用"
                }
                
            }
            
            if(model.refund_status == 1)
            {
                status.text = "退款中"
            }
            else if(model.refund_status == 2)
            {
                status.text = "已退款"
            }
            else if(model.refund_status == 3)
            {
                status.text = "拒绝退款"
            }
            
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setHighlighted(false, animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected
        {
            deSelect()
            
            let vc = HtmlVC()
            vc.url = "http://tg01.sssvip.net/wap/index.php?ctl=biz_dealo&act=app_info&id=\(model.id)".url()
            vc.title = "订单详情"
            
            self.viewController?.show(vc, sender: nil)
            
        }
    }
    
}
