////
////  EggViewController.swift
////  FuTu
////
////  Created by Administrator1 on 5/1/17.
////  Copyright © 2017 Taylor Tan. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//protocol eggPurchaseDelegate {
//    func eggPuchaseBtnAction(btnTag:Int, selectedTag:Int)
//    
//}
//
//class EggViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, BtnActDelegate,eggPurchaseDelegate {
//
//    var eggView: EggView!
//    var recordDataSource: [[Any]]!
//    var model: EggModel!
//    var avAudioPlayer = AVAudioPlayer()//不能在生命周期函数中定义
//    var eggPurchaseView:UIView!
//    var infoDataSource:[Any]!
//    var freeInfoArray:[[Any]]!
//    var indecator:TTIndicators!
//    
//    var width,height:CGFloat!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.width = self.view.frame.width
//        self.height = self.view.frame.height
//        
//        self.notifyRegister()
//        self.automaticallyAdjustsScrollViewInsets = false
//        eggView = EggView(frame: self.view.frame, rootVC: self,model:self.model)
////        eggView.infoDataSource = self.infoDataSource
////        eggView.freeInfoArray = self.freeInfoArray
//        self.view.addSubview(eggView)
//        self.recordDataSource = model.recordDataSource
//        self.modifyInfoView( )
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        tlPrint(message: "viewWillAppear")
//        //加载背景音乐
//        if let soundURL = Bundle.main.url(forResource: "eggBackgroundMusic2", withExtension: "mp3") {
//            do {
//                avAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//                avAudioPlayer.numberOfLoops = -1 //循环播放
//                avAudioPlayer.prepareToPlay()
//                avAudioPlayer.play()
//                avAudioPlayer.volume = 0.05
//                tlPrint(message: "play")
//            } catch {
//                tlPrint(message: "播放背景音乐错误")
//            }
//        }
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        eggView.lightTimer.invalidate()
//        avAudioPlayer.stop()
//        notifyRemove()
//    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
//    
//    //消息通知注册
//    private func notifyRegister() -> Void {
//        tlPrint(message: "notifyRegister")
//        NotificationCenter.default.addObserver(self, selector: #selector(self.modifyInfoView), name: NSNotification.Name(rawValue: notificationName.eggInfoRefresh.rawValue), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.modifyAwardLabel(notify:)), name: NSNotification.Name(rawValue: notificationName.eggAwardInfo.rawValue), object: nil)
//        
//        
//    }
//    
//    
//    //消息通知注销
//    private func notifyRemove() -> Void {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notificationName.eggInfoRefresh.rawValue), object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notificationName.eggAwardInfo.rawValue), object: nil)
//    }
//    
//    //修改可砸蛋次数
//    func modifyInfoView() -> Void {
//        tlPrint(message: "modifyInfoView")
//        
//        //(self.eggView.infoDataSource[1] as! Int) -= 1
//        
////        self.eggView.pondLabel.text = String(describing: " ¥ \(self.model.infoDataSource[0])")
////        tlPrint(message: " self.eggView.pondLabel.text = \(self.eggView.pondLabel.text)")
////        
////        
////        let leftTime = String(describing: (self.model.infoDataSource[1]))
////        let leftText = "可砸蛋次数 \(leftTime) 次"
////        let attStr = NSMutableAttributedString(string: leftText)
////        attStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithCustom(r: 255, g: 204, b: 0), range: NSRange(location: 5, length: leftTime.characters.count + 2))
////        DispatchQueue.global().async {
////            self.eggView.leftTimeLabel.attributedText = attStr
////        }
//        
////        DispatchQueue.main.async {
////            self.eggView.leftTimeLabel.attributedText = attStr
////        }
//    }
//    
//    //修改获奖金额标签
//    func  modifyAwardLabel(notify:Notification) -> Void {
//        tlPrint(message: "modifyAwardLabel ****************************")
//        let obj = notify.object as AnyObject
//        
//        
//        let isNeedLine = obj.value(forKey: "isNeedLine") as! Bool
//        if self.eggView.resultView == nil {
//            tlPrint(message: "结果视图为空")
//            return
//        }
//        if isNeedLine {
//            tlPrint(message: "isNeedLine = true")
//            self.eggView.resultView.awardAccountLabelInfo = "处理中，请稍后查看"
//            return
//        }
//        
////        var newAmount = (obj.value(forKey: "amount") as! String)
////        let newAmountArray = newAmount.components(separatedBy: ".")
////        if newAmountArray.count > 1 && newAmountArray[1].characters.count > 2 {
////            newAmount = newAmountArray[1].substring(to: newAmountArray[1].index(newAmountArray[1].startIndex, offsetBy: 2))
////            newAmount = newAmountArray[0] + "." + newAmount
////        }
//        let newAmount = retain2Decima(originString: obj.value(forKey: "amount") as! String)
//        self.eggView.resultView.awardAccountLabelInfo = "获得\(newAmount)元彩金"
//        tlPrint(message: "self.eggView.resultView.awardAccountLabelInfo = \(self.eggView.resultView.awardAccountLabelInfo)")
//        
//        
//        //数据拿到以后判断是否需要修改中奖信息
////        if eggView.resultView.accountLabel != nil {
////            let awardLabel = self.eggView.resultView.viewWithTag(EggTag.awardAmountLbelTag.rawValue) as! UILabel
////            DispatchQueue.main.async {
////                awardLabel.text = "获得\(amount)元彩金"
////            }
////        }
//    }
//    
//    
//    func btnAct(btnTag: Int) {
//        tlPrint(message: "btnTag:\(btnTag)")
//        
//        switch btnTag {
//        case EggTag.backBtnTag.rawValue:
//            //刷新首页金额
//            let notify = NSNotification.Name(rawValue: notificationName.HomeAccountValueRefresh.rawValue)
//            NotificationCenter.default.post(name: notify, object: nil)
//            //返回首页
//            _ = self.navigationController?.popViewController(animated: true)
//        case EggTag.resultConfirmBtnTag.rawValue:
//            SystemTool.systemSound(soundNumber: model.touchVoidNumber)
////            eggView.confirmBtnAct()
////            let eggToken = userDefaults.value(forKey: userDefaultsKeys.eggToken.rawValue) as! String
//            
////            self.model.getEggInfo(eggToken: eggToken, success: { 
////                tlPrint(message: "砸完金蛋以后获取信息成功")
////                self.refreshEggData()
////            }, failed: { (error) in
////                tlPrint(message: "砸完金蛋以后获取信息失败：\(error)")
////            })
//            
//            self.refreshEggData()
//        case EggTag.leftTimeLabelTag.rawValue:
//            tlPrint(message: "购买金蛋")
//            eggPurchaseView = EggPurchaseView(frame: self.view.frame, param: "" as AnyObject, rootVC: self)
//            self.view.addSubview(eggPurchaseView)
//        default:
//            if btnTag >= EggTag.eggsViewTag.rawValue && btnTag < EggTag.eggTapViewTag.rawValue{
//                let eggIndex = btnTag - EggTag.eggsViewTag.rawValue + 1
//                tlPrint(message: "选中了\(eggIndex)号蛋")
//                self.freeInfoArray = model.freeInfoArray
//                self.infoDataSource = model.infoDataSource
//                self.recordDataSource = model.recordDataSource
//                var freeTimes = 0
//                if let freeInfos = model.freeInfoArray {
//                    freeTimes = freeInfos.count
//                }
//                if  model.freeInfoArray == nil && ((model.infoDataSource[1] as! Int) + freeTimes) <= 0 {
//
//                    eggPurchaseView = EggPurchaseView(frame: self.view.frame, param: "" as AnyObject, rootVC: self)
//                    self.view.addSubview(eggPurchaseView)
//                    
//                    return
//                }
//                model.sendEggMessage(Index: eggIndex, success: { (response) in
//                    if response == "砸蛋成功" {
//                        tlPrint(message: "恭喜你，砸蛋成功了")
//                        //self.refreshEggData()
//                        //self.recordDataSource = self.model.recordDataSource
//                    
//                        if self.model.freeInfoArray != nil {
//                            
//                            
////                          self.model.freeInfoArray.remove(at: 0)
//                            self.freeInfoArray = self.model.freeInfoArray
//                        }
//                    }
//                })
//            } else {
//                tlPrint(message: "no such case")
//            }
//        }
//    }
//    
//    
//    
//    
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        tlPrint(message: "touchesBegan")
//        SystemTool.systemSound(soundNumber: model.touchVoidNumber)
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        tlPrint(message: "touchesEnded")
////        SystemTool.systemSound(soundNumber: model.touchVoidNumber)
//        if self.eggPurchaseView != nil {
//            for view in self.eggPurchaseView.subviews {
//                view.removeFromSuperview()
//                
//            }
//            eggPurchaseView.removeFromSuperview()
//            eggPurchaseView = nil
//        }
//    }
//    
//    //****************************************
//    //      TablView delegate
//    //****************************************
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tlPrint(message: "numberOfRowsInSection")
//        return self.recordDataSource.count
//    }
//    //返回行高
//    var currentCellHeight:CGFloat!
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        tlPrint(message: "heightForRowAt indexPath:\(indexPath)")
//        return adapt_H(height: isPhone ? 25 : 15)
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        tlPrint(message: "cellForRowAt \(indexPath)")
//        
//        var cell:EggTableViewCell!
////        var cellHeight:CGFloat = adapt_H(height: 120)
//        //self.recordDataSource = self.model.recordDataSource
//        if cell == nil {
//            
//            cell = EggTableViewCell(info: self.recordDataSource[indexPath[1]])
//        }
//        tableView.separatorStyle = .none
//        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        return cell
//    }
//    func eggPuchaseBtnAction(btnTag: Int, selectedTag: Int) {
//        tlPrint(message: "eggPuchaseBtnAction")
//        let amountArray = [2,10,100,500,1000,2000]
//        if self.eggPurchaseView != nil {
//            for view in self.eggPurchaseView.subviews {
//                view.removeFromSuperview()
//            }
//            eggPurchaseView.removeFromSuperview()
//            eggPurchaseView = nil
//        }
//        if indecator == nil {
//            indecator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
//        }
//        indecator.play(frame: portraitIndicatorFrame)
//        if btnTag == EggTag.purchaseConfirmBtnTag.rawValue {
//            tlPrint(message: "选择了第\(selectedTag + 1)个按钮,购买\(amountArray[selectedTag])个金蛋")
//            model.purchaseEggTimes(Index: selectedTag, success: { (response) in
//                
//                let eggDic = response.objectFromJSONString() as! Dictionary<String, Any>
//                tlPrint(message: "eggDic:\(eggDic)")
//                tlPrint(message: "金蛋购买成功，需要同步刷新数据了")
//                let eggToken = userDefaults.value(forKey: userDefaultsKeys.eggToken.rawValue) as! String
//                self.model.getEggInfo(eggToken: eggToken, success: { 
//                    tlPrint(message: "信息已经同步，请刷新页面数据")
//                    
//                    self.refreshEggData()
//                    if self.indecator != nil {
//                        self.indecator.stop()
//                    }
//                }, failed: { (errorInfo) in
//                    tlPrint(message: "errorInfo:\(errorInfo)")
//                })
//            })
//        }
//    }
//    
//    func refreshEggData() -> Void {
//        tlPrint(message: "refreshEggData")
//        self.infoDataSource = self.model.infoDataSource
//        self.freeInfoArray = self.model.freeInfoArray
//        self.recordDataSource = self.model.recordDataSource
//        for view in self.eggView.subviews {
//            view.removeFromSuperview()
//        }
//        self.eggView.removeFromSuperview()
//        self.eggView = EggView(frame: self.view.frame, rootVC: self, model: self.model)
//        self.view.addSubview(self.eggView)
//        self.eggView.infoTable.reloadData()
//    }
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tlPrint(message: "didSelectRowAt:\(indexPath[1])")
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//     
//     
//     */
//
//}
