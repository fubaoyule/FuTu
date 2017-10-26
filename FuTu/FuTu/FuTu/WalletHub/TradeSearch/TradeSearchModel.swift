//
//  TradeSearchModel.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

enum tradeSearchTag:Int {
    case TradeSearchBackBtnTag = 10,DateSelector1,DateSelector2,DateSearchBtnTag,DateSelectConfirmBtnTag
    case TradeSearchTabBtnTag = 20
    case TradeSearchTabLineTag = 25
    
}
enum tradeSearchType:Int {
    case Recharge = 0,Withdraw,Transfer,Bonus
}


class TradeSearchModel: NSObject {

    //导航按钮的名称
    let tabName = ["存款","取款","转账","红利"]
    //导航按钮字体颜色
    let tabBtnColorHigh = UIColor.colorWithCustom(r: 0, g: 101, b: 215)
    let tabBtnColorNormal = UIColor.colorWithCustom(r: 129, g: 129, b: 129)
    
    
    
    //data source
    var dataSource : [[Any]]! = [["加载中","...","交易成功","请耐心等待",""]]
    
    
    func changeData(type:tradeSearchType) -> [[Any]] {
        switch type {
        case tradeSearchType.Recharge:
            dataSource = getRechargeData()
        case tradeSearchType.Withdraw:
            dataSource = getWithdrawData()
        case tradeSearchType.Transfer:
            dataSource = getTransferData()
        case tradeSearchType.Bonus:
            dataSource = getBonusData()
        }
        return dataSource
    }
    
    func getRechargeData() -> [[Any]] {
        let dataSource = [["充值",3000,"","23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-08-21"],
                          ["充值",20000,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-08-21"],
                          ["充值",8000,true,"23423526135341234","2016-08-21"],
                          ["充值",800,false,"23423526135341234","2016-08-21"],
                          ["充值",500,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,false,"23423526135341234","2016-08-21"],
                          ["充值",500,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-08-21"],
                          ["充值",3000,true,"23423526135341234","2016-06-21"]]
        return dataSource
    }
    
    
    func getWithdrawData() -> [[Any]] {
        let dataSource = [["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",234,false,"23423526135341234","2016-08-21"],
                          ["提现",3000,true,"23423526135341234","2016-08-21"],
                          ["提现",456,true,"23423526135341234","2016-08-21"],
                          ["提现",800,false,"23423526135341234","2016-08-21"],
                          ["提现",500,true,"23423526135341234","2016-08-21"],
                          ["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",500,true,"23423526135341234","2016-08-21"],
                          ["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",3000,false,"23423526135341234","2016-08-21"],
                          ["提现",3000,true,"23423526135341234","2016-08-21"]]
        return dataSource
    }
    
    func getTransferData() -> [[Any]] {
        let dataSource = [["转账",3000,false,"23423526135341234","2016-08-21"],
                          ["转账",3000,true,"23423526135341234","2016-08-21"],
                          ["转账",234,true,"23423526135341234","2016-08-21"],
                          ["转账",3000,true,"23423526135341234","2016-08-21"],
                          ["转账",456,true,"23423526135341234","2016-08-21"]]

        return dataSource
    }
    
    func getBonusData() -> [[Any]] {
        let dataSource = [["红利",3,true,"23423526135341234","2016-08-21"],
                          ["红利",3,true,"23423526135341234","2016-08-21"],
                          ["红利",2,true,"23423526135341234","2016-08-21"],
                          ["红利",30,true,"23423526135341234","2016-08-21"],
                          ["红利",45,true,"23423526135341234","2016-08-21"],
                          ["红利",80,false,"23423526135341234","2016-08-21"]]
        return dataSource
    }
    
    
    
    
    func getSearchedData(type:tradeSearchType,startDate:String,endDate:String) -> Void {
        
        let paras = ["searchType": type.rawValue + 1 , "startDate":startDate, "endDate":endDate] as [String : Any]
        tlPrint(message: "parse: \(paras)")
        futuNetworkRequest(type: .post, serializer: .json, url: "Transact/SearchTransactionHistory", params: paras, success: { (response) in
            //tlPrint(message: "response:\(response)")
            
            if self.dataSource != nil {
                self.dataSource.removeAll()
            }
            self.dataSource = [["加载中","...",true,"请耐心等待",""]]
            let itemsArray = response as! NSArray
            for items in itemsArray {
                //tlPrint(message: "items: \(items)")
                let items = (items as! NSDictionary)
                for item in items {
                    if item.key as! String == "TransactionDate" {
                        continue
                    }
                    //tlPrint(message: "item: \(item)")
                    let values = item.value as! NSArray
                    for value in values {
                        let amount = (value as AnyObject).value(forKey: "Amount")!
                        let orderNumber = (value as AnyObject).value(forKey: "OrderNumber")!
                        let transactionDate = (value as AnyObject).value(forKey: "TransactionDate")!
                        let tradeStauts = (value as AnyObject).value(forKey: "TransactionDescription")!
                        tlPrint(message: "**********************   tradeStatus:\(tradeStauts)")
                        
                        //tradeStauts = String(data: tradeStauts as! Data, encoding: String.Encoding.utf8)! as String
                        let data = [self.tabName[type.rawValue], "\(amount)", tradeStauts, "\(orderNumber)", "\(transactionDate)"]
                        self.dataSource.append(data)
                        tlPrint(message: "交易记录状态：")
                        
                    }
                }
            }
            self.dataSource.remove(at: 0)
            tlPrint(message: "new data source:\(self.dataSource)")
            let notify = NSNotification.Name(rawValue: notificationName.TradeSearchInfoTableRefresh.rawValue)
            NotificationCenter.default.post(name: notify, object: nil)
            //通知控制器刷新页面数据
        }, failure: { (error) in
            tlPrint(message: "Error:\(error)")
            let alert = UIAlertView(title: "查询失败", message: "\(error)", delegate: nil, cancelButtonTitle: "确  定")
            DispatchQueue.main.async {
                alert.show()
            }
        })
    }
}
