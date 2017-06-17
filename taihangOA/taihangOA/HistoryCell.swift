//
//  HistoryCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/17.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var pass: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    
    var model:CheckHistoryModel = CheckHistoryModel()
    {
        didSet
        {
            
            let url = URL.init(string: model.icon)
            img.kf.setImage(with: url)
            name.text = model.sub_name
            time.text = "验证时间：\(model.confirm_time)"
            price.text = "总价：￥\(model.coupon_price)"
            pass.text = "序列号：￥\(model.password)"
            
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
    
    
}
