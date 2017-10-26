//
//  Scroll+Extension.swift
//  FuTu
//
//  Created by Administrator1 on 25/8/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit


    
extension UIScrollView {
    override public func  touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.nextResponder()?.touchesBegan(touches, withEvent: event)
    }
    public override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.nextResponder()?.touchesMoved(touches, withEvent: event)
    }
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.nextResponder()?.touchesEnded(touches, withEvent: event)
            
    }
}

