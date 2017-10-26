////
////  EggView.swift
////  FuTu
////
////  Created by Administrator1 on 5/1/17.
////  Copyright © 2017 Taylor Tan. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class EggView: UIView {
//
//    var delegate: BtnActDelegate!
//    var tableDelegate:UITableViewDelegate!
//    var tableDataSource:UITableViewDataSource!
//    var scroll: UIScrollView!
//    var rootVC: UIViewController!
//    var pondLabel,leftTimeLabel: UILabel!
//    var pondImg,doorLight:UIImageView!
//    var width,height: CGFloat!
//    var model : EggModel!
//    let baseVC = BaseViewController()
//    var resultView: EggResultView!
//    var accountView: UIView!
//    let systemTool = SystemTool()
//    //let audioPlayer = STKAudioPlayer()
//    var avAudioPlayer = AVAudioPlayer()
//    var lightTimer,eggTimer:Timer!
//    var eggMaskView: UIView!
//    var infoTable: UITableView!
//    //自己的金蛋信息
//    var infoDataSource:[Any]!
//    //免费金蛋信息
//    var freeInfoArray:[[Any]]!
//    
//    
//    init(frame:CGRect,rootVC:UIViewController,model:EggModel) {
//        super.init(frame: frame)
//        self.width = frame.width
//        self.height = frame.height
//        self.delegate = rootVC as! BtnActDelegate
//        self.rootVC = rootVC
//        self.model = model
//        self.tableDelegate = rootVC as! UITableViewDelegate
//        self.tableDataSource = rootVC as! UITableViewDataSource
//        self.freeInfoArray = model.freeInfoArray
//        self.infoDataSource = model.infoDataSource
//        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
//        initScrollView()
//    }
//    
//    
//    
//    func initScrollView() -> Void {
//        
//        scroll = UIScrollView(frame: frame)
//        self.addSubview(scroll)
//        scroll.contentSize = CGSize(width: frame.width, height: height + adapt_H(height: 0.5))
//        scroll.showsVerticalScrollIndicator = false
//        scroll.showsHorizontalScrollIndicator = false
//        
//        self.addSubview(scroll)
//        initTitleView()
//        //initDeskView()
//    }
//    
//    private func initTitleView() -> Void {
//        tlPrint(message: "initEggView")
//        //back button
////        let backFrame = CGRect(x: adapt_W(width: 12), y: adapt_H(height: 25), width: adapt_W(width: 35), height: adapt_W(width: 35))
//        let backFrame = CGRect(x: adapt_W(width: isPhone ? 12 : 10), y: adapt_H(height: isPhone ? 25 : 20), width: adapt_W(width: isPhone ? 35 : 25), height: adapt_W(width: isPhone ? 35 : 25))
//        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(btnAct(sender:)), normalImage: UIImage(named: "lobby_PT_back.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
//        self.insertSubview(backBtn, at: 1)
//        backBtn.tag = EggTag.backBtnTag.rawValue
//        
//        // init title background image
//        let titleBackFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: isPhone ? 433 : 300))
//        let titltBackImg = baseVC.imageViewCreat(frame: titleBackFrame, image: UIImage(named:"egg_title_bg.png")!, highlightedImage: UIImage(named:"egg_title_bg.png")!)
//        scroll.addSubview(titltBackImg)
//        
//        
//        //game name image
//        let nameFrame = CGRect(x: adapt_W(width: isPhone ? 0 : 60), y: 0, width: width - adapt_W(width: isPhone ? 0 : 120), height: adapt_H(height: isPhone ? 198 : 130))
//        let nameImg = baseVC.imageViewCreat(frame: nameFrame, image: UIImage(named:"egg_title_name.png")!, highlightedImage: UIImage(named:"egg_title_name.png")!)
//        scroll.insertSubview(nameImg, aboveSubview: titltBackImg)
//        
//        // door light
//        let doorFrame = CGRect(x: adapt_W(width: isPhone ? 0 : 20), y: adapt_H(height: isPhone ? 93 : 65), width: width - adapt_W(width: isPhone ? 0 : 40), height: adapt_H(height: isPhone ? 340 : 240))
//        self.doorLight = baseVC.imageViewCreat(frame: doorFrame, image: UIImage(named:isPhone ? "egg_title_doorLight0.png" : "egg_title_doorLight0_Pad.png")!, highlightedImage: UIImage(named:isPhone ? "egg_title_doorLight0.png" : "egg_title_doorLight0_Pad.png")!)
//        scroll.insertSubview(doorLight, aboveSubview: titltBackImg)
//        
//        //pond light
//        let pondFrame = CGRect(x: adapt_W(width: isPhone ? 45 : 80), y: adapt_H(height: isPhone ? 206 : 140), width: width - adapt_W(width: isPhone ? 90 : 160), height: adapt_H(height: isPhone ? 114 : 80))
//        self.pondImg = baseVC.imageViewCreat(frame: pondFrame, image: UIImage(named:"egg_title_pondLight0.png")!, highlightedImage: UIImage(named:"egg_title_pondLight0.png")!)
//        scroll.insertSubview(pondImg, aboveSubview: titltBackImg)
//
//        lightTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(lightAnimation), userInfo: nil, repeats: true)
//        //pond label
//        let pondLabelFrame = CGRect(x: adapt_W(width: isPhone ? 35 : 25), y: adapt_H(height: isPhone ? 35 : 25), width: pondFrame.width - adapt_W(width: isPhone ? 70 : 50), height: adapt_H(height: isPhone ? 35 : 25))
//        pondLabel = UILabel(frame: pondLabelFrame)
//        pondImg.addSubview(pondLabel)
//        //let amountText = String(format: "%.2f", Int("\(self.infoDataSource[0])")!)
//            let amountText = self.infoDataSource[0]
//        
//        setLabelProperty(label: pondLabel, text: " ¥ \(amountText)", aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: 0))
//        pondLabel.adjustsFontSizeToFitWidth = true
//        pondLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: adapt_W(width: isPhone ? 25 : 18))
//   
//        
//        
//        //desk
//        let deskFrame = CGRect(x: 0, y: titleBackFrame.height, width: width, height: adapt_H(height: isPhone ? 95 : 65))
//        let deskView = baseVC.imageViewCreat(frame: deskFrame, image: UIImage(named:"egg_desk_bg.png")!, highlightedImage: UIImage(named:"egg_desk_bg.png")!)
//        scroll.insertSubview(deskView, at: 3)
//        deskView.clipsToBounds = false
//        for i in 0 ..< 3 {
//            //egg base
//            let baseFrame = CGRect(x: adapt_W(width: isPhone ? (50 + CGFloat(i) * 100) : (83 + CGFloat(i) * 80)), y: adapt_H(height: isPhone ? 435 : 310), width: adapt_W(width: isPhone ? 80 : 60), height: adapt_H(height: isPhone ? 48 : 36))
//            let baseView = baseVC.imageViewCreat(frame: baseFrame, image: UIImage(named:"egg_desk_base\(i).png")!, highlightedImage: UIImage(named:"egg_desk_base\(i).png")!)
//            scroll.insertSubview(baseView, aboveSubview: deskView)
//            
//            //eggs
//            let eggImg = UIImageView(image: UIImage(named:"egg_desk_egg\(i).png"))
//            eggImg.tag = EggTag.eggsViewTag.rawValue + i
//            eggImg.frame = CGRect(x: adapt_W(width: isPhone ? (42 + CGFloat(i) * 100) : (83 + CGFloat(i) * 80)), y: adapt_H(height: isPhone ? 320 : 230), width: adapt_W(width: isPhone ? 90 : 60), height: adapt_H(height: isPhone ? 110 : 73))
//            scroll.insertSubview(eggImg, aboveSubview: baseView)
//            self.floatAnimation(view: eggImg)
//            eggImg.isUserInteractionEnabled = true
//            let eggTap = UITapGestureRecognizer(target: self, action: #selector(self.eggTapAct(sender:)))
//            eggImg.addGestureRecognizer(eggTap)
//        }
//        
//        //剩余砸金蛋次数
//        leftTimeLabel = UILabel(frame: CGRect(x: adapt_W(width: isPhone ? 110 : 140), y: adapt_H(height: isPhone ? 60 : 46), width: width - adapt_W(width: isPhone ? 220 : 280), height: adapt_H(height: isPhone ? 25 : 15)))
//        setLabelProperty(label: leftTimeLabel, text: "", aligenment: .center, textColor: .white, backColor: .colorWithCustom(r: 111, g: 12, b: 46), font: fontAdapt(font: isPhone ? 15 : 10))
//        //let left = self.infoDataSource[1]
//        tlPrint(message: "infodataSource[1] = \(self.infoDataSource[1])")
//        let leftTimes = self.infoDataSource[1] as! Int
//        var freeTimes = 0
//        if let freeTiems_t = self.freeInfoArray {
//            freeTimes = freeTiems_t.count
//        }
//        tlPrint(message: "leftTimes = \(leftTimes)    freeTimes = \(freeTimes)")
//        let left = leftTimes + freeTimes
//        
//        let leftText = "可砸蛋次数 \(left) 次"
//        let attStr = NSMutableAttributedString(string: leftText)
//        attStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithCustom(r: 255, g: 204, b: 0), range: NSRange(location: 5, length: "\(left)".characters.count + 2))
//        leftTimeLabel.attributedText = attStr
//        leftTimeLabel.clipsToBounds = true
//        leftTimeLabel.layer.cornerRadius = adapt_W(width: 5)
//        leftTimeLabel.tag = EggTag.leftTimeLabelTag.rawValue
//        deskView.addSubview(leftTimeLabel)
//        deskView.isUserInteractionEnabled = true
//        leftTimeLabel.isUserInteractionEnabled = true
//        let leftTimeTap = UITapGestureRecognizer(target: self, action: #selector(self.eggTapAct(sender:)))
//        leftTimeLabel.addGestureRecognizer(leftTimeTap)
//        
//        //instance info
//        let backView1 = UIView(frame: CGRect(x: 0, y: titleBackFrame.height + deskFrame.height, width: width, height: height - titleBackFrame.height - deskFrame.height))
//        backView1.backgroundColor = UIColor.colorWithCustom(r: 43, g: 0, b: 84)
//        self.scroll.addSubview(backView1)
//        let backView2 = UIView(frame: CGRect(x: adapt_W(width: 5), y: 0, width: width - adapt_W(width: 10), height: backView1.frame.height))
//        backView2.backgroundColor = UIColor.colorWithCustom(r: 90, g: 4, b: 30)
//        backView1.addSubview(backView2)
//        
//        infoTable = UITableView(frame: CGRect(x: adapt_W(width: 6), y: adapt_H(height: 17), width: width - adapt_W(width: 22), height: backView1.frame.height - adapt_H(height: isPhone ? 17 : 12)), style: .plain)
//        self.addSubview(infoTable)
//        infoTable.separatorStyle = .none
//        infoTable.separatorColor = UIColor.clear
//        infoTable.delegate = self.tableDelegate
//        infoTable.dataSource = self.tableDataSource
//        infoTable.backgroundColor = UIColor.colorWithCustom(r: 110, g: 7, b: 38)
//        backView2.addSubview(infoTable)
//        
//    }
//    //砸金蛋事件处理函数
//    var selectedEgg:UIImageView!
//    var selectedEggFrame:CGRect!
//    func eggTapAct(sender:UITapGestureRecognizer) -> Void {
//        tlPrint(message: "eggTapAct tag:\(sender.view!.tag)")
//        
//        self.delegate.btnAct(btnTag: sender.view!.tag)
//        
//        if sender.view?.tag == EggTag.leftTimeLabelTag.rawValue {
//            tlPrint(message: "用户需要购买金蛋")
//            return
//        }
//        
//        var freeTime = 0
//        if let freeInfos = self.freeInfoArray {
//            freeTime = freeInfos.count
//        }
//        
//        if self.freeInfoArray == nil && self.infoDataSource == nil || ((self.infoDataSource[1] as! Int) + freeTime) <= 0 {
//            tlPrint(message: "砸蛋机会已用完")
//            tlPrint(message: "infoDataSource:\(infoDataSource)\nfreeInfoArray:\(freeInfoArray)")
//            return
//        }
//        
//        
//        tlPrint(message: "infoDataSource:\(infoDataSource)\nfreeInfoArray:\(freeInfoArray)")
//        let egg = self.scroll.viewWithTag(sender.view!.tag) as! UIImageView
//        selectedEgg = egg
//        selectedEggFrame = egg.frame
//        
//        egg.isUserInteractionEnabled = false
//        self.scroll.bringSubview(toFront: egg)
//        //移动金蛋
//        moveAnimation(view: egg,isUnClicked: true)
//        
//        //添加遮罩
//        if self.resultView == nil {
//            self.resultView = EggResultView(frame: self.frame, rootVC: self.rootVC)
//            self.scroll.insertSubview(resultView, belowSubview: egg)
//        } else {
//            self.resultView.isHidden = false
//        }
//        //晃动金蛋
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5), execute: {
//            self.shakeAnimation(view: egg)
//            SystemTool.systemVibration(loopTimes: 1, intervalTime: UInt32(0.1))
//        })
//        //金蛋爆炸效果
//        var clickedView:UIImageView!
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1), execute: {
//            clickedView = self.resultView.initEggClickedView()
//            self.scroll.addSubview(clickedView)
//            egg.isHidden = true
//            
//            //
////            let soundURL = Bundle.main.url(forResource: "eggBombMusic", withExtension: "mp3")
//            if let soundURL = Bundle.main.url(forResource: "eggBombMusic", withExtension: "mp3") {
//                do {
//                    self.avAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//                    self.avAudioPlayer.prepareToPlay()
//                    self.avAudioPlayer.play()
//                } catch {
//                    tlPrint(message: "播放金蛋爆炸音乐错误")
//                }
//            }
//            
//            //self.audioPlayer.play(soundURL!)
//            
//        })
//        //1、播放完爆炸GIF以后将GIF删掉
//        //2、显示获得结果界面
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1.8), execute: {
//            clickedView.removeFromSuperview()
//            clickedView = nil
//            //let soundURL = Bundle.main.url(forResource: "eggResultMusic", withExtension: "mp3")
//            if let soundURL = Bundle.main.url(forResource: "eggResultMusic", withExtension: "mp3") {
//                do {
//                    self.avAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//                    self.avAudioPlayer.prepareToPlay()
//                    self.avAudioPlayer.play()
//                } catch {
//                    tlPrint(message: "播放金蛋结果音乐错误")
//                }
//            }
//            //self.audioPlayer.play(soundURL!)
//
//            self.accountView = self.resultView.initResultView()
//            self.scroll.addSubview(self.accountView)
//        })
//        //1、显示获得结果界面结束，出现确认按钮
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(4), execute: {
//            
//            let confirmBtn = self.resultView.initConfirmBtn()
//            self.scroll.addSubview(confirmBtn)
//        })
//    }
//
//    
//    //抖动动画
//    func shakeAnimation(view:UIView) -> Void {
//        
//        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
//        shake.fromValue = NSNumber(value: -1)
//        shake.toValue = NSNumber(value: 1)
//        shake.duration = 0.05
//        shake.autoreverses = true//是否重复
//        shake.repeatCount = 5
//        view.layer.animation(forKey: "eggShake")
//        view.layer.add(shake, forKey: nil)
//        
//    }
//    
//    //金蛋上下浮动动画
//    func floatAnimation(view:UIView) -> Void {
//        
//        let float = CABasicAnimation(keyPath: "transform.translation.y")
//        float.duration = CFTimeInterval(CGFloat(1.5) + CGFloat(view.tag - EggTag.eggsViewTag.rawValue) * CGFloat(0.2))
//        float.autoreverses = true//是否重复
//        float.repeatCount = HUGE
//        float.isRemovedOnCompletion = false
//        float.fillMode = kCAFillModeForwards
//        float.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        float.fromValue = NSNumber(value: Float(adapt_H(height: view.tag % 2  != 0 ? 10 : -5)))
//        float.toValue = NSNumber(value: Float(adapt_H(height: view.tag % 2  != 0 ? -5 : 10)))
//        view.layer.animation(forKey: "eggFloat")
//        view.layer.add(float, forKey: nil)
//        
//    }
//    //选中金蛋移动动画
//    func moveAnimation(view: UIView,isUnClicked:Bool) -> Void {
//        
//        tlPrint(message: "moveAnimation \(isUnClicked)")
//        let float = CABasicAnimation(keyPath: "transform.translation")
//        float.autoreverses = false//是否重复
//        float.fillMode = kCAFillModeForwards
//        float.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        //float.fromValue = NSNumber(value: 0)
//        if isUnClicked {
//            float.duration = 0.5
//            float.isRemovedOnCompletion = false
//            float.toValue = NSValue(cgPoint: CGPoint(x: -CGFloat(view.tag - EggTag.eggsViewTag.rawValue - 1) * adapt_W(width: isPhone ? 100 : 80 ), y: -adapt_H(height: isPhone ? 130 : 80)))
//        } else {
//            float.duration = 0.0001
//            float.isRemovedOnCompletion = false
//        }
//        view.layer.animation(forKey: "eggFloat")
//        view.layer.add(float, forKey: nil)
//    }
//    
//
//
//    
//    
//    var isChangedLight = true
//    var changeValue:Int!
//    //跑马灯效果
//    func lightAnimation() -> Void {
////        let randValue = getRandomValueInt(number: 2)
//        
////        var pondAccount = self.model.infoDataSource[0] as! Double
//        if isChangedLight {
//            self.doorLight.image = UIImage(named: isPhone ? "egg_title_doorLight1.png" : "egg_title_doorLight1_Pad.png")
//            self.pondImg.image = UIImage(named: "egg_title_pondLight1.png")
////            changeValue = randValue
////            pondAccount += Double(changeValue)
//        } else {
//            self.doorLight.image = UIImage(named: isPhone ? "egg_title_doorLight0.png" : "egg_title_doorLight0_Pad.png")
//            self.pondImg.image = UIImage(named: "egg_title_pondLight0.png")
////            pondAccount -= Double(changeValue)
//        }
//        //改变奖池金额
////        let pondValue = String(format: "%.2f", pondAccount)
////        pondLabel.text = " ¥ \(pondValue)"
//        self.isChangedLight = !isChangedLight
//    }
//    
//    
//    func confirmBtnAct() -> Void {
//        tlPrint(message: "confirmBtnAct")
//        //清除结果界面
//        
//        for view in resultView.subviews {
//            view.removeFromSuperview()
//        }
//        self.resultView.removeFromSuperview()
//        self.resultView = nil
//        self.accountView.removeFromSuperview()
//        self.accountView = nil
//        //清除确定按钮
//        let confirmBtn = self.scroll.viewWithTag(EggTag.resultConfirmBtnTag.rawValue) as! UIButton
//        confirmBtn.removeFromSuperview()
//        
//        //显示出被砸的金蛋
//        selectedEgg.isHidden = false
//        selectedEgg.isUserInteractionEnabled = true
//        moveAnimation(view: selectedEgg, isUnClicked: false)
//        floatAnimation(view: selectedEgg)
//        
//    }
//    
//    func btnAct(sender:UIButton) -> Void {
//        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
//        
//        self.delegate.btnAct(btnTag: sender.tag)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        tlPrint(message: "touchesBegan")
//        SystemTool.systemSound(soundNumber: 1110)
//    }
//
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    
//}
