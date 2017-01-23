//
//  XYHeaderLineView.swift
//  WUO
//
//  Created by mofeini on 17/1/23.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYHeaderLineView: UIView {

    var headerLineItem : XYHeaderLineItem? {
        didSet {
            
        }
    }
    
    lazy var imageView : UIImageView = {
        let view = UIImageView()
        self.addSubview(view)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = UIImage.init(named: "inves_Head")
        
        imageView.mas_makeConstraints { (make) in
            make?.left.top().bottom().equalTo()(self)?.setOffset(0)
            make?.width.equalTo()(80)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
