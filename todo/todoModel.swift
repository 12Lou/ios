//
//  todoModel.swift
//  todo
//
//  Created by 子空 on 16/2/28.
//  Copyright © 2016年 子空. All rights reserved.
//

import UIKit

class todoModel {
    var uid: String
    var title: String
    var sum: String
//    var date: NSDate
    
    // 构造函数
    init(uid: String, title: String, sum: String ) {
        self.uid = uid
        self.title = title
        self.sum = sum
//        self.date = date
    }
    
}
