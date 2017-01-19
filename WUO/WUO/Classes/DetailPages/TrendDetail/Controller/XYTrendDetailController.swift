//
//  XYTrendDetailController.swift
//  WUO
//
//  Created by mofeini on 17/1/19.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYTrendDetailController: UIViewController {
    
    lazy var tableView : XYTrendDetailTableView = {
        
        return XYTrendDetailTableView()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.white
        view.addSubview(self.tableView)
    }
}
