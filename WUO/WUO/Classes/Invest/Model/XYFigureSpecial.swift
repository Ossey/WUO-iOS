//
//  XYFigureSpecial.swift
//  WUO
//
//  Created by mofeini on 17/1/23.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  人物专刊

import UIKit

class XYFigureSpecial: NSObject {
    
    var responseInfo : XYHTTPResponseInfo?

    var createTime : String?
    var did : Int?
    var dname : String?
    var logo : String?
    var readCount : Int?
    
    convenience init(dict: [String : Any], responseInfo: XYHTTPResponseInfo) {
        self.init()
        
        setValuesForKeys(dict)
        self.responseInfo = responseInfo
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
