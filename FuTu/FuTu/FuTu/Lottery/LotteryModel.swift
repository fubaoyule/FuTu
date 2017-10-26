//
//  LotteryModel.swift
//  FuTu
//
//  Created by Administrator1 on 18/10/17.
//  Copyright © 2017年 Taylor Tan. All rights reserved.
//

import UIKit



enum lotteryTag:Int {
    case backBtnTag = 10, titleImgTag, selectBgImgTag, cancelBtnTag, confirmBtnTag, winBgImgTag , selectedBgImgTag, resultImgTag
    case numberBallImgTag = 30
    case selectedBallImgTag = 40
}
class LotteryModel: NSObject {

    func getLotteryInfo(success:@escaping((Dictionary<String, Any>)->()),failure:@escaping(()->())) -> Void {
        tlPrint(message: "getRedPacketInfo")
        
        futuNetworkRequest(type: .get, serializer: .http, url: "Active/Grab3Dvivo", params: ["":""], success: { (response) in
            tlPrint(message: "response:\(response)")
            if "\(response)" == "Failed" || "\(response)" == "\"Failed\"" ||  "\(response)" == "" || "\(response)".characters.count <= 1 {
                tlPrint(message: "获取红包数据失败")
                failure()
                return
            }
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            if string!.range(of: "Msg") == nil {
                failure()
                return
            }
            tlPrint(message: "string:\(string)")
            string = string!.replacingOccurrences(of: "\"{", with: "{")
            string = string!.replacingOccurrences(of: "}\"", with: "}")
            string = string!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "string2:\(String(describing: string))")
            
            let lotteryDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
            tlPrint(message: "redPacketDic:\(lotteryDic)")
            success(lotteryDic)
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            failure()
        })
    }
    
    func commitLotteryInfo(selectedNumber:Int,success:@escaping((Dictionary<String, Any>)->()),failure:@escaping(()->())) -> Void {
        tlPrint(message: "getRedPacketInfo")
        let commitUrl = "Active/Select3DCode?in3Dcode=\(selectedNumber)"
        futuNetworkRequest(type: .get, serializer: .http, url: commitUrl, params: nil, success: { (response) in
            tlPrint(message: "response:\(response)")
            if "\(response)" == "Failed" || "\(response)" == "\"Failed\"" ||  "\(response)" == "" {
                tlPrint(message: "获取红包数据失败")
                return
            }
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            string = string!.replacingOccurrences(of: "\"{", with: "{")
            string = string!.replacingOccurrences(of: "}\"", with: "}")
            string = string!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "string2:\(String(describing: string))")
            
            let lotteryDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
            tlPrint(message: "lotteryDic:\(lotteryDic)")
            success(lotteryDic)
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            failure()
        })
    }
    //将多位数整型数据转换为单位整数的数组
    func transferIntToIntArray(value:Int) -> Array<Int> {
        var valueArray = [0,0,0]
        if value == 0 {
            valueArray = []
            return valueArray
        }
        var newValue = value
        for i in 0 ..< 3 {
            valueArray[2 - i] = newValue % 10
            newValue = Int(newValue / 10)
        }
        return valueArray
    }
}
