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
    // 中间内容的宽度
    let contentViewWidth = SCREENT_W() - SIZE_GAP_MARGIN * 2
    
//    var headerViewHeght : CGFloat? {
//        get {
//            if self.headerViewHeght != 0 {
//                // 当已计算好时，就不再计算
//                return self.headerViewHeght;
//            }
//            
//            let x = SIZE_GAP_MARGIN
//            var y = SIZE_GAP_TOP
//            
//            // 头部
//            let headerHeight = SIZE_HEADERWH
//            
//            self.avatarViewFrame = CGRect.init(x: x, y: y, width: headerHeight, height: headerHeight);
//            
//            y += headerHeight + SIZE_GAP_SMALL
//            
//            let maxSize = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
//            
//            
//            // 昵称
//            let nameFont:UIFont! = FontWithSize(s: SIZE_FONT_NAME)
//            let nameAttributes = [NSFontAttributeName : nameFont]
//            let option = NSStringDrawingOptions.usesLineFragmentOrigin
//            let nameSize: CGSize = (item?.name.boundingRect(with: maxSize, options: option, attributes: nameAttributes, context: nil))!.size
//            self.nameLabelFrame = CGRect.init(x: x, y: self.avatarViewFrame!.origin.y, width: nameSize.width, height: nameSize.height)
//            // job
//            let jobFont = FontWithSize(s: SIZE_FONT_SUBTITLE)
//            let jobAttributes = [NSFontAttributeName: jobFont]
//            let jobSize : CGSize = (item?.job.boundingRect(with: maxSize, options: option, attributes: jobAttributes, context: nil))!.size
//            self.jobLabelFrame = CGRect.init(x: x, y: self.nameLabelFrame!.maxY, width: SIZE_GAP_SMALL, height: jobSize.height)
//            
//            
//            
//            // 标题
//            var titleSize = CGSize.zero
//            if item?.title.characters.count == 0 {
//                title_labelFrame = CGRect.zero
//                y += titleSize.height
//            } else {
//                let attributes = [NSFontAttributeName: FontWithSize(s: CGFloat(SIZE_FONT_TITLE))]
//                titleSize = (item?.title.boundingRect(with: CGSize.init(width: contentViewWidth, height: CGFloat(MAXFLOAT)), options: option, attributes: attributes, context: nil))!.size
//                title_labelFrame = CGRect.init(x: x, y: y, width: titleSize.width, height: titleSize.height)
//                
//                y += titleSize.height + SIZE_GAP_PADDING
//            }
//            
//            // 话题
//            var topicNameSize = CGSize.zero
//            if item?.topicName.characters.count == 0 {
//                topicNameLabelFrame = CGRect.zero
//                y += topicNameSize.height
//            } else {
//                let attributes = [NSFontAttributeName: FontWithSize(s: CGFloat(SIZE_FONT_CONTENT))]
//                topicNameSize = (item?.topicName.boundingRect(with: CGSize.init(width: contentViewWidth, height: CGFloat(MAXFLOAT)), options: option, attributes: attributes, context: nil))!.size
//                topicNameLabelFrame = CGRect.init(x: x, y: y, width: topicNameSize.width, height: topicNameSize.height)
//                y += topicNameSize.height + SIZE_GAP_PADDING
//            }
//            
//            // 内容
//            var contentSize = CGSize.zero
//            if item?.content.characters.count == 0 {
//                self.contentLableFrame = CGRect.zero
//                y += contentSize.height
//            } else {
//                let attributes = [NSFontAttributeName: FontWithSize(s: CGFloat(SIZE_FONT_CONTENT))]
//                contentSize = (item?.content.boundingRect(with: CGSize.init(width: contentViewWidth, height: CGFloat(MAXFLOAT)), options: option, attributes: attributes, context: nil))!.size
//                contentLableFrame = CGRect.init(x: x, y: y, width: contentSize.width, height: contentSize.height)
//                y += contentSize.height + SIZE_GAP_PADDING
//            }
//            
//            // 图片
////            if item?.imgCount == 0 {
////                picCollectionViewFrame = CGRect.zero
////                y += 0
////            } else {
////                let picViewSize = caculatePicViewSize(count: item?.imgCount, imageOriginalSize: item.)
////                
////            }
////            if (self.item.imgCount == 0) {
////                self.picCollectionViewFrame = CGRectZero;
////                y += 0;
////            } else {
////                CGSize picSize = [self caculatePicViewSize:self.item.imgCount];
////                self.picCollectionViewFrame = CGRectMake(x, y, picSize.width, picSize.height);
////                y += picSize.height + kSIZE_PIC_BOTTOM;
////                
////            }
////            
////            // 视频图片
////            CGFloat videoImgH = 0.0;
////            if (self.item.videoUrl.length == 0) {
////                // 注意：有视频时，就没有图片，反之亦然
////                videoImgH = 0.0;
////                self.videoImgViewFrame = CGRectZero;
////                y += 0;
////            } else {
////                videoImgH = 160.0;
////                self.videoImgViewFrame = CGRectMake(x, y, self.contentWidth, videoImgH);
////                y += videoImgH + kSIZE_PIC_BOTTOM;
////            }
//
//        }
//    }
//    
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
    
    // 计算collectionView的尺寸
    func caculatePicViewSize(count: Int, imageOriginalSize: CGSize) -> CGSize {
        
        // 以内容的宽度为准，等比例计算高度
        if count == 0 {
            return CGSize.zero
        }
        
        let oneImageHeight = contentViewWidth / imageOriginalSize.width * imageOriginalSize.height
        
        if count == 1 {
            return CGSize.init(width: contentViewWidth, height: oneImageHeight)
        }
        
        let picViewW = contentViewWidth
        let picViewH = CGFloat(count) * oneImageHeight + CGFloat(count-1) * SIZE_PICMARGIN
        
        return CGSize.init(width: picViewW, height: picViewH)
    }
    

    
    
    init(item: XYTrendItem, info: XYHTTPResponseInfo) {
        super.init()
        
        self.item = item
        self.info = info;
    }

}
