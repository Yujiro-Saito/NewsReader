//
//  RoundedImage.swift
//  NewsReader
//
//  Created by  Yujiro Saito on 2017/10/28.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }

}
