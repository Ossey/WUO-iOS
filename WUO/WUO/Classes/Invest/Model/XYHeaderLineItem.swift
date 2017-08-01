//
//  XYEarningsItem.swift
//  WUO
//
//  Created by mofeini on 17/1/23.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

public class XYHeaderLineItem : NSObject {
    
    var earnings : XYEarningsItem?
    var invest : XYInvestItem?
    var reward : XYRewardItem?
    var divide : XYDivideItem?
    
    convenience init(dict: [String: [String : Any]], info: XYHTTPResponseInfo) {
        self.init()
        for item in dict {
            switch item.key {
            case "earnings":
                earnings = XYEarningsItem(dict: item.value, info: info)
                break
            case "invest":
                invest = XYInvestItem(dict: item.value, info: info)
                break
            case "earnings":
                reward = XYRewardItem(dict: item.value, info: info)
                break
            case "earnings":
                 divide = XYDivideItem(dict: item.value, info: info)
                break
            default:
                break
                
            }
        }
    }
}

// MARK: - headerLine 收入 模型类
public class XYEarningsItem: NSObject {

    var uid : Int?
    var earningsGoldCoin : CGFloat?
    var name : String?
    var head : String?
    var info : XYHTTPResponseInfo?
    
    
    convenience init(dict: [String: Any], info: XYHTTPResponseInfo) {
       self.init()
        setValuesForKeys(dict)
        self.info = info
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

// MARK: - headerLine 投资 模型类
public class XYInvestItem: NSObject {
    
    var targetUid : Int?
    var myUid : Int?
    var myName : String?
    var targetName : String?
    var head : String?
    var info : XYHTTPResponseInfo?
    
    convenience init(dict: [String: Any], info: XYHTTPResponseInfo) {
        self.init()
        setValuesForKeys(dict)
        self.info = info
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}

// MARK: - headerLine 奖赏 模型类
public class XYRewardItem: NSObject {
   
    var targetUid : Int?
    var myUid : Int?
    var money : CGFloat?
    var myName : String?
    var targetName : String?
    var head : String?
    var info : XYHTTPResponseInfo?
    
    convenience init(dict: [String: Any], info: XYHTTPResponseInfo) {
        self.init()
        setValuesForKeys(dict)
        self.info = info
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}


public class XYDivideItem: NSObject {
    
    var uid : Int?
    var goldCoin : CGFloat?
    var content : String?
    var createTime : TimeInterval?
    var title : String?
    var contentSuffix : String?
    var name : String?
    var did : Int?
    var head : String?
    var shareCount : String?
    var info : XYHTTPResponseInfo?
    
    convenience init(dict: [String: Any], info: XYHTTPResponseInfo) {
        self.init()
        setValuesForKeys(dict)
        self.info = info
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

