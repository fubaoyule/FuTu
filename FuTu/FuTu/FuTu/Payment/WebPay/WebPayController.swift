//
//  WebPayController.swift
//  FuTu
//
//  Created by Administrator1 on 10/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit
import WebKit

class WebPayController: NSObject {

    
    //===========================================
    //Mark:- 网页支付方式处理函数：O2P、
    //===========================================
    class func webPay(sender: AnyObject,wkWebView:WKWebView) -> Void{
        
        tlPrint(message: "sender: \(sender)")
        let message: String = (sender as AnyObject).value(forKey: "Message") as! String
        
        tlPrint(message: "message: \(message)")

        wkWebView.loadHTMLString(message, baseURL: URL.init(fileURLWithPath: Bundle.main.bundlePath))
        
    }
}


















