//
//  XYEarningsItem.swift
//  WUO
//
//  Created by mofeini on 17/1/23.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

public class XYEarningsItem: NSObject {

    var uid : Int?
    var earningsGoldCoin : CGFloat?
    var name : String?
    var head : String?
    
    convenience init(dict: [String: Any]) {
       self.init()
        setValuesForKeys(dict)
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

public class invest: NSObject {
    
    var targetUid : Int?
    var myUid : Int?
    var myName : String?
    var targetName : String?
    var head : String?
    
    convenience init(dict: [String: Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}

public class reward: NSObject {
   
    var targetUid : Int?
    var myUid : Int?
    var money : CGFloat?
    var myName : String?
    var targetName : String?
    var head : String?
    
    convenience init(dict: [String: Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

public class divide: NSObject {
    
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
    
    convenience init(dict: [String: Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

