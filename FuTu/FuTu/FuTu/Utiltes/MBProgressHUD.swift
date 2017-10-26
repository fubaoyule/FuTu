//
//  MBProgressHUD.swift
//  FuTu
//
//  Created by Administrator1 on 26/9/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class MBProgressHUD: NSObject {
    
    public func showHudView(view:UIView,mode:MBProgressHUDMode,text:String,textColor:UIColor,animate:Bool,afterDelay:TimeInterval,fonsize:CGFloat) -> MBProgressHUD {
        
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = mode
        hud.label.text = text
        hud.label.font = UIFont(name: "AppleGothic", size: fonsize)
        hud.label.textColor = textColor
        hud.removeFromSuperViewOnHide = true
        hud.hideAnimated(animate, afterDelay: afterDelay)
        return hud
    }

}
