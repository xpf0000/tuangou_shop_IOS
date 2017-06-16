//
//  StoresListVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/15.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import SwiftyJSON


class StoresListVC: UIViewController,ReactionMenuDelegate {
    
    @IBOutlet weak var topMenu: ReactionMenuView!
    
    @IBOutlet weak var tableview: XTableView!
    
   
    
    var cate_id = ""
    
    var topCellArr:Array<Array<ReactionMenuItemModel>> = [[],[],[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商家"
        self.addBackButton()
        
        //设置菜单的父视图
        topMenu.superView = self.view
        //菜单的选项
        topMenu.titles = ["全部区域","全部分类","距离排序"]
        
        //菜单的个数  决定动态宽度
        topMenu.tableWidths = [[0.45,0.55],[0.45,0.55],[1.0]]
        topMenu.delegate = self
        topMenu.onlyOne = false
        
                
    }
    
    func getTopData()
    {
        
    }
    
    
    func putTown(o:Any)
    {
        
        
    }
    
    
    func putCate(o:Any)
    {
        
        
    }
    
    
    func putOrder(o:Any)
    {
        
        
    }
    
    
    func ReactionMenuChoose(_ arr: Array<ReactionMenuItemModel>, index: Int) {
        
        
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TabIndex = 1
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    
    
    
}
