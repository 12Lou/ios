//
//  videoModel.swift
//  todo
//
//  Created by 子空 on 16/3/4.
//  Copyright © 2016年 子空. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class video {
    var title: String
    var image: String
    var source: String
    var fileType: String
    
    init(title: String , image: String, source:String , fileType: String){
        self.image = image
        self.title = title
        self.source = source
        self.fileType = fileType
    }
}

class videoCell: UITableViewCell {
    
    @IBOutlet weak var bgd: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var source: UILabel!
    
    // 未选中
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        playButt.backgroundColor = UIColor(red: 200, green: 200, blue: 88, alpha: 1)
//        playButt.layer.cornerRadius = 5
        
        
    }
    
    // 选中
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
//    override func setHighlighted(highlighted: Bool, animated: Bool) {
//        
//    }
    

}
