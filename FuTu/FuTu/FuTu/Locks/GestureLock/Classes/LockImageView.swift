//
//  LockImageView.swift
//  FuTu
//
//  Created by Administrator1 on 12/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class LockImageView: UIImageView {

    var options: LockOptions!
    
    init(frame: CGRect, options: LockOptions) {
        super.init(frame: frame)
        image = UIImage(named: options.backgroundImageName)
        backgroundColor = options.backgroundColor
        self.options = options
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
