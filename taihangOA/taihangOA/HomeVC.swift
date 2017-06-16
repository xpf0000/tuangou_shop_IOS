//
//  ViewController.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Cartography
import SwiftyJSON
import Kingfisher

class HomeVC: UIViewController {
    
    @IBOutlet weak var collect: UICollectionView!
    
    let topBar = HomeTopBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if(DataCache.Share.city.id == "")
//        {
//            let vc = "CityListVC".VC(name: "Main") as! CityListVC
//            vc.first = true
//            
//            vc.onChoose {[weak self] in
//                self?.topBar.setCityName()
//                self?.getData()
//            }
//            
//            let nv = XNavigationController.init(rootViewController: vc)
//
//            self.show(nv, sender: nil)
//        }
        
        self.view.backgroundColor = UIColor.white
        
        
        topBar.frame = CGRect(x: 0, y: 0, width: SW, height: 44.0)
        
        initTabBar()
        
        collect.register("HomeClassCell".Nib(), forCellWithReuseIdentifier: "HomeClassCell")
        collect.register("HomeTopicCell".Nib(), forCellWithReuseIdentifier: "HomeTopicCell")
        collect.register("HomeDealCell".Nib(), forCellWithReuseIdentifier: "HomeDealCell")
        
        
        collect.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CollectFooter")
        
        collect.register("HomeCHeader".Nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeCHeader")

        collect.contentInset.top = 20
        collect.contentInset.bottom = 50
        
        collect.setHeaderRefresh {[weak self] in
            
            self?.getData()
            
        }
        
//        if(DataCache.Share.city.id != "")
//        {
//            getData()
//        }
        
        topBar.home = self
         
    }
    
    func initTabBar()
    {
        let arr:Array<UITabBarItem> = (self.tabBarController?.tabBar.items)!
        let scale = Int(UIScreen.main.scale)

        for (i,item) in arr.enumerated()
        {
            item.image="tab_\(i)@\(scale)x.png".image()!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.selectedImage="tab_\(i)_1@\(scale)x.png".image()!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            
            item.setTitleTextAttributes([NSForegroundColorAttributeName:APPBlueColor,NSFontAttributeName:UIFont.systemFont(ofSize: 13.0)], for: UIControlState.selected)
            
            item.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13.0)], for: UIControlState.normal)
            
        }
    }
    
    func getData()
    {
//        let cid = DataCache.Share.city.id
//        
//        Api.app_index(city_id: cid, xpoint: "", ypoint: "") { [weak self](model) in
//            
//            self?.collect.endHeaderRefresh()
//            
//            self?.homeModel = model
//            self?.collect.reloadData()
//            
//        }
    }
    
        
    func dodeinit()
    {
        
   
    }
    
    deinit
    {
        dodeinit()
        print("HomeVC deinit !!!!!!!!!!!!!!!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TabIndex = 0
        self.navigationController?.navigationBar.addSubview(topBar)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        topBar.removeFromSuperview()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

