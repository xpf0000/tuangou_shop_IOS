//
//  CaiwuCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/17.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CaiwuCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var money: UILabel!
    
    @IBOutlet weak var info: UILabel!

    @IBOutlet weak var icon: UIImageView!
    
    
    var model:MoneyInfoModel = MoneyInfoModel()
    {
        didSet
        {
            let type = model.type > 3 ? "-" : "+"
            
            let str = model.create_time.split(" ")
            time.text = str[0]+"\r\n"+str[1]
            money.text = "\(type)\(model.money)"
            
            info.text = model.log_info
            
            if type == "+"
            {
                icon.image = "money_add.png".image()
            }
            else
            {
                icon.image = "money_clip.png".image()
            }
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}
