//
//  Reflect+Parse.swift
//  Reflect
//
//  Created by 成林 on 15/8/23.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Reflect{
    
    class func parsePlist(_ name: String) -> Self?{
        
        let path = Bundle.main.path(forResource: name+".plist", ofType: nil)
        
        if path == nil {return nil}
        
        let dict = NSDictionary(contentsOfFile: path!)
        
        if dict == nil {return nil}
        
        return parse(dict: dict!)
    }
    
    class func parses(arr: NSArray) -> [Reflect]{
        
        var models: [Reflect] = []
        
        for (_ , dict) in arr.enumerated(){
            
            let model = self.parse(dict: dict as! NSDictionary)
            
            models.append(model)
        }
        
        return models
    }
    
    //aaaa
    class func parse(json:JSON?,replace:Dictionary<String,String>?) -> Self
    {
        let model = self.init()
        
        if json == nil {return model}
        
        let mappingDict = model.mappingDict()
        
        let ignoreProperties = model.ignorePropertiesForParse()
        
        model.properties { (name, type, value) -> Void in
            
            var dataDictHasKey=false
            var mappdictDictHasKey=false
            var needIgnore=false
            
            if(replace?[name] != nil)
            {
                dataDictHasKey = json![replace![name]!] != nil
                mappdictDictHasKey = mappingDict?[replace![name]!] != nil
                needIgnore = ignoreProperties == nil ? false : (ignoreProperties!).contains(replace![name]!)
            }
            else
            {
                dataDictHasKey = json![name] != nil
                mappdictDictHasKey = mappingDict?[name] != nil
                needIgnore = ignoreProperties == nil ? false : (ignoreProperties!).contains(name)
            }
            
            if (dataDictHasKey || mappdictDictHasKey) && !needIgnore {
                
                var key:String = mappdictDictHasKey ? mappingDict![name]! : name
                
                if(replace?[name] != nil)
                {
                    key = replace![name]!
                }
                
                
                if !type.isArray {
                    
                    if !type.isReflect {
                        
                        switch type.realType
                        {
                        case .String:
                        
                            model.setValue(json![key].stringValue, forKeyPath: name)
                            
                        case .Int:
                            model.setValue(json![key].intValue, forKeyPath: name)
                            
                        case .Float:
                            model.setValue(json![key].floatValue, forKeyPath: name)
                            
                        case .Double:
                            model.setValue(json![key].doubleValue, forKeyPath: name)
                            
                        case .Bool:
                            model.setValue(json![key].boolValue, forKeyPath: name)
                            
                        default:
                            model.setValue(json![key].object, forKeyPath: name)
                            
                        }
                        
                    }else{
                        
                        model.setValue((type.typeClass as! Reflect.Type).parse(json: json![key],replace: replace), forKeyPath: name)
                        
                    }
                    
                }else{
                    
                    if let res = type.isAggregate(){
                        
                        var arrAggregate:[Any] = []
                        
                        if res is Int.Type {
                            
                            arrAggregate = parseAggregateArray(json![key], basicType: ReflectType.BasicType.Int, ins: Int(0))
                            
                        }else if res is Float.Type {
                            
                            arrAggregate = parseAggregateArray(json![key], basicType: ReflectType.BasicType.Float, ins: Float(0))
                            
                        }else if res is Double.Type {
                            
                            arrAggregate = parseAggregateArray(json![key], basicType: ReflectType.BasicType.Double, ins: Double(0))
                            
                        }else if res is String.Type {
                            arrAggregate = parseAggregateArray(json![key], basicType: ReflectType.BasicType.String, ins: String.self)
                            
                        }else if res is NSNumber.Type {
                            
                            arrAggregate = parseAggregateArray(json![key], basicType: ReflectType.BasicType.NSNumber, ins: NSNumber())
                            
                        }else{
                            
                            arrAggregate = json![key].object as! [AnyObject]
                        }
                        
                        model.setValue(arrAggregate, forKeyPath: name)
                        
                    }else{
                        
                        let elementModelType =  ReflectType.makeClass(type) as! Reflect.Type
                        
                        let dictKeyArr = json![key].object as! NSArray
                        
                        var arrM: [Reflect] = []
                        
                        for (_, value) in dictKeyArr.enumerated() {
                            
                            let elementModel = elementModelType.parse(dict: value as! NSDictionary)
                            
                            arrM.append(elementModel)
                        }
                        
                        model.setValue(arrM, forKeyPath: name)
                    }
                }
                
            }
        }
        
        return model
    }
    
    class func parse(dict: NSDictionary) -> Self{
        
        let model = self.init()
        
        let mappingDict = model.mappingDict()
        
        let ignoreProperties = model.ignorePropertiesForParse()
        
        model.properties { (name, type, value) -> Void in
            
            let dataDictHasKey = dict[name] != nil
            let mappdictDictHasKey = mappingDict?[name] != nil
            let needIgnore = ignoreProperties == nil ? false : (ignoreProperties!).contains(name)
            
            if (dataDictHasKey || mappdictDictHasKey) && !needIgnore {
                
                let key = mappdictDictHasKey ? mappingDict![name]! : name
                
                if !type.isArray {
                    
                    if !type.isReflect {
                        
                        model.setValue(dict[key], forKeyPath: name)
                        
                    }else{
                        
                        model.setValue((type.typeClass as! Reflect.Type).parse(dict: dict[key] as! NSDictionary), forKeyPath: name)
                        
                    }
                    
                }else{
                    
                    if let res = type.isAggregate(){
                        
                        var arrAggregate:[Any] = []
                        
                        if res is Int.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: ReflectType.BasicType.Int, ins: 0)
                        }else if res is Float.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: ReflectType.BasicType.Float, ins: 0.0)
                        }else if res is Double.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: ReflectType.BasicType.Double, ins: 0.0)
                        }else if res is String.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: ReflectType.BasicType.String, ins: "")
                        }else if res is NSNumber.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: ReflectType.BasicType.NSNumber, ins: NSNumber())
                        }else{
                            arrAggregate = dict[key] as! [AnyObject]
                        }
                        
                        model.setValue(arrAggregate, forKeyPath: name)
                        
                    }else{
                        
                        let elementModelType =  ReflectType.makeClass(type) as! Reflect.Type
                        
                        let dictKeyArr = dict[key] as! NSArray
                        
                        var arrM: [Reflect] = []
                        
                        for (_, value) in dictKeyArr.enumerated() {
                            
                            let elementModel = elementModelType.parse(dict: value as! NSDictionary)
                            
                            arrM.append(elementModel)
                        }
                        
                        model.setValue(arrM, forKeyPath: name)
                    }
                }
                
            }
        }
        
        return model
    }
    
    
    class func parseAggregateArray<T>(_ jsonArr: JSON,basicType: ReflectType.BasicType, ins: T) -> [T]{
        
        var intArrM: [T] = []
    
        if jsonArr.count == 0 {return intArrM}
        
        for (_,subJson):(String, JSON) in jsonArr {
            
            var element: T = ins
            
            if ins.self is Int.Type {
                element = subJson.intValue as! T
            }
            else if ins.self is Float.Type {
                element = subJson.floatValue as! T
            }
            else if ins.self is Double.Type {
                element = subJson.doubleValue as! T
            }
            else if ins.self is NSNumber.Type {
                element = subJson.numberValue as! T
            }
            else if ins.self is String.Type {
                element = subJson.stringValue as! T
            }
            else{
                element = subJson as! T
            }
            
            intArrM.append(element)
 
        }
        
        return intArrM
    }
    
    
    class func parseAggregateArray<T>(_ arrDict: NSArray,basicType: ReflectType.BasicType, ins: T) -> [T]{
        
        var intArrM: [T] = []
        
        if arrDict.count == 0 {return intArrM}
        
        for (_, value) in arrDict.enumerated() {
            
            var element: T = ins
            
            let v = "\(value)"
            
            
            
            if T.self is Int.Type {
                element = Int(Float(v)!) as! T
            }
            else if T.self is Float.Type {element = v.floatValue as! T}
            else if T.self is Double.Type {element = v.doubleValue as! T}
            else if T.self is NSNumber.Type {element = NSNumber(value: v.doubleValue! as Double) as! T}
            else{element = value as! T}
            
            
            intArrM.append(element)
        }
        
        return intArrM
    }
    
    
    func mappingDict() -> [String: String]? {return nil}
    
    func ignorePropertiesForParse() -> [String]? {return nil}
}

