//
//  MoneyVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/17.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import Foundation
import UIKit
import Charts

class MoneyVC: UIViewController {

    let chartView = PieChartView()
    
    var model = AccountsModel()
    {
        didSet
        {
            setDataCount()
        }
    }
    
    var sarr = ["可用余额","扣点金额","提现金额","退款金额","待消费金额"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "财务概况"
        self.addBackButton()
        
        self.view.backgroundColor = UIColor.white
        
        
        let button=UIButton(type: UIButtonType.custom)
        button.frame=CGRect(x: 0, y: 0, width: 50, height: 24);
        button.setTitle("明细", for: .normal)
        button.isExclusiveTouch = true
        let rightItem=UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem=rightItem;
        
        button.click {[weak self] (btn) in
            
            let vc = MoneyListVC()
            
            self?.show(vc, sender: nil)
            
        }

        

        
        chartView.frame = CGRect.init(x: 0, y: 0, width: SW, height: SH-64)
        
        self.view.addSubview(chartView)
        
    
        
        chartView.usePercentValuesEnabled = true;
        chartView.drawSlicesUnderHoleEnabled = false;
        chartView.holeRadiusPercent = 0.58;
        chartView.transparentCircleRadiusPercent = 0.63;
        chartView.chartDescription?.enabled = false;
        chartView.extraLeftOffset = 5.0
        chartView.extraRightOffset = 5.0
        chartView.extraBottomOffset = 150
        chartView.extraTopOffset = -150
        
        chartView.drawCenterTextEnabled = true;
        
        chartView.centerText = ""

        chartView.drawHoleEnabled = true;
        chartView.rotationAngle = 0.0;
        chartView.rotationEnabled = true;
        chartView.highlightPerTapEnabled = true;
        
        let l =  chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .vertical
        l.drawInside = false
        l.font = UIFont.systemFont(ofSize: 14.0)
        l.xEntrySpace = 7.0;
        l.yEntrySpace = 10.0;
        l.yOffset = -65.0;
        l.xOffset = 30.0
        
    
        chartView.entryLabelColor = UIColor.white;
        chartView.entryLabelFont = UIFont.systemFont(ofSize: 12)
        
        
        getData()
        
    }
    
    
    
    func getData()
    {
        let sid = DataCache.Share.User.sid
        
        Api.accounts_count(sid: sid) { [weak self](m) in
            
            self?.model = m
        }
        
    }
    
    
    
    
    
    func setDataCount()
    {

        chartView.centerText = "总销售额\r\n\r\n￥\(model.sale_money)"
        
        var values = [PieChartDataEntry]()
        
    
    for i in 0..<sarr.count
    {
        var str = sarr[i]
        var v = 0.0
        
        if i == 0
        {
            v = model.money * (1.0 - model.bili)
            str += ":   \(v.roundDouble())"
            v = v / model.sale_money * 100.0
        }
        else if i == 1
        {
            v = model.money *  model.bili
            str += ":   \(v.roundDouble())"
            v = v / model.sale_money * 100.0
        }
        else if i == 2
        {
            v = model.wd_money
            str += ":   \(v.roundDouble())"
            v = v / model.sale_money * 100.0
        }
        else if i == 3
        {
            v = model.refund_money
            str += ":   \(v.roundDouble())"
            v = v / model.sale_money * 100.0
        }
        else if i == 4
        {
            v = model.lock_money
            str += ":   \(v.roundDouble())"
            v = v / model.sale_money * 100.0
        }
        
        let obj = PieChartDataEntry.init(value: v, label: str)
        values.append(obj)
    }
    
        let dataSet = PieChartDataSet.init(values: values, label: "")
    
    dataSet.drawIconsEnabled = false;
    
    dataSet.sliceSpace = 2.0;
    dataSet.iconsOffset = CGPoint.init(x: 0, y: 40)
    
    // add a lot of colors
        
        var colors = [UIColor]()
        colors.append("1abc9c".color())
        colors.append(UIColor.init(red: 255.0/255.0, green: 123.0/255.0, blue: 124.0/255.0, alpha: 1.0))
        colors.append(UIColor.init(red: 114.0/255.0, green: 188.0/255.0, blue: 223.0/255.0, alpha: 1.0))
        colors.append("e67e22".color())
        colors.append(UIColor.init(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1.0))
        
        dataSet.colors = colors
        
        let data = PieChartData.init(dataSets: [dataSet])
        
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = "%"
        
        let f = DefaultValueFormatter.init(formatter: pFormatter)

        data.setValueFormatter(f)
        data.setValueFont(UIFont.systemFont(ofSize: 11))
        data.setValueTextColor(UIColor.white)
        

        chartView.data = data
        
        chartView.highlightValues(nil)
        
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
