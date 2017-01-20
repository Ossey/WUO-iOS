//
//  XYTrendDetailViewModel.swift
//  WUO
//
//  Created by mofeini on 17/1/19.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYTrendDetailViewModel: NSObject {
    
    // MARK: - 用户发布的每一条趋势模型
    var item : XYTrendItem?
    var info : XYHTTPResponseInfo?
    
    var title_labelFrame : CGRect?
    var contentLableFrame : CGRect?
    var picCollectionViewFrame : CGRect?
    var nameLabelFrame : CGRect?
    var jobLabelFrame : CGRect?
    var videoImgViewFrame : CGRect?
    var avatarViewFrame : CGRect?
    var picItemWH : CGFloat?
    var topicNameLabelFrame : CGRect?
    var readCountBtnFrame : CGRect?
    var investBtnFrame : CGRect?
    var locationBtnFrame: CGRect?
    
    /** 用户发布的图片父视图的总高度 */
    var pictureSize : CGSize? {
        get {
            var picViewH : CGFloat = 0.0;
            guard let item = item else {
                return CGSize.zero
            }
            
            if let imgList = item.imgList {
                for item in imgList {
                    
                    picViewH += item.imgScaleSize.height
                }
            }
            
            if item.imgList.count > 1 {
                picViewH += CGFloat(item.imgList.count - 1) * SIZE_PICMARGIN
            }
            
            return CGSize.init(width: contentViewWidth, height: picViewH)
        }
    }
    
    
    // 中间内容的宽度
    let contentViewWidth = SCREENT_W() - SIZE_GAP_MARGIN * 2
    
    var headerViewHeght : CGFloat? {
        get {
            
            let x = SIZE_GAP_MARGIN
            var y = SIZE_GAP_TOP
            
            // 头部
            let headerHeight = SIZE_HEADERWH
            
            self.avatarViewFrame = CGRect.init(x: x, y: y, width: headerHeight, height: headerHeight);
            
            y += headerHeight + SIZE_GAP_SMALL
            
            let maxSize = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
            
            
            // 昵称
            let nameFont:UIFont! = FontWithSize(s: SIZE_FONT_NAME)
            let nameAttributes = [NSFontAttributeName : nameFont]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let nameSize: CGSize = (item?.name.boundingRect(with: maxSize, options: option, attributes: nameAttributes, context: nil))!.size
            self.nameLabelFrame = CGRect.init(x: x + SIZE_HEADERWH + SIZE_GAP_PADDING, y: self.avatarViewFrame!.origin.y, width: nameSize.width, height: nameSize.height)
            // job
            let jobFont = FontWithSize(s: SIZE_FONT_SUBTITLE)
            let jobAttributes = [NSFontAttributeName: jobFont]
            let jobSize : CGSize = (item?.job.boundingRect(with: maxSize, options: option, attributes: jobAttributes, context: nil))!.size
            self.jobLabelFrame = CGRect.init(x: (self.nameLabelFrame?.origin.x)!, y: self.nameLabelFrame!.maxY + SIZE_GAP_SMALL, width: jobSize.width, height: jobSize.height)
            
            
            
            // 标题
            var titleSize = CGSize.zero
            if item?.title.characters.count == 0 {
                title_labelFrame = CGRect.zero
                y += titleSize.height
            } else {
                let attributes = [NSFontAttributeName: FontWithSize(s: CGFloat(SIZE_FONT_TITLE))]
                titleSize = (item?.title.boundingRect(with: CGSize.init(width: contentViewWidth, height: CGFloat(MAXFLOAT)), options: option, attributes: attributes, context: nil))!.size
                title_labelFrame = CGRect.init(x: x, y: y, width: titleSize.width, height: titleSize.height)
                
                y += titleSize.height + SIZE_GAP_PADDING
            }
            
            // 话题
            var topicNameSize = CGSize.zero
            if item?.topicName.characters.count == 0 {
                topicNameLabelFrame = CGRect.zero
                y += topicNameSize.height
            } else {
                let attributes = [NSFontAttributeName: FontWithSize(s: CGFloat(SIZE_FONT_CONTENT))]
                topicNameSize = (item?.topicName.boundingRect(with: CGSize.init(width: contentViewWidth, height: CGFloat(MAXFLOAT)), options: option, attributes: attributes, context: nil))!.size
                topicNameLabelFrame = CGRect.init(x: x, y: y, width: topicNameSize.width, height: topicNameSize.height)
                y += topicNameSize.height + SIZE_GAP_PADDING
            }
            
            // 内容
            var contentSize = CGSize.zero
            if item?.content.characters.count == 0 {
                self.contentLableFrame = CGRect.zero
                y += contentSize.height
            } else {
                let attributes = [NSFontAttributeName: FontWithSize(s: CGFloat(SIZE_FONT_CONTENT))]
                contentSize = (item?.content.boundingRect(with: CGSize.init(width: contentViewWidth, height: CGFloat(MAXFLOAT)), options: option, attributes: attributes, context: nil))!.size
                contentLableFrame = CGRect.init(x: x, y: y, width: contentSize.width, height: contentSize.height)
                y += contentSize.height + SIZE_GAP_PADDING
            }
            // 图片
            let picViewSize = pictureSize!
            picCollectionViewFrame = CGRect.init(x: x, y: y, width: picViewSize.width, height: picViewSize.height)
            y += picViewSize.height + SIZE_GAP_PADDING
            

            // 视频图片
            var videoImgH : CGFloat = 0.0
            if item?.videoUrl.characters.count == 0 {
                // 有视频就没有图片
                videoImgViewFrame = CGRect.zero
                y += videoImgH
            } else {
                videoImgH = 160.0
                videoImgViewFrame = CGRect.init(x: x, y: y, width: contentViewWidth, height: videoImgH)
                y += videoImgH + SIZE_GAP_PADDING
            }
            
            // 投资按钮
            investBtnFrame = CGRect.init(x: SCREENT_W() - 50.0 - 15.0, y: (avatarViewFrame?.origin.y)!, width: 50, height: 26)
            
            // 浏览人数
            let readCountW : CGFloat = 80.0
            let readCountH : CGFloat = 10.0 + 5.0
            let readCountX = SCREENT_W() - (investBtnFrame?.size.width)! - SIZE_GAP_MARGIN - SIZE_GAP_MARGIN;
            readCountBtnFrame = CGRect.init(x: readCountX, y: y, width: readCountW, height: readCountH)
            
            // 位置
            if item?.location.characters.count == 0 {
                y += readCountH + SIZE_PIC_BOTTOM;
                locationBtnFrame = CGRect.zero
            } else {
                y += readCountH
                let attributes = [NSFontAttributeName: FontWithSize(s: SIZE_FONT_LOCATION)]
                let size = item?.location.boundingRect(with: CGSize.init(width: contentViewWidth, height: CGFloat(MAXFLOAT)), options: option, attributes: attributes, context: nil).size
                locationBtnFrame = CGRect(x: x, y: y, width: (size?.width)! + 30, height: (size?.height)! + 5)
                y += (locationBtnFrame?.size.height)! + SIZE_GAP_MARGIN
            }
            
            return y;
        }
    }
    
    var avatarImageURL : URL? {
        get {
            var fullPath : String?

            guard let head = item?.head else {
                return nil
            }
            
            if head.contains("http://") {
                fullPath = item?.head
            } else {
                guard let basePath = info?.basePath else {
                    return nil
                }
                fullPath = basePath + head
            }
            
            return URL(string: fullPath!)
        }
    }

    
    
    init(item: XYTrendItem, info: XYHTTPResponseInfo) {
        super.init()
        
        self.item = item
        self.info = info;
    }

}
