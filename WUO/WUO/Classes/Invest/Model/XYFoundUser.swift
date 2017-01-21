//
//  XYFoundUser.swift
//  WUO
//
//  Created by mofeini on 17/1/21.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYFoundUser: NSObject {

    // MARK: - 模型属性
    var responseInfo : XYHTTPResponseInfo?
    /** 投资人数量 */
    var beGmCount : Int?
    /** 赚取的金币数量 */
    var earningsGoldCoin : CGFloat?
    /** 粉丝数量 */
    var fansCount : Int?
    var head : String?
    var imgList : [XYTrendImgItem]?
    var isFollow : Bool?
    var isInvest : Bool?
    var job : String?
    var name : String?
    var uid : Int?
    
    // MARK: - 对模型属性的处理
    var headImageURL : URL? {
        get {
            let fullPath : String?
            guard let head = head else {
                return nil
            }
            if head.contains("http://") {
                fullPath = head
            } else {
                guard let basePath = responseInfo?.basePath else {
                    return nil
                }
                fullPath = basePath + head
            }
            return URL.init(string: fullPath!)
        }
    }
    
    
    convenience init(dict: [String: Any], info: XYHTTPResponseInfo) {
        self.init()
        setValuesForKeys(dict)
        responseInfo = info
        
        if let imgList = dict["list"] as? [[String: Any]] {
            
            for obj in imgList {
               self.imgList?.append(XYTrendImgItem(dict: obj, responseInfo: info))
            }
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
