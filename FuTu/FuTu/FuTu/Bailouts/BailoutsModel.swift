////
////  BailoutsModel.swift
////  FuTu
////
////  Created by Administrator1 on 25/2/17.
////  Copyright © 2017 Taylor Tan. All rights reserved.
////
//
//import UIKit
//enum bailoutsTag:Int {
//    case backBtnTag = 10,getBtnTag, caseTapTag,alergGetBtnTag,shadowViewTapTag
//}
//class BailoutsModel: NSObject {
//
//    
//    let getBailoutsStatusAddr = "FundTransfer/GetRescureStatus"
//    let getBailoutsAmountAddr = "FundTransfer/GetRescureInfo"
//    let getBailoutsAddr = "FundTransfer/GetRescureGold"
//    
//    
//    
//    func getBailoutsStatus(success:@escaping((String,Bool)->())) -> Void {
//        tlPrint(message: "getLeftTime")
//        
//        
//        futuNetworkRequest(type: .get, serializer: .http, url: self.getBailoutsStatusAddr, params: ["":""], success: { (response) in
//            tlPrint(message: "response:\(response)")
//            
//            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
//            string = string!.replacingOccurrences(of: "\"{", with: "{")
//            string = string!.replacingOccurrences(of: "}\"", with: "}")
//            string = string!.replacingOccurrences(of: "\\", with: "")
//            var bailoutsDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
//            tlPrint(message: "bailoutsDic:\(bailoutsDic)")
//            
//            //test data
////            bailoutsDic = ["askAmount": 0, "have_rescure": true, "resureAmount": 0, "lastest_time": "2017-03-15T00:00:00", "msg": "可以领取救援金！"]
//            let alertMsg = bailoutsDic["msg"] as! String
//            let haveRescure =  bailoutsDic["have_rescure"] as! Bool
//            
//            
////            if !(bailoutsDic["have_rescure"] as! Bool) {
////                tlPrint(message: "获取救援金领取状态返回数据 alertMsg:\(alertMsg)")
////                success(alertMsg,false)
////                return
////            }
//            
//            success(alertMsg,haveRescure)
////            self.getBailoutsAmount(success: { (alertMsg) in
////                tlPrint(message: "获取救援金金额返回数据 alertMsg:\(alertMsg)")
////                
////                success(alertMsg,true)
////            })
//            
//            
//            
//        }, failure: { (error) in
//            tlPrint(message: "error:\(error)")
//        })
//        
//    }
//    
//    
//    
//    func getBailoutsAmount(success:@escaping((String,CGFloat)->())) -> Void {
//        tlPrint(message: "getBailoutsAmount")
//        
//        
//        futuNetworkRequest(type: .get, serializer: .http, url: self.getBailoutsAmountAddr, params: ["":""], success: { (response) in
//            tlPrint(message: "response:\(response)")
//            
//            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
//            string = string!.replacingOccurrences(of: "\"{", with: "{")
//            string = string!.replacingOccurrences(of: "}\"", with: "}")
//            string = string!.replacingOccurrences(of: "\\", with: "")
//            var bailoutsDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
//            tlPrint(message: "bailoutsDic:\(bailoutsDic)")
//            //test data
////            bailoutsDic = ["askAmount": 96, "have_rescure": false, "resureAmount": CGFloat(8.0), "lastest_time": "0001-01-01T00:00:00", "msg": "救援金：8.00元,需要流水：96.00,是否领取？"]
//            let bailoutsAmount = bailoutsDic["resureAmount"] as! CGFloat
////            if bailoutsAmount < 1 {
////                let alertMsg = bailoutsDic["msg"] as! String
////                success(alertMsg,bailoutsAmount)
////                return
////            }
//            
//            let alertMsg = bailoutsDic["msg"] as! String
//            success(alertMsg,bailoutsAmount)
////            self.getBailouts(success: { (alertMsg) in
////                tlPrint(message: "获取救援金返回数据 alertMsg:\(alertMsg)")
////                success(alertMsg)
////            })
//            
//        }, failure: { (error) in
//            tlPrint(message: "error:\(error)")
//        })
//    }
//    
//    func getBailouts(success:@escaping((String)->())) -> Void {
//        tlPrint(message: "getBailouts")
//        
//        
//        futuNetworkRequest(type: .get, serializer: .http, url: self.getBailoutsAddr, params: ["":""], success: { (response) in
//            tlPrint(message: "response:\(response)")
//            
//            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
//            string = string!.replacingOccurrences(of: "\"{", with: "{")
//            string = string!.replacingOccurrences(of: "}\"", with: "}")
//            string = string!.replacingOccurrences(of: "\\", with: "")
//            let bailoutsDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
//            tlPrint(message: "bailoutsDic:\(bailoutsDic)")
//            if !(bailoutsDic["Success"] as! Bool) {
//                //test data
////                let bailoutsDic = ["Success":true,"Message":"恭喜，已注入中心钱包！"] as [String : Any]
//                let alertMsg = bailoutsDic["Message"] as! String
//                success(alertMsg)
//                return
//            }
//            
//            
//        }, failure: { (error) in
//            tlPrint(message: "error:\(error)")
//        })
//    }
//    
//
//}
