//
//  CouponSearchView.swift
//  rexian V1.0
//
//  Created by X on 16/4/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class ShopSearchVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate
{
    var url = ""
    var searchTxt = ""
        {
        didSet
        {
            if searchTxt == ""
            {
                httphandle.listArr.removeAll(keepingCapacity: false)
                table.reloadData()
                table.hideFootRefresh()
            }
            else
            {
                
                
            }
        }
    }
    
    var searchbar:UISearchBar = UISearchBar()
    
    var table = UITableView()
    
    let httphandle = XHttpHandle()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = UIColor.white
        
        searchbar.layer.masksToBounds = true
        searchbar.clipsToBounds = true
        //searchbar.addEndButton()
        searchbar.placeholder = "请输入搜索关键词"
        searchbar.delegate = self
        
        searchbar.frame=CGRect.init(x: 8, y: 0, width: SW-16, height: 44)
        
        searchbar.subviews[0].subviews[0].removeFromSuperview()
        searchbar.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.addSubview(searchbar)
        
        searchbar.becomeFirstResponder()
        
        table.frame = CGRect.init(x: 0, y: 0, width: SW, height: SH-64)
        
        let view1=UIView()
        view1.backgroundColor=UIColor.clear
        table.tableFooterView=view1
        table.tableHeaderView=view1
        
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        
        table.delegate = self
        table.dataSource = self
        
        table.register("NearbyCell".Nib(), forCellReuseIdentifier: "NearbyCell")
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(table)
        
        table.setFooterRefresh {[weak self]()->Void in
            
            self?.httphandle.handle()
        }
        
        
        table.hideFootRefresh()
        
    
        
    }
    
    
    //MARK:-searchBar
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchbar.showsScopeBar = true;
        searchbar.setShowsCancelButton(true, animated: true)
        
        let arr=searchbar.subviews[0].subviews
        
        for view in arr
        {
            if(view is UIButton)
            {
                (view as! UIButton).isEnabled=true
                (view as! UIButton).setTitle("取消", for: .normal)
                (view as! UIButton).setTitleColor(UIColor.white, for: .normal)
                break
            }
        }
        
        return true
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
        self.view.endEditing(true)
        
        self.pop()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchTxt = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
        
       
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK:-table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return httphandle.listArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if searchTxt == ""
        {
            return 44.0
        }
        else
        {
            return 100.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if searchTxt == ""
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.contentView.removeAllSubViews()
            
                      return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyCell", for: indexPath) as! NearbyCell
            
          
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchTxt == ""
        {
                   }
        
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        searchbar.resignFirstResponder()
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchbar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        searchbar.endEditing(true)
        searchbar.isHidden = true
    }
    
    deinit
    {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
