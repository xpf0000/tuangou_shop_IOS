	//
//  String.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

    extension String {
        
        //分割字符
        func split(_ s:String)->[String]{
            if s.isEmpty{
                var x=[String]()
                for y in self.characters{
                    x.append(String(y))
                }
                return x
            }
            return self.components(separatedBy: s)
        }

        
        
        /// String使用下标截取字符串
        /// 例: "示例字符串"[0..<2] 结果是 "示例"
        subscript (r: Range<Int>) -> String {
            get {
                let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
                let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
                
                return self[startIndex..<endIndex]
            }
        }
        
        func replace(_ str1:String,with:String)->String
        {
            var temp:NSString = NSString(string: self)
            temp = temp.replacingOccurrences(of: str1, with: with) as NSString
            
            return temp as String
        }
        
        var numberValue: NSNumber {
            
            let decimal = NSDecimalNumber(string: self)
            if decimal == NSDecimalNumber.notANumber {  // indicates parse error
                return NSDecimalNumber.zero
            }
            return decimal
            
        }

        
        //去掉左右空格
        func trim()->String{
            return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }

        
    
        func color() -> UIColor{
            
            // 存储转换后的数值
            var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
            
            // 分别转换进行转换
            Scanner(string: self[0..<2]).scanHexInt32(&red)
            
            Scanner(string: self[2..<4]).scanHexInt32(&green)
            
            Scanner(string: self[4..<6]).scanHexInt32(&blue)
        
            return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
            
        }
    
        //统计长度
        func length()->Int{
            return self.characters.count
        }
        //统计长度(别名)
        func size()->Int{
            return self.characters.count
        }

        func path()->String
        {
            var str:String?
            str=Bundle.main.path(forResource: self, ofType: nil)
            str=(str==nil) ? "" : str
            return str!
        }

        func url()->URL?
        {
            return URL(string: self)
        }
        
        func urlRequest() -> URLRequest?
        {
            let str = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            if let u = str?.url()
            {
                return URLRequest(url: u)
            }
            
            return nil
        }
        
        
        //是否包含字符串
        func has(_ s:String)->Bool{
            if (self.range(of: s) != nil) {
                return true
            }else{
                return false
            }
        }
        //是否包含前缀
        func hasBegin(_ s:String)->Bool{
            if self.hasPrefix(s) {
                return true
            }else{
                return false
            }
        }
        //是否包含后缀
        func hasEnd(_ s:String)->Bool{
            if self.hasSuffix(s) {
                return true
            }else{
                return false
            }
        }
        
        
        func  Nib() -> UINib
        {
            return UINib(nibName: self, bundle: nil)
        }
        
        func VC(name:String)->UIViewController
        {
            let board:UIStoryboard=UIStoryboard(name: name, bundle: nil)
            return board.instantiateViewController(withIdentifier: self)
        }
        
        func postNotice()
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: self), object: nil)
        }

        
        func image()->UIImage?
        {
            var image:UIImage?
            image = UIImage(contentsOfFile: self.path())
            
            if(image != nil)
            {
                return image
            }
            
            image = UIImage(contentsOfFile: self)
            
            if(image != nil)
            {
                return image
            }

            return image
        }


        
        
        func match(_ str:String)->Bool
        {
            let regextestmobile = NSPredicate(format: "SELF MATCHES %@",str)
            
            if ((regextestmobile.evaluate(with: self) == true)
                )
            {
                return true
            }
            else
            {
                return false
            }
        }
        
        func match(_ str:RegularType)->Bool
        {
            return self.match(str.rawValue)
        }
        
        
        
        
        func CachesSize() -> Double
        {
            var cachesSize:Double = 0
            let manager:FileManager = FileManager.default
            let allFileArray:Array<String>? = manager.subpaths(atPath: self)
            
            if(allFileArray != nil)
            {
                let arr:NSArray = NSArray(array: allFileArray!)
                let subFilesEnemerator:NSEnumerator=arr.objectEnumerator()
                var fileName:String?
                
                while(subFilesEnemerator.nextObject() != nil)
                {
                    fileName = subFilesEnemerator.nextObject() as? String
                    
                    if(fileName != nil)
                    {
                        let fileAbsolutePath:String = (self as NSString).appendingPathComponent(fileName!)
                        if(manager.fileExists(atPath: fileAbsolutePath))
                        {
                            do
                            {
                                let dic:NSDictionary? = try manager.attributesOfItem(atPath: fileAbsolutePath) as NSDictionary
                                
                                if(dic != nil)
                                {
                                    cachesSize = cachesSize + Double(dic!.fileSize())
                                }
                            }
                            catch
                            {
                                
                            }
                            
                        }
                    }
                    
                }
                
                
            }
            
            return cachesSize;
        }
        
        
    }
