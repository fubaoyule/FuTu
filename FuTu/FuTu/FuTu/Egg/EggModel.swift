////
////  EggModel.swift
////  FuTu
////
////  Created by Administrator1 on 5/1/17.
////  Copyright © 2017 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//enum EggTag:Int {
//    case backBtnTag = 10,currentEggTag,resultConfirmBtnTag,purchaseConfirmBtnTag,purchaseHidenViewTag,leftTimeLabelTag
//    case eggsViewTag = 20
//    case eggTapViewTag = 30
//    
//    case purchaseViewTag = 40
//    case purchaseTimeLabelTag = 50
//    case purchaseGivelabelTag = 60
//    case purchaseAmountLabelTag = 70
//    case awardAmountLbelTag = 80
//}
//
//class EggModel: NSObject {
//
//    let touchVoidNumber = 1110
//    //中奖记录信息
//    var recordDataSource:[[Any]] = [["buint02","0.02","12月6日10:38"]]
//    //自己的金蛋信息
//    var infoDataSource:[Any] = [888888.88,0,0]
//    //免费金蛋信息
//    var freeInfoArray:[[Any]]!
//    //获奖提示信息
//    var awardInfoLabel:String = "排队处理中，请稍后刷新查看"
//    
//    
//   // var dataDelegate: eggDataDelegate!
//    
//    let eggInfoAddr = eggApi + "/Jackpot/GetJackpotData"
//    let eggSendMsgAddr = eggApi + "/HitEggMQ/SendHitEggMsg"
//    let eggPurchaseAddr = eggApi + "/Jackpot/payHitTimes"
//    let askPurchaseResultAddr = eggApi + "/Jackpot/getHitPayResult"
//    let askHitEggResultAddr = eggApi + "/HitEggMQ/getHitResult"
//    
//    func getEggInfo(eggToken:String,success:@escaping(()->()),failed:@escaping((String)->())) -> Void {
//        //let token = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//
//        self.eggNetworkRequest(type: .get, serializer: .http, url: eggInfoAddr, params: ["Token":eggToken,"bFromMobile":true], success: { (response) in
////            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
//
//            self.eggInfoDeal(infoString: response, success: {
//                success()
//            }, failed: { (errorInfo) in
//                failed(errorInfo)
//            })
//            
//        }, failure: { (error) in
//            tlPrint(message: "error:\(error)")
//            tlPrint(message: "获取金蛋数据失败")
//            failed("数据获取失败，请检查网络，稍后再试")
//        })
//    }
//    
//    func eggInfoDeal(infoString:Any,success:@escaping(()->()),failed:@escaping((String)->())) -> Void {
//        tlPrint(message: "eggInfoDeal")
//        
//        var string = String(data: infoString as! Data, encoding: String.Encoding.utf8)
//        
//        string = string!.replacingOccurrences(of: "\"{", with: "{")
//        string = string!.replacingOccurrences(of: "}\"", with: "}")
//        string = string!.replacingOccurrences(of: "\\", with: "")
//        //tlPrint(message: "string:\(string)")
//        let eggDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
//        //tlPrint(message: "eggDic:\(eggDic)")
//        let isSuccess = eggDic["Success"] as! Bool
//        if !isSuccess {
//            tlPrint(message: "获取金蛋数据失败")
//            failed("数据获取失败，请检查网络，稍后再试")
//            return
//        }
//        let result = eggDic["Result"]
//        let resultDic = result as! Dictionary<String, Any>
//        tlPrint(message: "resultDic:\(resultDic)")
//        
//        var jackpotEmpty: Bool = false
//        
//        
//        if let jackpotEmpty_t = resultDic["JackpotEmpty"] {
//            jackpotEmpty = jackpotEmpty_t as! Bool
//        } else  {
//            jackpotEmpty = false
//        }
//        
//        //奖池售空
//        if jackpotEmpty {
//            failed("奖池已售空，请稍后再试！")
//            return
//        }
//        let jackpotAmount = resultDic["JackpotAmount"]
//        let hitTimesLeft = resultDic["HitTimesLeft"]
//        let freeChanceList = resultDic["FreeChanceList"] as! Array<Dictionary<String,Any>>
//        for freeInfo in freeChanceList {
//            let freeHitType = freeInfo["FreeHitType"] as! String
//            let freeHitTimes = freeInfo["FreeHitTimes"] as! Int
//            if freeHitTimes > 0 {
//                if self.freeInfoArray == nil {
//                    self.freeInfoArray = [[freeHitType,freeHitTimes]]
//                } else {
//                    self.freeInfoArray .append([freeHitType,freeHitTimes])
//                }
//            }
//            //self.freeInfoArray.append([freeHitType,freeHitTimes])
//        }
//        //self.freeInfoArray.remove(at: 0)
//        tlPrint(message: "self.freeInfoArray:\(self.freeInfoArray)")
//
//        
//        let newAmount = retain2Decima(originString: jackpotAmount as! String)
//        
//        
//        self.infoDataSource = [newAmount,hitTimesLeft!,freeChanceList]
//        
//        
//        let newRecordList = resultDic["NewRecordList"]
//        if let newRecordListDic = newRecordList as? Array<Dictionary<String, Any>> {
//            self.recordDataSource.removeAll()
//            self.recordDataSource = [["buint02","0.02","12月6日10:38"]]
//            for infos in newRecordListDic {
//                let name = infos["UserAccount"]
//                let award = infos["Award"]
//                var date = infos["HitDate"] as! String
//                date = date.replacingOccurrences(of: "T", with: " ")
//                self.recordDataSource.append([name!,award!,date])
//            }
//            self.recordDataSource.remove(at: 0)
//            tlPrint(message: "self.recordDataSource:\(self.recordDataSource)")
//        } else {
//            tlPrint(message: "newRecordList = \(String(describing: newRecordList))")
//        }
////        if self.recordDataSource.count > 0 {
////            self.recordDataSource.remove(at: 0)
////            tlPrint(message: "removed recordDataSource:\(self.recordDataSource)")
////        }
//        tlPrint(message: "recordDataSource:\(self.recordDataSource)")
//        
//        
//        tlPrint(message: "总奖池:\(jackpotAmount!) 奖池是否为空:\(jackpotEmpty)  剩余金蛋数:\(hitTimesLeft!)\n最新获奖名单:\(newRecordList!)")
//        
//        let notify = NSNotification.Name(rawValue: notificationName.eggInfoRefresh.rawValue)
//        NotificationCenter.default.post(name: notify, object: nil)
//        
//        success()
//    }
//    
//    func eggClickedInfoDeal(infoString:Any,success:@escaping(()->()),failed:@escaping((String)->())) -> Void {
//        tlPrint(message: "eggClickedInfoDeal  infoString:\(infoString)")
//        
////        var string = String(data: infoString as! Data, encoding: String.Encoding.utf8)
////        
////        string = string!.replacingOccurrences(of: "\"{", with: "{")
////        string = string!.replacingOccurrences(of: "}\"", with: "}")
////        string = string!.replacingOccurrences(of: "\\", with: "")
////        //tlPrint(message: "string:\(string)")
////        let eggDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
//        //tlPrint(message: "eggDic:\(eggDic)")
//        let eggDic = infoString as! Dictionary<String,Any>
//        let isSuccess = eggDic["Success"] as! Bool
//        tlPrint(message: "eggDic:\(eggDic)")
//        if !isSuccess {
//            tlPrint(message: "success = \(isSuccess)")
//            tlPrint(message: "获取金蛋数据失败")
//            failed("数据获取失败，请检查网络，稍后再试")
//            return
//        }
//        successInfoDeal(eggDic: eggDic)
//        success()
//    }
//    
//    
//    func successInfoDeal(eggDic:Dictionary<String,Any>) -> Void {
//        tlPrint(message: "successInfoDeal")
//        
//        let result = eggDic["Result"]
//        let resultDic = result as! Dictionary<String, Any>
//        tlPrint(message: "resultDic:\(resultDic)")
//        let jackpotAmount = resultDic["JackpotAmount"]
//        
//        
//        let hitTimesLeft = resultDic["HitTimesLeft"]
//        let eggList = resultDic["EggList"] as! Array<Dictionary<String,Any>>
//        
//        var awardAmount = eggList[0]["Amount"]
//        awardAmount = retain2Decima(originString: "\(awardAmount!)")
//        tlPrint(message: "恭喜你获得了\(awardAmount!)元彩金")
//        //发送消息通知告诉前端显示金额
//        let eggAwardInfo = ["amount":"\(awardAmount!)","isNeedLine":false] as [String : Any]
//        let notify = NSNotification.Name(rawValue: notificationName.eggAwardInfo.rawValue)
//        NotificationCenter.default.post(name: notify, object: eggAwardInfo)
//        
//        let freeChanceList = self.infoDataSource[2]
//        //判断小数点后面是否超过两位
//        let newAmountString = String(format: "%.2f", (jackpotAmount as! CGFloat))
//        self.infoDataSource = [newAmountString,hitTimesLeft!,freeChanceList]
//        
//        let newRecordList = resultDic["NewRecordList"]
//        if let newRecordListDic = newRecordList as? Array<Dictionary<String, Any>> {
//            self.recordDataSource.removeAll()
//            self.recordDataSource = [["buint02","0.02","12月6日10:38"]]
//            for infos in newRecordListDic {
//                let name = infos["UserAccount"]
//                var award = infos["Award"]
//                award = retain2Decima(originString: "\(award!)")
//                let newAward = String(format: "%.2f", (award as! NSString).doubleValue)
//                
//                tlPrint(message: "newAward:\(newAward)")
//                var date = infos["HitDate"] as! String
//                date = date.replacingOccurrences(of: "T", with: " ")
//                self.recordDataSource.append([name!,newAward,date])
//            }
//            self.recordDataSource.remove(at: 0)
//            tlPrint(message: "newRecordListDic = \(newRecordListDic) ***********   ******* ***")
//            tlPrint(message: "self.recordDataSource:\(self.recordDataSource)")
//            
//        } else {
//            tlPrint(message: "newRecordList = \(String(describing: newRecordList))")
//        }
//        tlPrint(message: "总奖池:\(jackpotAmount!) 剩余金蛋数:\(hitTimesLeft!)\n最新获奖名单:\(newRecordList!)")
//        let freshNotify = NSNotification.Name(rawValue: notificationName.eggInfoRefresh.rawValue)
//        NotificationCenter.default.post(name: freshNotify, object: nil)
//    
//        
//    }
//    
//    
//    func newListInfoDeal(infoString:Any,success:@escaping(()->()),failed:@escaping((String)->())) -> Void {
//        tlPrint(message: "newListInfoDeal")
//        
//        var string = String(data: infoString as! Data, encoding: String.Encoding.utf8)
//        
//        string = string!.replacingOccurrences(of: "\"{", with: "{")
//        string = string!.replacingOccurrences(of: "}\"", with: "}")
//        string = string!.replacingOccurrences(of: "\\", with: "")
//        //tlPrint(message: "string:\(string)")
//        let eggDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
//        //tlPrint(message: "eggDic:\(eggDic)")
//        let isSuccess = eggDic["Success"] as! Bool
//        if !isSuccess {
//            tlPrint(message: "获取金蛋数据失败")
//            failed("数据获取失败，请检查网络，稍后再试")
//            return
//        }
//        let result = eggDic["Result"]
//        let resultDic = result as! Dictionary<String, Any>
//        tlPrint(message: "resultDic:\(resultDic)")
//        
//        let jackpotEmpty = resultDic["JackpotEmpty"] as! Bool
//        
//        let jackpotAmount = resultDic["JackpotAmount"]
//        let hitTimesLeft = resultDic["HitTimesLeft"]
//        let freeChanceList = resultDic["FreeChanceList"] as! Array<Dictionary<String,Any>>
//        for freeInfo in freeChanceList {
//            let freeHitType = freeInfo["FreeHitType"] as! String
//            let freeHitTimes = freeInfo["FreeHitTimes"] as! Int
//            if freeHitTimes > 0 {
//                if self.freeInfoArray == nil {
//                    self.freeInfoArray = [[freeHitType,freeHitTimes]]
//                } else {
//                    self.freeInfoArray .append([freeHitType,freeHitTimes])
//                }
//            }
//            //self.freeInfoArray.append([freeHitType,freeHitTimes])
//        }
//        //self.freeInfoArray.remove(at: 0)
//        tlPrint(message: "self.freeInfoArray:\(self.freeInfoArray)")
//        
//        
//        
//        self.infoDataSource = [jackpotAmount!,hitTimesLeft!,freeChanceList]
//        let newRecordList = resultDic["NewRecordList"]
//        if let newRecordListDic = newRecordList as? Array<Dictionary<String, Any>> {
//            self.recordDataSource.removeAll()
//            self.recordDataSource = [["buint02","0.02","12月6日10:38"]]
//            
//            for infos in newRecordListDic {
//                let name = infos["UserAccount"]
//                var award = infos["Award"]
//                award = retain2Decima(originString: "\(award!)")
//                var date = infos["HitDate"] as! String
//                date = date.replacingOccurrences(of: "T", with: " ")
//                self.recordDataSource.append([name!,award!,date])
//            }
//            
//        } else {
//            tlPrint(message: "newRecordList = \(String(describing: newRecordList))")
//        }
//        self.recordDataSource.remove(at: 0)
//        tlPrint(message: "recordDataSource:\(self.recordDataSource)")
//        
//        
//        tlPrint(message: "总奖池:\(jackpotAmount!) 奖池是否为空:\(jackpotEmpty)  剩余金蛋数:\(hitTimesLeft!)\n最新获奖名单:\(newRecordList!)")
//        
//        let notify = NSNotification.Name(rawValue: notificationName.eggInfoRefresh.rawValue)
//        NotificationCenter.default.post(name: notify, object: nil)
//        
//        success()
//    }
//    
//    
//    
//    //发送砸蛋请求
//    func sendEggMessage (Index:Int,success:@escaping((String)->())) -> Void {
//        tlPrint(message: "sendEggMessage")
//        
//        var date = NSDate.getDate(type: .all)
//        date = date.replacingOccurrences(of: "/", with: "-")
//        let eggNo = Index
//        let eggToken = userDefaults.value(forKey: userDefaultsKeys.eggToken.rawValue) as! String
//        let orderNo = self.getRandomString()
//        tlPrint(message: "orderNumber:\(orderNo)")
//        var hitType = "Pay"
//        if self.freeInfoArray != nil {
//            tlPrint(message: "freeInfoArray = \(freeInfoArray)")
//            hitType = self.freeInfoArray[0][0] as! String
//        }
//        let bRecordLise = "false"
//        let param = ["JackpotNo":date,"HitEggNo":eggNo,"Token":eggToken,"HitType":hitType,"OrderNo":orderNo,"bRecordList":bRecordLise,"bFromMobile":"true"] as [String : Any]
//        tlPrint(message: "param:\(param)")
//        
//        
//        eggNetworkRequest(type: .get, serializer: .http, url: self.eggSendMsgAddr, params: param, success: { (response) in
//            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
//            
//            string = string!.replacingOccurrences(of: "\"{", with: "{")
//            string = string!.replacingOccurrences(of: "}\"", with: "}")
//            string = string!.replacingOccurrences(of: "\\", with: "")
//             let eggDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
//            tlPrint(message: "eggDic:\(eggDic)")
//            if eggDic["Success"] as! Bool {
//                tlPrint(message: "砸蛋成功")
//                
//                self.eggClickedInfoDeal(infoString: eggDic, success: {
//                    tlPrint(message: "砸蛋后数据处理完毕")
//                    success("砸蛋成功")
//                    
//                }, failed: { (error) in
//                    tlPrint(message: "error:\(error)")
//                })
//                
//                return
//            } else {
//                tlPrint(message: "还没有处理成功")
//                
//                let askParam = ["eggNo":eggNo,"OrderNo":orderNo,"Token":eggToken,"bRecordList":bRecordLise,"JackpotNo":date,"bFromMobile":"true"] as [String : Any]
//                let resultInfo = eggDic["Result"] as! String
//                self.askEggHitResultDeal(string: resultInfo, askParam: askParam, success: { (successResult) in
//                    tlPrint(message: "讯问数据成功＊＊＊＊＊＊＊＊＊＊＊＊")
//                    self.eggClickedInfoDeal(infoString: successResult, success: {
//                        tlPrint(message: "砸蛋后数据处理完毕")
//                        //self.successInfoDeal(eggDic: eggDic)
//                        success("砸蛋成功")
//                        
//                    }, failed: { (error) in
//                        tlPrint(message: "error:\(error)")
//                    })
//                    tlPrint(message: "** ** ** ** result:\(successResult)")
//                })
//            }
//            
//        }, failure: { (error) in
//            tlPrint(message: "error:\(error)")
//        })
//    }
//    //询问砸蛋结果（一次请求在排队的情况下）
//    func askEggHitResult(param:[String:Any],success:@escaping((Dictionary<String, Any>)->())) -> Void {
//        tlPrint(message: "askEggHitResult param:\(param)")
//        
//        eggNetworkRequest(type: .get, serializer: .http, url: self.askHitEggResultAddr, params: param, success: { (response) in
//            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
//            
//            string = string!.replacingOccurrences(of: "\"{", with: "{")
//            string = string!.replacingOccurrences(of: "}\"", with: "}")
//            string = string!.replacingOccurrences(of: "\\", with: "")
//            tlPrint(message: "string:\(String(describing: string))")
//            //let string = self.stringJsonToDic(data: response)
//            let eggDic = (string!).objectFromJSONString() as! Dictionary<String, Any>
//            tlPrint(message: "eggDic:\(eggDic)")
//            usleep(100000)
//            success(eggDic)
//        }, failure: { (error) in
//            tlPrint(message: "error:\(error)")
//        })
//    }
//    //砸蛋结果询问处理函数eggDic
//    func askEggHitResultDeal(string:String,askParam:[String:Any],success:@escaping((Dictionary<String, Any>)->())) -> Void {
//        
//        tlPrint(message: "askEggHitResultDeal")
//        if string.components(separatedBy: "正在排队处理中").count > 1 {
//            self.askEggHitResult(param: askParam, success: { (repsonse) in
////                tlPrint(message: "askEggHitResult:\(repsonse)")
////                let eggDic = self.stringJsonToDic(data: repsonse)
//                let eggDic = repsonse
//                if eggDic["Success"] as! Bool {
//                    tlPrint(message: "第一次讯问取得成功＊＊＊＊＊＊＊＊＊＊")
//                    success(eggDic)
//                    return
//                } else if (eggDic["Result"] as! String).components(separatedBy: "正在排队处理中").count > 1 {
//                    tlPrint(message: "askEggHitResult:\(repsonse)")
//                    self.askEggHitResult(param: askParam, success: { (repsonse) in
//                        let eggDic = repsonse
//                        if eggDic["Success"] as! Bool {
//                            tlPrint(message: "第二次讯问取得成功＊＊＊＊＊＊＊＊＊＊")
//                            success(eggDic)
//                            return
//                        } else if (eggDic["Result"] as! String).components(separatedBy: "正在排队处理中").count > 1 {
//                            tlPrint(message: "askEggHitResult:\(repsonse)")
//                            self.askEggHitResult(param: askParam, success: { (repsonse) in
//                                let eggDic = repsonse
//                                if eggDic["Success"] as! Bool {
//                                    tlPrint(message: "第三次讯问取得成功＊＊＊＊＊＊＊＊＊＊")
//                                    success(eggDic)
//                                    return
//                                } else if (eggDic["Result"] as! String).components(separatedBy: "正在排队处理中").count > 1 {
//                                    tlPrint(message: "askEggHitResult:\(repsonse)")
//                                    //请求三次依然排队中！
////                                    let alert = UIAlertView(title: "提示", message: "正在排队处理中，请稍后刷新查看！", delegate: self, cancelButtonTitle: "确定")
////                                    DispatchQueue.main.async {
////                                        alert.show()
////                                    }
//                                    
//                                    
//                                    
//                                    //发送消息通知告诉前端显示排队中
//                                    let eggAwardInfo = ["amount":"","isNeedLine":true] as [String : Any]
//                                    let notify = NSNotification.Name(rawValue: notificationName.eggAwardInfo.rawValue)
//                                    NotificationCenter.default.post(name: notify, object: eggAwardInfo)
//                                    
//                                    return
//                                    
//                                } else {
//                                    let alert = UIAlertView(title: "提示", message: (eggDic["Result"] as! String), delegate: self, cancelButtonTitle: "确定")
//                                    DispatchQueue.main.async {
//                                        alert.show()
//                                    }
//                                }
//                            })
//                        } else {
//                            let alert = UIAlertView(title: "提示", message: (eggDic["Result"] as! String), delegate: self, cancelButtonTitle: "确定")
//                            DispatchQueue.main.async {
//                                alert.show()
//                            }
//                        }
//                    })
//                } else {
//                    let alert = UIAlertView(title: "提示", message: (eggDic["Result"] as! String), delegate: self, cancelButtonTitle: "确定")
//                    DispatchQueue.main.async {
//                        alert.show()
//                    }
//                }
//            })
//        }
//    }
//    
//    func stringJsonToDic(data:Any) -> Dictionary<String, Any> {
//        tlPrint(message: "stringJsonToDic:\(data)")
////        var string = String(data: data as! Data, encoding: String.Encoding.utf8)
//        var string = (data as! String).replacingOccurrences(of: "\"{", with: "{")
//        string = string.replacingOccurrences(of: "}\"", with: "}")
//        string = string.replacingOccurrences(of: "\\", with: "")
//        tlPrint(message: "string:\(string)")
//        //var string = String(data: data as! Data, encoding: String.Encoding.utf8)
//        let eggDic = (string).objectFromJSONString() as! Dictionary<String, Any>
//        return eggDic
//    }
//    
//    
//    func purchaseEggTimes(Index:Int,success:@escaping((String)->())) -> Void {
//        tlPrint(message: "purchaseEggTimes")
//        let combArray = ["2","10","100","500+2","1000+6","2000+20"]
//        var date = NSDate.getDate(type: .all)
//        date = date.replacingOccurrences(of: "/", with: "-")
//        let comboName = combArray[Index]
//        let eggToken = userDefaults.value(forKey: userDefaultsKeys.eggToken.rawValue) as! String
//        let orderNo = self.getRandomString()
//        tlPrint(message: "orderNumber:\(orderNo)")
//        
//     
//        let param = ["JackpotNo":date,"comboName":comboName,"Token":eggToken,"OrderNo":orderNo]
//        tlPrint(message: "param:\(param)")
//        
//        eggNetworkRequest(type: .get, serializer: .http, url: self.eggPurchaseAddr, params: param, success: { (response) in
//            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
//            
//            string = string!.replacingOccurrences(of: "\"{", with: "{")
//            string = string!.replacingOccurrences(of: "}\"", with: "}")
//            string = string!.replacingOccurrences(of: "\\", with: "")
//            tlPrint(message: "string:\(String(describing: string))")
//            success(string!)
//            
//            
//            
//        }, failure: { (error) in
//            tlPrint(message: "error:\(error)")
//        })
//    }
//    
//    
//    //*********************************************************
//    //         富途体育-金蛋 网络请求函数
//    //*********************************************************
//    func eggNetworkRequest(type:NetworkRequestType,serializer:NetworkRequestType,url:String, params:Dictionary<String, Any>,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) -> Void {
//        tlPrint(message: "eggNetworkRequest")
//        var token:String = ""
//        if let token_t = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue){
//            token = token_t as! String
//        }
////        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//        let url = url
//        tlPrint(message: "networkRequest params:\(params)\nget networkRequest  url:\(url)")
//        let urlString = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//        let manager = AFHTTPSessionManager()
//        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "text/json", "application/json","charset=utf-8","text/javascript","text/html", "application/javascript", "text/js") as? Set<String>
//        manager.securityPolicy.allowInvalidCertificates = true
//        manager.requestSerializer = (serializer == .json ? AFJSONRequestSerializer() : AFHTTPRequestSerializer())
//        manager.responseSerializer = (serializer == .json ? AFJSONResponseSerializer() : AFHTTPResponseSerializer())
//        manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        tlPrint(message: "param:\(params)")
//        DispatchQueue.global().sync {
//            tlPrint(message: "进入了队列")
//            if type == .get {
//                manager.get(urlString, parameters: params, progress: { (downloadProgress) in
//                }, success: { (task, responseObject) in
//                    tlPrint(message: "成功 \n responseObject:\(String(describing: responseObject))")
//                    success(responseObject)
//                }, failure: { (task, error) in
//                    tlPrint(message: "请求失败\n ERROR:\n\(error)")
//                    failure(error)
//                })
//            } else if type == .post {
//                manager.post(urlString, parameters: params, progress: { (downloadProgress) in
//                }, success: { (task, responseObject) in
//                    tlPrint(message: "成功 \n responseObject:\(responseObject)")
//                    success(responseObject)
//                }, failure: { (task, error) in
//                    tlPrint(message: "请求失败\n ERROR:\n\(error)")
//                    failure(error)
//                })
//            }
//        }
//    }
//    
//    
//    
//
////    public func getRandomValue (number:Int) -> String {
////        var valueNumber:UInt32 = 0
////        for _ in 1 ... number {
////            valueNumber = valueNumber * 10 + (arc4random() % 10)
////        }
////        return String(valueNumber)
////    }
//    
//    func getRandomString() -> String {
//        let chars = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz0123456789"
//        var randomString = ""
//        for _ in 0 ..< 32 {
//            let randValue = Int(arc4random() % 48)
//            //tlPrint(message: "randValue:\(randValue)")
//            var char = chars.substring(from: chars.index(chars.startIndex, offsetBy: randValue))
//            char = char.substring(to: chars.index(chars.startIndex, offsetBy: 1))
//            randomString += char
//            //tlPrint(message: "randomString:\(randomString)")
//        }
//        
//        let time = getTime()
//        
//        let returnString = randomString + "_" + time
//        //tlPrint(message: "returnstring:\(returnString)")
//        
//        return returnString
//    }
//    
//    func getTime() -> String {
//        tlPrint(message: "getTime")
//        var time = NSDate.getTime(type: .all)
//        time = time.replacingOccurrences(of: "/", with: "")
//        let random = getRandomValue(number: 3)
//        return time + random
//    }
//    
//    
//
//    
//}
