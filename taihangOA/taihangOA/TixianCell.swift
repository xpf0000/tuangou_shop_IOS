//
//  TixianCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/16.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class TixianCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var money: UILabel!
    
    @IBOutlet weak var status: UIButton!
    
    @IBAction func show_reason(_ sender: UIButton) {
        
        if sender.isSelected
        {
            
            let alert = UIAlertView()
            alert.title = "拒绝原因"
            alert.message = model.reason
            alert.addButton(withTitle: "确定")
            alert.show()
            
        }
        
    }
    
    
    var model:TixianModel = TixianModel()
    {
        didSet
        {
            let str = model.f_create_time.split(" ")
            time.text = str[0]+"\r\n"+str[1]
            money.text = "\(model.money)"
            
           status.setTitle(model.status, for: .normal)
            
            if model.status == "已拒绝"
            {
                status.isSelected = true
            }
            else
            {
                status.isSelected = false
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
