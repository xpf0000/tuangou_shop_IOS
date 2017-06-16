//
//  NoticeCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {

    @IBOutlet weak var ntitle: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
//    var model:NewsModel = NewsModel()
//    {
//        didSet
//        {
//            ntitle.text = model.name
//            time.text = model.create_time
//        }
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setHighlighted(false, animated: false)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if(selected)
        {
            deSelect()
            
            
            
        }
    }
    
}
