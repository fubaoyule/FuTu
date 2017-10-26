//
//  NetWork.swift
//  FuTu
//
//  Created by Administrator1 on 29/9/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class NetWork: NSObject {
    
    
    //http get with return & block
    func connectionURLSyn(url:String )->NSString {
        tlPrint(message: "[connectionURLSyn]:\(url)")
        var dataString:NSString = ""
        let url = NSURL(string:url)
        let urlRequest = NSURLRequest(url:url! as URL,cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,timeoutInterval:5)
        //var dataString:NSString?
        var timeout:Bool = false
 
        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue: OperationQueue.main) { (response, data, error) in
            let len = data?.count
            
            tlPrint(message: "len = \(len)")
            if len == nil {
                tlPrint(message: "data.length = \(len)")
                tlPrint(message: "Connect error,please check your network and try again!")

            } else {
                tlPrint(message: "data.length = \(len!)")
            }
            if error == nil && len! > 0{
                dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!//convert to String by NSData
                tlPrint(message: "dataString:  \(dataString)")
            } else {
                if len == nil || len! <= 0{
                    dataString = "Have no data received."
                } else {
                    dataString = "Unknow error"
                }
            }
            timeout = true
        }
        
        
        while !timeout {
            sleep(1)
            tlPrint(message: "waitting...")
        }
        tlPrint(message: "connectionURL end!")
        return dataString
    }
    
    
    
    func networkGet(url: String, params: Dictionary<String, String>) -> Void {
        let manager = AFHTTPRequestOperationManager()
        

        manager.get(url,
                    parameters:     params,
                    success:        { (operation, response) in
                        
                        tlPrint(message: "response:\(response)")
                        
        })
                                    { (operation, error) in
                        tlPrint(message: "error:\(error)")
        }
    }
    

   
}
