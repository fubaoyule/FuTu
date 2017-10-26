//
//  HomeViewController.swift
//  FuTu
//
//  Created by Administrator1 on 21/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//
//  tag: 10+

import UIKit

protocol BtnActDelegate {
    func btnAct(btnTag:Int)
    
}
protocol checkLoginStatusDelegate {
    func checkLoginStagus(hasLogin:@escaping(()->()))
}

class HomeViewController: UIViewController,UIAlertViewDelegate, SDCycleScrollViewDelegate, BtnActDelegate,checkLoginStatusDelegate {
    func checkLoginStagus(hasLogin:@escaping(()->())) {
        self.checkLoginStatus {
            hasLogin()
        }
    }

    func btnAct(btnTag: Int) {
        tlPrint(message: "btnAct:\(btnTag)")
        switch btnTag {
        case redPacketTag.bannerBombTapTag.rawValue:
            tlPrint(message: "进入红包界面")
            self.checkLoginStagus(hasLogin: { 
                let redPacketVC = RedPacketViewController(haveStart: self.isStart)
                //redPacketVC.haveStart = self.isStart
                self.navigationController?.pushViewController(redPacketVC, animated: true)
            })
            
        default:
            tlPrint(message: "no such case!")
        }
    }


    let baseVC = BaseViewController()
    let model = HomeModel()
    var amountLabel,noticeLabel: UILabel!
    var notiseScroll, cycleScroll : SDCycleScrollView!
    var scroll: UIScrollView!
    var indicator:TTIndicators!
    var redPacketView: HomeBannerRedView!
    var redInfoDic:Dictionary<String,Any>!
    var startTime,endTime:String!
    var homeLeftTimeTimer,redPacketTimeoutTimer, getTokenTimer: Timer!
    var isStart:Bool = false
    var totalCount:Int!
    let bannerHeight:CGFloat = adapt_H(height: isPhone ? 170 : 100)
    let noticeHeight:CGFloat = adapt_H(height: isPhone ? 34 : 20)
    let titleHeight:CGFloat = adapt_H(height: isPhone ? 100 : 60)
    let loginRegisterHeight:CGFloat = adapt_H(height: isPhone ? 40 : 30)
    
    var titleBtnImg1,titleBtnImg1_start,titleBtnImg2,titleBtnImg3,titleBtnImg3_hammer: UIImageView!
    var titleBtn1, titleBtn2, titleBtn3, imgView1, imgView3, shareBtn:UIButton!
    let userDefaults = UserDefaults.standard
    var width,height,homeHeight:CGFloat!

    let share = ShareViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        width = self.view.frame.width
        height = self.view.frame.height
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if hasLogin as! Bool {
                self.getTokenTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getAccount), userInfo: nil, repeats: true)
            }
        }
        
        
        notifyRegister()
        //初始化滚动视图
        initScrollView()
        //初始化通知条
        getNoticeInfo()
        //初始化功能按钮视图
        initTitleView()
        
        //初始化登录注册视图
        self.initLoginRegisterView()
        //初始化游戏按钮视图
        initGameBtnView()
        //初始化广告滚动视图
        self.model.getHomeBannerInfo { (bannerArray) in
            self.initBannerView(imagesURLStrings: bannerArray)
        }
        //添加下拉刷新
        refreshPull()
        //添加状态栏渐变背景
        initStatuBarBackColor()
        //上线之前必须开启
        self.requestLatestInfo()

//        self.initTestBtn()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        tlPrint(message: "viewWillAppear")
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tlPrint(message: "viewWillDisappear")
        if self.redPacketTimeoutTimer != nil {
            self.redPacketTimeoutTimer.invalidate()
        }
    }

    
    func initTestBtn() -> Void {
        
        let testBtnFrame = CGRect(x: 100, y: 100, width: 200, height: 50)
        let testBtn = baseVC.buttonCreat(frame: testBtnFrame, title: "彩票测试入口", alignment: .center, target: self, myaction: #selector(self.testBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: UIColor.orange, fonsize: 28, events: .touchUpInside)
        self.scroll.addSubview(testBtn)

    }
    func testBtnAct(sender:UIButton) -> Void {
//        let treasuerVC = TreasureBoxViewController()
        let lotteryVC = LotteryViewController()
        self.navigationController?.pushViewController(lotteryVC, animated: true)
    }
    
    
    //===========================================
    //Mark:- set the style of status bar
    //===========================================
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    func getAccount() -> Void {
        //获取中心钱包余额
        if userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) != nil {
            if self.getTokenTimer != nil {
                self.getTokenTimer.invalidate()
            }
            
            futuNetworkRequest(type: .get,serializer: .json, url: model.allAccountUrl, params: ["":""], success: { (response) in
                tlPrint(message: "response:\(response)")
                let value = (response as AnyObject).value(forKey: "Value") as AnyObject
                HomeModel.userInfoDeal(userInfo: value as AnyObject, success: {
                    tlPrint(message: "首页获取信息成功")
                })
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
            })
        }
    }
    
    //消息通知注册
    func notifyRegister() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.modifyAccountLabel), name: NSNotification.Name(rawValue: notificationName.HomeAccountValueModify.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAct), name: NSNotification.Name(rawValue: notificationName.HomeAccountValueRefresh.rawValue), object: nil)
        
    }
    //消息通知注销
    func notifyRemove() -> Void {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notificationName.HomeAccountValueModify.rawValue), object: nil)
        
    }
    
    
    //消息通知改变中心钱包金额,以及隐藏登录按钮
    func modifyAccountLabel() -> Void {
        
        tlPrint(message: "＊＊＊＊＊＊＊＊＊＊＊ 修改中心钱包余额 ＊＊＊＊＊＊＊＊＊＊＊")
        let accountLabel = self.view.viewWithTag(HomeTag.totleAccountLabel.rawValue) as! UILabel
        let accountValue = userDefaults.value(forKey: userDefaultsKeys.userInfoBalance.rawValue)
        tlPrint(message: "中心钱包余额\(String(describing: accountValue))")
        accountLabel.text = "¥\(accountValue!)"
        //登录按钮
//        let loginBtn = self.view.viewWithTag(HomeTag.loginBtnTag.rawValue)
//        if loginBtn == nil{
//            return
//        }
//        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
//            if hasLogin as! Bool {
//                (loginBtn as! UIButton).isHidden = true
//            } else {
//                (loginBtn as! UIButton).isHidden = false
//            }
//        } else {
//            (loginBtn as! UIButton).isHidden = false
//        }

        
        var gameViewY:CGFloat = self.bannerHeight + self.noticeHeight + self.titleHeight + self.loginRegisterHeight + adapt_H(height: 10)
        let gameViewHeight = self.homeHeight - (self.bannerHeight + self.noticeHeight + self.titleHeight + adapt_H(height: 10))
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if hasLogin as! Bool {
                gameViewY = gameViewY - loginRegisterHeight
                self.scroll.contentSize = CGSize(width: width, height: self.homeHeight + 0.1)
            } else {
                self.scroll.contentSize = CGSize(width: width, height: self.homeHeight + self.loginRegisterHeight)
            }
        }
        //热门游戏按钮视图
        let gameView = self.view.viewWithTag(HomeTag.gameVeiwTag.rawValue)!
        UIView.animate(withDuration: 0.2) {
            let viewFrame = CGRect(x: 0, y: gameViewY, width: self.width, height: gameViewHeight)
            gameView.frame = viewFrame
        }
    }
    
    //初始化状态条背景
    func initStatuBarBackColor() -> Void {
        
        let statusBarImg = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        self.view.addSubview(statusBarImg)
        statusBarImg.image = UIImage(named: "home_statusBar_img.png")
        
    }
    
    func initScrollView() -> Void {
        tlPrint(message: "initScrollView")
        let scrollHeight = height - tabBarHeight
        homeHeight = height - tabBarHeight
        let scrollFrame = CGRect(x: 0, y: 0, width: width, height: scrollHeight)
        scroll = UIScrollView(frame: scrollFrame)
        scroll.contentSize = CGSize(width: width, height: self.homeHeight + loginRegisterHeight)
//        scroll.contentSize = CGSize(width: width, height: self.homeHeight + adapt_H(height: 10))
        scroll.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.view.addSubview(scroll)
    }
    
    //===========================================
    //Mark:- initialize scroll view for advertisement
    //===========================================
    func initBannerView(imagesURLStrings:[String]) -> Void {
        tlPrint(message: "initScrollView")
        
        let scrollFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: (isPhone ? 170 : 100)))
        
        cycleScroll = SDCycleScrollView(frame: scrollFrame , delegate: self, placeholderImage: UIImage(named:"auto-image.png"))
        cycleScroll?.autoScrollTimeInterval = 4
        cycleScroll?.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        cycleScroll?.currentPageDotColor = UIColor.white // define the color of page controller.
        self.scroll.insertSubview(cycleScroll, at: 0)
        DispatchQueue.main.async {
            self.cycleScroll?.imageURLStringsGroup = imagesURLStrings
            //礼盒  **********************************************
            self.model.getGiftBoxStatus(success: { 
                self.initGiftBoxBtn()
            }, failed: { tlPrint(message: "礼盒未开启") })
            //宝箱  **********************************************
            self.initTreasureBoxBtn()
            
            
            //红包  **********************************************
            let redPacketModel = RedPacketModel()
            redPacketModel.getRedPacketInfo(success: { (redInfoDic) in
                tlPrint(message: "首页获取红包数据成功：\(redInfoDic)")
                //没有红包则不实现倒计时
                var endTime = redInfoDic["endTime"] as! String
                endTime = endTime.replacingOccurrences(of: "T", with: " ")
                let redPacketModel = RedPacketModel()
                let isStop = redPacketModel.timeOutCalculate(end: endTime)
                if isStop {
                    return
                }
                self.initRedPaketBtn()
                //换成浮动的方式
                self.isStart = redInfoDic["haveRedbag"] as! Bool
            }, failure: {
                tlPrint(message: "获取红包数据失败")
            })
            //3D福利彩票  **********************************************
            self.initLotteryBtn()
        }
        cycleScroll.tag = HomeTag.bannerScroll.rawValue
        cycleScroll.isUserInteractionEnabled = true
    }
    
    
    func initShareBtn() -> Void {
        
        //        let shareBtn = baseVC.buttonCreat(frame: CGRect(x:0,y:0,width:0,height:0), title: "", alignment: .center, target: self, myaction: #selector(ShareBtnAct), normalImage: UIImage(named:"home_share.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        self.shareBtn = baseVC.buttonCreat(frame: CGRect(x:0,y:0,width:0,height:0), title: "", alignment: .center, target: self, myaction: #selector(ShareBtnAct), normalImage: UIImage(named:"home_share.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        //        self.cycleScroll.addSubview(shareBtn)
        //        self.cycleScroll.bringSubview(toFront: shareBtn)
        self.scroll.addSubview(shareBtn)
        self.scroll.bringSubview(toFront: shareBtn)
        shareBtn.frame = CGRect(x: width - adapt_W(width: isPhone ? 55 : 40), y: adapt_H(height: isPhone ? 25 : 15), width: adapt_W(width: isPhone ? 40 : 25), height: adapt_W(width: isPhone ? 40 : 25))
        
        //        shareBtn.mas_makeConstraints { (make) in
        //            _ = make?.top.equalTo()(adapt_H(height: isPhone ? 25 : 15))
        //            _ = make?.right.equalTo()(adapt_W(width: isPhone ? -12 : -10))
        //            _ = make?.width.equalTo()(adapt_W(width: isPhone ? 40 : 30))
        //            _ = make?.height.equalTo()(adapt_W(width: isPhone ? 40 : 30))
        //        }
    }
    
    
    
    //分享按钮事件处理
    func ShareBtnAct() -> Void {
        tlPrint(message: "ShareBtnAct")
        
        //获取代理编码
        let getAgentCodeUrl = "Commission/GetAgentCode"
        let getShortUrl = "Share/GetShortUrl"
        let getActiveUrl = "Active/GetRndActive"
        
        if self.indicator == nil {
            self.indicator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
        }
        self.indicator.play(frame: portraitIndicatorFrame)
        
        
        futuNetworkRequest(type: .get, serializer: .http, url: getAgentCodeUrl, params: ["":""], success: { (response) in
            var agentCode = String(data: response as! Data, encoding: String.Encoding.utf8)
            agentCode = agentCode!.replacingOccurrences(of: "\"", with: "")
            agentCode = agentCode!.replacingOccurrences(of: "\\", with: "")
            agentCode = agentCode!.replacingOccurrences(of: " ", with: "")
            tlPrint(message: "agentCode:\(agentCode)")
            
            let domain = self.userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
            let param = ["longUrl":"\(domain)?\(agentCode!)"]
            
            //获取短域名
            futuNetworkRequest(type: .get, serializer: .http, url: getShortUrl, params: param, success: { (response) in
                var shortUrl = String(data: response as! Data, encoding: String.Encoding.utf8)
                shortUrl = shortUrl!.replacingOccurrences(of: "[", with: "")
                shortUrl = shortUrl!.replacingOccurrences(of: "]", with: "")
                let shortUrlDic = (shortUrl)?.objectFromJSONString() as! Dictionary<String, Any>
                tlPrint(message: "shortUrlDic:\(shortUrlDic)")
                shortUrl = shortUrlDic["url_short"] as! String
                tlPrint(message: "shortUrl:\(shortUrl)")
                
                //获取内容
                futuNetworkRequest(type: .get, serializer: .http, url: getActiveUrl, params: ["":""], success: { (response) in
                    tlPrint(message: "active url response:\(response)")
                    var active = String(data: response as! Data, encoding: String.Encoding.utf8)
                    tlPrint(message: "active1:\(active!)")
                    active = active!.replacingOccurrences(of: "\"{", with: "{")
                    active = active!.replacingOccurrences(of: "}\"", with: "}")
                    active = active!.replacingOccurrences(of: "\\", with: "")
                    tlPrint(message: active!)
                    let activeArray1 = active!.components(separatedBy: "\"SubTitle\":")
                    if activeArray1.count < 2 {
                        self.indicator.stop()
                        self.shareFailedAlert()
                        return
                    }
                    
                    let activeArray2 = activeArray1[1].components(separatedBy: ",\"ImageLink\"")
                    if activeArray2.count < 2 {
                        self.indicator.stop()
                        self.shareFailedAlert()
                        return
                    }
                    let imageInfo = "\"ImageLink\"" + activeArray2[1]
                    active = activeArray1[0] + imageInfo
                    tlPrint(message: active!)
                    let activeDict = (active)?.objectFromJSONString() as! Dictionary<String, Any>
                    tlPrint(message: activeDict)
                    let shareTitle = activeDict["MainTitle"]
                    //                    var shareImgUrl = domain + (activeDict["ImageLink"] as! String)
                    var shareImgUrl = "www.toobet.com/" + (activeDict["ImageLink"] as! String)
                    shareImgUrl = shareImgUrl.replacingOccurrences(of: "//", with: "/")
                    //获取到数据，开始弹出分享框
                    let info = ["content": shareTitle!, "src": shortUrl!, "title": "富途娱乐", "urlImg": shareImgUrl]
                    
                    tlPrint(message: "--->> info : \(info)\n\n***************")
                    
                    self.indicator.stop()
                    self.share.showActionSheet(info)//此方法为弹出分享窗
                    
                    
                }, failure: { (error) in
                    tlPrint(message: "active error:\(error)")
                    self.indicator.stop()
                    self.shareFailedAlert()
                })
                
            }, failure: { (error) in
                tlPrint(message: "short url error:\(error)")
                self.indicator.stop()
                self.shareFailedAlert()
            })
            
        }, failure: { (error) in
            tlPrint(message: "agent code error:\(error)")
            self.indicator.stop()
            self.shareFailedAlert()
        })
    }
    
    func shareFailedAlert() -> Void {
        let alert = UIAlertView(title: "", message: "分享失败", delegate: nil, cancelButtonTitle: "确定")
        DispatchQueue.main.async {
            alert.show()
        }
    }
    
    //初始化登陆注册按钮视图
    func initLoginRegisterView() -> Void {
        tlPrint(message: "initLoginBtn")
//        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
//            if (hasLogin as! Bool) {
//                tlPrint(message: "已经登录，无需显示登录按钮")
//                return
//            }
//        }
        let loginRegView = UIView(frame: CGRect(x: 0, y: bannerHeight + titleHeight + noticeHeight + adapt_H(height: 10), width: width, height: loginRegisterHeight - adapt_H(height: 1)))
//        self.scroll.insertSubview(loginRegView, at: 1)
        self.scroll.addSubview(loginRegView)
        loginRegView.tag = HomeTag.loginRegisterViewTag.rawValue
        loginRegView.backgroundColor = UIColor.white
        let loginWidth = adapt_W(width: isPhone ? 110 : 70)
        let loginXArray = [adapt_W(width: 50),width - loginWidth - adapt_W(width: 50)]
        let lgoinImgArray = ["home_loginBtn.png","home_registerBtn.png"]
        for i in 0 ..< 2 {
            
            let loginFrame = CGRect(x: loginXArray[i], y: adapt_H(height: isPhone ? 5 : 3), width: loginWidth, height: adapt_W(width: isPhone ? 30 : 20))
            let loginBtn = baseVC.buttonCreat(frame: loginFrame, title: "", alignment: .center, target: self, myaction: #selector(btnAct(sender:)), normalImage: UIImage(named:lgoinImgArray[i]), hightImage: UIImage(named:lgoinImgArray[i]), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
            loginBtn.setTitleColor(UIColor.red, for: .normal)
            loginBtn.tag = HomeTag.loginBtnTag.rawValue + i
            loginRegView.addSubview(loginBtn)
        }
    }
    
    func initGiftBoxBtn() -> Void {
        
        let giftBoxBtn = baseVC.buttonCreat(frame: CGRect(x: width - adapt_W(width: isPhone ? 80 : 60), y: adapt_H(height: isPhone ? 55 : 30), width: adapt_W(width: isPhone ? 63 : 40), height: adapt_W(width: isPhone ? 63 : 40)), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"GiftBox_homeBtnImg.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.scroll.addSubview(giftBoxBtn)
        self.scroll.bringSubview(toFront: giftBoxBtn)
        giftBoxBtn.tag = HomeTag.giftBoxBtnTag.rawValue
        self.floatAnimation(view: giftBoxBtn, duration: 3.0, fromValue: 15.0, toValue: -12.0)
        self.shakeAnimation(view: giftBoxBtn, duration: 1.0, fromValue: NSNumber(value: -0.3), toValue: NSNumber(value: 0.3))
        
    }
    //初始化开宝箱入口
    func initTreasureBoxBtn() -> Void {
        
        let TreasureBoxBtn = baseVC.buttonCreat(frame: CGRect(x: adapt_W(width: isPhone ? 17 : 20), y: adapt_H(height: isPhone ?
            55 : 30), width: adapt_W(width: isPhone ? 63 : 40), height: adapt_W(width: isPhone ? 63 : 40)), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"TreasureBox_home_logo.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.scroll.addSubview(TreasureBoxBtn)
        self.scroll.bringSubview(toFront: TreasureBoxBtn)
        TreasureBoxBtn.tag = HomeTag.treasureBoxBtnTag.rawValue
        self.floatAnimation(view: TreasureBoxBtn, duration: 4.0, fromValue: -15.0, toValue: 15.0)
        self.shakeAnimation(view: TreasureBoxBtn, duration: 1.0, fromValue:NSNumber(value: 0.3), toValue: NSNumber(value: -0.3))
        TreasureBoxBtn.isHidden = true
    }
    
    //首页红包入口
    func initRedPaketBtn() -> Void {
        
        let redPaketBtn = baseVC.buttonCreat(frame: CGRect(x: width - adapt_W(width: isPhone ? 80 : 60), y: adapt_H(height: isPhone ? 55 : 30), width: adapt_W(width: isPhone ? 63 : 40), height: adapt_W(width: isPhone ? 70 : 45)), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"redPacket_HomeLogo.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.scroll.addSubview(redPaketBtn)
        self.scroll.bringSubview(toFront: redPaketBtn)
        redPaketBtn.tag = HomeTag.redPacketBtnTag.rawValue
        self.floatAnimation(view: redPaketBtn, duration: 3.0, fromValue: 15.0, toValue: -12.0)
        self.shakeAnimation(view: redPaketBtn, duration: 1.0, fromValue: NSNumber(value: -0.3), toValue: NSNumber(value: 0.3))
        
    }
    
    //初始化3D福利彩票入口
    func initLotteryBtn() -> Void {
        
        let lotteryBtn = baseVC.buttonCreat(frame: CGRect(x: width - adapt_W(width: isPhone ? 110 : 70), y: adapt_H(height: isPhone ? 35 : 20), width: adapt_W(width: isPhone ? 100 : 60), height: adapt_W(width: isPhone ? 110 : 70)), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:"lottery_home.png"), hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        self.scroll.addSubview(lotteryBtn)
        self.scroll.bringSubview(toFront: lotteryBtn)
        lotteryBtn.tag = HomeTag.lotteryBtnTag.rawValue
        self.floatAnimation(view: lotteryBtn, duration: 4.0, fromValue: -15.0, toValue: 15.0)
        self.shakeAnimation(view: lotteryBtn, duration: 1.0, fromValue:NSNumber(value: 0.2), toValue: NSNumber(value: -0.2))
    }
    
    
    //宝箱上下浮动动画
    func floatAnimation(view:UIView,duration:CGFloat,fromValue:Float,toValue:Float) -> Void {
        
        let float = CABasicAnimation(keyPath: "transform.translation.y")
        float.duration = CFTimeInterval(duration)
        float.autoreverses = true//是否重复
        float.repeatCount = HUGE
        float.isRemovedOnCompletion = false
        float.fillMode = kCAFillModeForwards
        float.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        float.fromValue = NSNumber(value: fromValue)
        float.toValue = NSNumber(value: toValue)
        view.layer.animation(forKey: "caseFloat")
        view.layer.add(float, forKey: nil)
    }
    
    //宝箱晃动动画
    func shakeAnimation(view:UIView,duration: CGFloat, fromValue:NSNumber, toValue:NSNumber) -> Void {
        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
        shake.fromValue = fromValue
        shake.toValue = toValue
        shake.duration = CFTimeInterval(duration)
        shake.autoreverses = true//是否重复
        shake.repeatCount = HUGE
        shake.isRemovedOnCompletion = false
        shake.fillMode = kCAFillModeForwards
        shake.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.animation(forKey: "caseShake")
        view.layer.add(shake, forKey: nil)
        
    }
    
    //===========================================
    //Mark:- initialize the notice info view
    //===========================================
    private func initNoticeView(notice: Array<String>) -> Void {
        
        //init notice picture background view
        let noticeFrame = CGRect(x: 0, y: adapt_H(height: (isPhone ? 170 : 100)), width: width, height: adapt_H(height: isPhone ? 34 : 20))
        let noticeView = baseVC.viewCreat(frame: noticeFrame, backgroundColor: model.noticeBackColor)
        self.scroll.addSubview(noticeView)
        
        //init notice image
        let yellowLabel = UILabel()
        noticeView.addSubview(yellowLabel)
        yellowLabel.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(adapt_W(width: 12))
            _ = make?.centerY.equalTo()(noticeView.mas_centerY)
            _ = make?.width.equalTo()(adapt_W(width: 3))
            _ = make?.height.equalTo()(adapt_H(height: 12))
        }
        yellowLabel.backgroundColor = model.yellowLabelColor
        
        //initialize advertise scroll view
        let noticeScrollFrame = CGRect(x: adapt_W(width: 16), y: 0, width: width - adapt_W(width: 28), height:noticeFrame.height)
        notiseScroll = SDCycleScrollView(frame: noticeScrollFrame, delegate: self, placeholderImage: nil)
        noticeView.addSubview(notiseScroll!)
        notiseScroll?.scrollDirection = UICollectionViewScrollDirection.vertical
        notiseScroll?.onlyDisplayText = true
        notiseScroll?.titleLabelBackgroundColor = UIColor.clear
        notiseScroll.titleLabelTextColor = model.noticeTextColer
        notiseScroll.titleLabelTextFont = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 12 : 10))
        notiseScroll?.autoScrollTimeInterval = self.model.noticeTimeInterval
        self.notiseScroll.titlesGroup = notice
        notiseScroll.tag = HomeTag.noticeScroll.rawValue
    }
    
    
    //===========================================
    //Mark:- initialize the title view
    //===========================================
    func initTitleView() -> Void {
        tlPrint(message: "initTitleView")
        let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        //initialize title view
        let titleY = adapt_H(height: isPhone ? 204 : 120)
        let titleFrame = CGRect(x: 0, y: titleY, width: width, height: adapt_H(height: isPhone ? 155 : 140))
        let titleView = baseVC.viewCreat(frame: titleFrame, backgroundColor: model.titleViewBackColor)
        self.scroll.addSubview(titleView)

        //initialize share button
        let btnDistX = adapt_W(width: 5)
        let btnDistY = adapt_H(height: 5)
        
        let btnWidth1 = (width*2/3-4*btnDistX)/2
        let btnWidth2 = width/3
        titleBtn1 = baseVC.buttonCreat(frame: initFrame, title: "", alignment: .center, target: self, myaction: #selector(titleBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 12, events: .touchUpInside)
        titleView.addSubview(titleBtn1)
        titleBtn1.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(btnDistX)
            _ = make?.left.equalTo()(btnDistY)
            _ = make?.width.equalTo()(btnWidth1)
            _ = make?.height.equalTo()(self.titleHeight)
        }
        titleBtn1.layer.cornerRadius = model.titleBtnCorner
        titleBtn1.tag = 10
        
        //*********   init share image
        let imgViewHieght = adapt_W(width: isPhone ? 50 : 30)
        imgView1 = UIButton()
        imgView1.tag = 10
        imgView1.addTarget(self, action: #selector(titleBtnAct(sender:)), for: .touchUpInside)
        titleBtn1.addSubview(imgView1)
        imgView1.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height: isPhone ? 3 : 8))
            _ = make?.centerX.equalTo()(self.titleBtn1.mas_centerX)
            _ = make?.width.equalTo()(imgViewHieght)
            _ = make?.height.equalTo()(imgViewHieght)
        }
        //diamond
        titleBtnImg1 = UIImageView()
        imgView1.addSubview(titleBtnImg1)
        titleBtnImg1.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(imgViewHieght * 0.2)
            _ = make?.centerX.equalTo()(self.titleBtn1.mas_centerX)
            _ = make?.width.equalTo()(imgViewHieght * 0.8)
            _ = make?.height.equalTo()(imgViewHieght * 0.8)
        }
        titleBtnImg1.image = UIImage(named: "home_title_recharge.png")
        //init share button name
        let titleBtnLabel1 = UIImageView()
        titleBtn1.addSubview(titleBtnLabel1)
        titleBtnLabel1.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.imgView1.mas_bottom)?.setOffset(adapt_H(height: 10))
            _ = make?.centerX.equalTo()(self.imgView1.mas_centerX)
            _ = make?.width.equalTo()(imgViewHieght)
            _ = make?.height.equalTo()(imgViewHieght * 0.25)
        }
        titleBtnLabel1.image = UIImage(named: "home_title_rechargeText.png")
        
        //*********  initialize account button
        titleBtn2 = baseVC.buttonCreat(frame: initFrame, title: "", alignment: .center, target: self, myaction: #selector(titleBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 12, events: .touchUpInside)
        titleView.addSubview(titleBtn2)
        titleBtn2.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(btnDistX)
            _ = make?.left.equalTo()(self.titleBtn1.mas_right)?.setOffset(btnDistY)
            _ = make?.width.equalTo()(btnWidth2)
            _ = make?.height.equalTo()(self.titleHeight)
        }
        titleBtn2.layer.cornerRadius = model.titleBtnCorner
        titleBtn2.tag = 11
  
        titleBtnImg2 = UIImageView()
        titleBtn2.addSubview(titleBtnImg2)
        titleBtnImg2.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height: isPhone ? 8 : 18))
            _ = make?.centerX.equalTo()(self.titleBtn2.mas_centerX)
            _ = make?.width.equalTo()(imgViewHieght)
            _ = make?.height.equalTo()(imgViewHieght)
        }
        titleBtnImg2.image = UIImage(named: "home_title_dollar.png")
        //init account button name
        let titleBtnLabel2 = UIImageView()
        titleBtn2.addSubview(titleBtnLabel2)
        titleBtnLabel2.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.titleBtnImg2.mas_bottom)?.setOffset(adapt_H(height: 5))
            _ = make?.centerX.equalTo()(self.titleBtnImg2.mas_centerX)
            _ = make?.width.equalTo()(imgViewHieght)
            _ = make?.height.equalTo()(imgViewHieght * 0.25)
        }
        titleBtnLabel2.image = UIImage(named: "home_title_dollarText.png")
        
        //init the label of amount.
        var amountText = ""
        if let amount = userDefaults.value(forKey: userDefaultsKeys.userInfoBalance.rawValue) {
            if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
                if hasLogin as! Bool {
                    amountText = "¥\(amount)"
                }
            }
        }
        amountLabel = baseVC.labelCreat(frame: initFrame, text: amountText, aligment: .center, textColor: model.amountTextColor, backgroundcolor: .clear, fonsize:fontAdapt(font: 16))
        titleBtn2.addSubview(amountLabel)
        amountLabel.tag = HomeTag.totleAccountLabel.rawValue
        amountLabel.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(titleBtnLabel2.mas_bottom)?.setOffset(adapt_H(height: 10))
            _ = make?.centerX.equalTo()(titleBtnLabel2.mas_centerX)
            _ = make?.width.equalTo()(imgViewHieght * 2)
            _ = make?.height.equalTo()(imgViewHieght * 0.25)
        }
        
        //***********  initialize egg button
        titleBtn3 = baseVC.buttonCreat(frame: initFrame, title: "", alignment: .center, target: self, myaction: #selector(titleBtnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 12, events: .touchUpInside)
        titleView.addSubview(titleBtn3)
        titleBtn3.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(btnDistX)
            _ = make?.left.equalTo()(self.titleBtn2.mas_right)?.setOffset(btnDistY)
            _ = make?.width.equalTo()(btnWidth1)
            _ = make?.height.equalTo()(self.titleHeight)
        }
        titleBtn3.layer.cornerRadius = model.titleBtnCorner
        titleBtn3.tag = 12
        
        //button image view
        imgView3 = UIButton()
        imgView3.tag = 12
        imgView3.addTarget(self, action: #selector(titleBtnAct(sender:)), for: .touchUpInside)
        titleBtn3.addSubview(imgView3)
        imgView3.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height: isPhone ? 0 : 8))
            _ = make?.centerX.equalTo()(self.titleBtn3.mas_centerX)
            _ = make?.width.equalTo()(imgViewHieght)
            _ = make?.height.equalTo()(imgViewHieght)
        }
        //egg
        titleBtnImg3 = UIImageView()
        imgView3.addSubview(titleBtnImg3)
        titleBtnImg3.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(imgViewHieght * 0.2)
            _ = make?.centerX.equalTo()(self.titleBtn3.mas_centerX)
            _ = make?.width.equalTo()(imgViewHieght * 0.8)
            _ = make?.height.equalTo()(imgViewHieght * 0.8)
        }
        titleBtnImg3.image = UIImage(named: "home_title_withdraw.png")

        //init egg button name
        let titleBtnLabel3 = UIImageView()
        titleBtn3.addSubview(titleBtnLabel3)
        titleBtnLabel3.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.imgView3.mas_bottom)?.setOffset(adapt_H(height: 10))
            _ = make?.centerX.equalTo()(self.titleBtnImg3.mas_centerX)
            _ = make?.width.equalTo()(imgViewHieght)
            _ = make?.height.equalTo()(imgViewHieght * 0.25)
        }
        titleBtnLabel3.image = UIImage(named: "home_title_withdrawText.png")
    }
    
    
    //===========================================
    //Mark:- initialize the game button view
    //===========================================
    private func initGameBtnView() -> Void {
        //initialize view of game button
        
//        let gameViewY:CGFloat = adapt_H(height: (isPhone ? 315 : 235))
//        let gameViewHeight = self.homeHeight - adapt_H(height: bannerHeight + noticeHeight + titleHeight) - tabBarHeight - adapt_H(height: 10)
        
        let gameViewY:CGFloat = bannerHeight + noticeHeight + titleHeight + loginRegisterHeight + adapt_H(height: 10)
        let gameViewHeight = self.homeHeight - (bannerHeight + noticeHeight + titleHeight + adapt_H(height: 10))
        let viewFrame = CGRect(x: 0, y: gameViewY, width: width, height: gameViewHeight)
        let gameView = baseVC.viewCreat(frame: viewFrame, backgroundColor: model.gameBackColor)
        gameView.backgroundColor = UIColor.white
        self.scroll.addSubview(gameView)
        self.scroll.bringSubview(toFront: gameView)
        gameView.tag = HomeTag.gameVeiwTag.rawValue
        //init yellow image
        let yellowLabel = UILabel()
        gameView.addSubview(yellowLabel)
        yellowLabel.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(adapt_W(width: 13))
            _ = make?.top.equalTo()(adapt_H(height: (isPhone ? 30 : 23) - 12 ) / 2)
            _ = make?.width.equalTo()(adapt_W(width: 3))
            _ = make?.height.equalTo()(adapt_H(height: 12))
        }
        yellowLabel.backgroundColor = model.yellowLabelColor
        
        let hotFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: isPhone ? 30 : 23))
        let hotGameLabel = baseVC.labelCreat(frame: hotFrame, text: "       热门游戏", aligment: .left, textColor: model.gameTitleColor, backgroundcolor: .white, fonsize:fontAdapt(font: isPhone ? 13 :  10))
        hotGameLabel.layer.borderColor = gameView.backgroundColor?.cgColor
        hotGameLabel.layer.borderWidth = adapt_W(width: 0.25)
        gameView.insertSubview(hotGameLabel, at: 0)
        
        //initialize game button
        let buttonNum = Int((homeGameName.count + 3) / 4) * 4
        for i in 0 ..< buttonNum {
            let btnWidth = width / 4
            let btnX = btnWidth * CGFloat(i % 4)
            let btnHeight = (gameViewHeight - hotFrame.height) / CGFloat((homeGameName.count + 3) / 4)
            let btnY = btnHeight * CGFloat(i / 4) + hotFrame.height

            let gameBtnFrame = CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight)
            let gameBtn = baseVC.buttonCreat(frame: gameBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(gameBtnAction(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: model.gameTitleFont, events: .touchUpInside)
            gameBtn.tag = HomeTag.gameBtnTag.rawValue + i
            gameBtn.layer.borderColor = self.scroll.backgroundColor?.cgColor
            gameBtn.layer.borderWidth = adapt_W(width: isPhone ? 0.35 : 0.25)
            gameView.addSubview(gameBtn)
            
            if i >= homeGameName.count {
                gameBtn.isEnabled = false
                continue
            }
            //image
            let gameBtnImg = UIImageView(image: UIImage(named: model.gameImg[i]), highlightedImage: nil)
            gameBtn.addSubview(gameBtnImg)
            gameBtnImg.mas_makeConstraints({ (make) in
                make?.top.equalTo()(gameBtn.mas_top)?.setOffset(btnHeight * 0.08)
                _ = make?.centerX.equalTo()(gameBtn.mas_centerX)
                _ = make?.width.equalTo()(adapt_W(width: isPhone ? 60 : 50))
                _ = make?.height.equalTo()(adapt_W(width: isPhone ? 60 : 50))
            })
            //label
            let gameNameLabel = UILabel()
            gameBtn.addSubview(gameNameLabel)
            gameNameLabel.mas_makeConstraints({ (make) in
                _ = make?.left.equalTo()
                _ = make?.right.equalTo()
                _ = make?.top.equalTo()(gameBtnImg.mas_bottom)
                _ = make?.bottom.equalTo()
            })
            gameNameLabel.text = homeGameName[i]
            gameNameLabel.textAlignment = .center
            gameNameLabel.font = UIFont(name: "Hiragino Sans", size: fontAdapt(font: isPhone ? 12 : 9) )
            gameNameLabel.textColor = model.gameNameColor
        }
    }
    
    
    func homeLeftTimeTimerAct() -> Void {
        
        //        tlPrint(message: "leftTimeTimerAct  is from detail page:")
        
        let redPacketModel = RedPacketModel()
        var timeIntervalDic:Dictionary<String,Int>
        //        tlPrint(message: "home_startTime:\(self.startTime)  home_endTime:\(self.endTime)")
        var haveStart:Bool = false
        (haveStart,timeIntervalDic) = redPacketModel.timeIntervalCalculate(start: self.startTime, end: self.endTime)
        if haveStart {
            timeIntervalDic = ["hour":000,"minute":00,"secend":00]
            if homeLeftTimeTimer != nil {
                self.homeLeftTimeTimer.invalidate()
                self.homeLeftTimeTimer = nil
            }
            
            
            if self.redPacketTimeoutTimer == nil {
                self.redPacketTimeoutTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector:#selector(self.homeTimeoutTimerAct), userInfo: nil, repeats: true)
            }
            return
        }
        //        tlPrint(message: "****** self.startTime:\(self.startTime!)timeIntervalDic:\(timeIntervalDic)")
        self.redPacketView.reloadLeftTimer(newTimeArray: redPacketModel.separateDate(date: redPacketModel.changeDateDicToArray(dateDic: timeIntervalDic)))
        //        tlPrint(message: "timeIntervalDic:\(timeIntervalDic)")
        //        if timeIntervalDic["secend"] == 0 && timeIntervalDic["hour"] == 0 && timeIntervalDic["minute"] == 0 {
        //            tlPrint(message: "时间已经到了")
        ////            self.homeLeftTimeTimer.invalidate()
        //            self.homeTimeoutTimerAct()
        //            if self.redPacketTimeoutTimer == nil {
        //                self.redPacketTimeoutTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector:#selector(self.homeTimeoutTimerAct), userInfo: nil, repeats: true)
        //            }
        //        }
    }
    
    func homeTimeoutTimerAct() -> Void {
        self.redPacketView.scaleAnimation(view: self.redPacketView.bombImg, delay: 0, scale1: 1.06, scale2: 1.03, duration1: 0.5, duration2: 0.3)
        if self.self.redPacketView.viewWithTag(redPacketTag.startLabelImgTag.rawValue) == nil {
            self.redPacketView.initHomeRedPackStartView()
        }
        let startLabelImg = self.redPacketView.viewWithTag(redPacketTag.startLabelImgTag.rawValue) as! UIImageView
        //开始文字闪烁
        startLabelImg.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            startLabelImg.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            startLabelImg.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            startLabelImg.isHidden = false
        }
        
        //剩余红包个数
        let redPacketModel = RedPacketModel()
        let leftRedNum = redPacketModel.leftRedbagNumber(totleNum: self.totalCount, startTime: self.startTime, endTime: self.endTime)
        if leftRedNum > 0 {
            tlPrint(message: "left red bag number:\(leftRedNum)")
            let leftLabel = self.redPacketView.viewWithTag(redPacketTag.homeRedNumLabelTag.rawValue) as! UILabel
            leftLabel.text = "\(leftRedNum)"
        }
    }
    //判断用户是否已经登录
    func checkLoginStatus(hasLogin:@escaping(()->())) -> Void {
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if !(hasLogin as! Bool) {
                let alert = UIAlertView(title: "您还没有登录", message: "", delegate: self, cancelButtonTitle: "再逛逛", otherButtonTitles: "登录/注册")
                alert.tag = 11
                alert.show()
                return
            }
        } else {
            let alert = UIAlertView(title: "您还没有登录", message: "", delegate: self, cancelButtonTitle: "再逛逛", otherButtonTitles: "登录/注册")
            alert.tag = 11
            alert.show()
            return
        }
        hasLogin()
    }
    
    func getNoticeInfo() -> Void {
        
        getNoticeInfo(success: { (response) in
            tlPrint(message: "response: \(response)")
            let noticeString = response as! String
            tlPrint(message: "noticeArray: \(noticeString)")
            var sourceArray = noticeString.components(separatedBy: "\"")
            
            //sourceArray.count
            var sourceArray2:Array<String> = [""]
            for i in 0 ... sourceArray.count - 1 {
                if i % 2 != 0 {
                    sourceArray2.append(sourceArray[i])
                }
            }
            sourceArray2.removeFirst()
            tlPrint(message: "sourceArray2 \(sourceArray2)")
            DispatchQueue.main.async(execute: {
                self.initNoticeView(notice: self.noticeInfoDeal(strArray: sourceArray2))
            })
            
            
        }) { (error) in
            tlPrint(message: "error: \(error)")
            DispatchQueue.main.async(execute: {
                self.initNoticeView(notice: ["富宝娱乐"])
            })
        }
    }
    
    
    func noticeInfoDeal(strArray: Array<String>) -> Array<String> {
        var newArray: Array = [""]
        var maxWord = 23
        
        tlPrint(message: "************** deviceScreen.width :\(deviceScreen.width)")
        switch deviceScreen.width {
        case 320.0:
            maxWord = 22
        case 375.0:
            maxWord = 26
        case 414.0:
            maxWord = 30
        default:
            if deviceScreen.width > 414.0 {
                maxWord = 34
            }
            tlPrint(message: "no such case")
        }
        if strArray.count < 1 {
            tlPrint(message: "收到的广播为空")
            return newArray
        }
        for i in 0 ..< strArray.count  {
            
            var temp = strArray[i] as String
            for _ in 0 ... (temp.characters.count - 1) / maxWord {
                var wordNum = maxWord
                if temp.characters.count < wordNum {
                    wordNum = temp.characters.count
                }
                let index = temp.index(temp.startIndex, offsetBy: wordNum)
                newArray.append(temp.substring(to: index))
                temp = temp.substring(from: index)
            }
        }
        newArray.removeFirst()
        return newArray
    }
    
    //===========================================
    //Mark:- get the notice info from api
    //Will response a Array<String> type
    //===========================================
    func getNoticeInfo(success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        
        var domain:String!
        if let domain_t = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) {
            domain = domain_t as! String
            let url = domain + "Active/GetNotices"
            tlPrint(message: "url:\(url)")
            let network = TTNetworkRequest()
            network.getWithPath(path: url, paras: nil, success: { (response) in
                
                tlPrint(message: "response: \(response)")
                success(response)
                
                }, failure: { (error) in
                    
                    tlPrint(message: "error: \(error)")
                    failure(error)
            })
        }
    }
    
    //=======================================================
    //Mark:- actions after press the title button down and up
    //=======================================================
    func titleBtnAct(sender:UIButton) -> Void {
        tlPrint(message: "titleBtnAct")
        self.checkLoginStatus {
            self.view.isUserInteractionEnabled = false
            sender.backgroundColor = self.model.titleBtnBackColor1
            switch sender.tag {
            case 10:
                tlPrint(message: "存款")
                self.withdrawBtnAnimate(img: self.titleBtnImg1, success: {
                    let rechargeVC = RechargeViewController(isFromTab: false)
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.pushViewController(rechargeVC, animated: true)
                })
            case 11:
                tlPrint(message: "中心钱包")
                self.walletBtnAct(img: self.titleBtnImg2)
            case 12:
                tlPrint(message: "取款")
                self.withdrawBtnAnimate(img: self.titleBtnImg3, success: {
                    self.withdrawBtnAct()
                })
            default:
                tlPrint(message: "no such case")
            }
        }
    }
    
    func withdrawBtnAct() -> Void {
        tlPrint(message: "withdrawBtnAct")

        let withdrawVC = WithdrawViewController(times: self.stringToInt(str: "5"))
        self.view.isUserInteractionEnabled = true
        self.navigationController?.pushViewController(withdrawVC, animated: true)
    }

    func stringToInt(str:String)->(Int){
        
        let string = str
        var int: Int?
        if let doubleValue = Int(string) {
            int = Int(doubleValue)
        }
        if int == nil {
            return 0
        }
        return int!
    }
    
    func withdrawBtnAnimate(img:UIImageView,success: @escaping (() -> ())) -> Void {
        
        let diamondRate:CGFloat = 0.8
        //钻石和星星动画
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            img.layer.setAffineTransform(CGAffineTransform.init(scaleX: diamondRate, y: diamondRate))

        }) { (finished) in
            UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
                img.layer.setAffineTransform(CGAffineTransform.identity)
            }, completion: { (finished) in })
        }
        //页面延时跳转
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.4)) {
            success()
        }
    }
    
    //中心钱包动画
    func walletBtnAct(img: UIImageView) -> Void {
       
        UIView.beginAnimations("walletAnimation", context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        UIView.setAnimationTransition(.flipFromLeft, for: img, cache: false)
        UIView.commitAnimations()
        //页面延时跳转
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.4)) {
            let walletHubVC = WalletHubViewController()
            self.navigationController?.pushViewController(walletHubVC, animated: true)
            self.view.isUserInteractionEnabled = true
        }
    }
    
    //===========================================
    //Mark:- game button actions
    //===========================================
    func gameBtnAction(sender: UIButton) -> Void {
        tlPrint(message: "gameBtnAction")
        let index = sender.tag - HomeTag.gameBtnTag.rawValue
        if index == 0 {
            checkLoginStatus(hasLogin: {
                //新PT游戏
                let gameToken = self.userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) as! String
                let sender = ["gameToken":gameToken,"gameType": homeGameName[index]]
                //            self.rotateScreen(sender: ["oritation":"right"] as AnyObject)
                RotateScreen.right()
                self.userDefaults.setValue(homeGameCode[index], forKey: userDefaultsKeys.gameType.rawValue)
                let gameListVC = GameListViewController()
                gameListVC.param = sender as AnyObject!
                self.navigationController?.pushViewController(gameListVC, animated: true)
            })
            return
        }
        
        
        self.model.getGameBannerInfo { (gameBannerInfo) in
            let gameLobbyIndex = index - 1 //游戏大厅的下标需要排除PT游戏
            self.userDefaults.setValue(gameBannerInfo, forKey: userDefaultsKeys.gameDetailInfo.rawValue)
            let domain = self.userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
            let hotGameList = gameBannerInfo[1][self.model.gameKey[gameLobbyIndex]] as! Array<Int>
            tlPrint(message: hotGameList)
            let gameLobby = GameLobbyViewController(hotGameArray: hotGameList)
            gameLobby.bannerImageURL = "\(domain)\((gameBannerInfo[0][self.model.gameKey[index-1]] as! String))"
            gameLobby.gameName = homeGameName[index-1]
            gameLobby.gameIndex = gameLobbyIndex
            tlPrint(message: homeGameName[index])
            self.navigationController?.pushViewController(gameLobby, animated: true)
        }
    }
    
    //===========================================
    //Mark:- get请求获得当前最新域名和版本信息等
    //===========================================
    var appUpdateUrl = ""
    func requestLatestInfo() -> Void {
        tlPrint(message: "requestLatestInfo  >>>>>>>>><<<<<<<<<<<<<<")
        let userDefaults = UserDefaults.standard
        var returnValue  = NSDictionary()
        //动态域名url字符串的转码
        let urlString = dynamicDomainUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        //创建管理者对象
        let manager = AFHTTPSessionManager()
        //设置允许请求的类别
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "text/json", "application/json","charset=utf-8","text/javascript","text/html", "application/javascript", "text/js") as? Set<String>
        manager.securityPolicy.allowInvalidCertificates = true
        //数据类型选择
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        _ = DispatchQueue.global().sync {
            manager.get(urlString, parameters: nil, progress: { (progress) in
                
            }, success: { (task, response) in
                returnValue = response as! NSDictionary
                
                tlPrint(message: "response:\(String(describing: response))")
                let oldDomainName = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue)
                let oldAppVersion = SystemInfo.getCurrentVersion()
                let newDomainName = returnValue.value(forKey: "doMain")
                let newAppVersion = returnValue.value(forKey: "version")
                if let domainName = newDomainName {
                    if (domainName as! String) != (oldDomainName as! String)  {
                        //将新的域名写进数据库，发送重新加载网页的消息通知
                        let domain = domainName as! String
                        tlPrint(message: "domain1: \(domain)")
                        userDefaults.setValue((domain), forKey: userDefaultsKeys.domainName.rawValue)
                        userDefaults.synchronize()
                    }
                    let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
                    tlPrint(message: "domain2: \(domain)")
                }
                if oldAppVersion < newAppVersion as! String{
                    tlPrint(message: "***********  oldAppVersion:\(oldAppVersion) < newAppVersion:\(String(describing: newAppVersion))")
                    //有新的版本，提示用户更新
                    tlPrint(message: "请更新版本")
                    if let updateUrl = returnValue.value(forKey: "downloadAddr") {
                        //获取app的更新地址
                        tlPrint(message: "get the download address: \(updateUrl)")
                        self.appUpdateUrl = (updateUrl as! String)
                        tlPrint(message: "self.appUpdateUrl : \(self.appUpdateUrl)")
                        
                        let alert = UIAlertView(title: "升级提示", message: "你当前的版本是V\(oldAppVersion)，发现新版本V\(newAppVersion as! String),是否下载新版本？\n(若提示无法下载，请卸载以后在官网扫码下载)", delegate: self, cancelButtonTitle: "下次再说", otherButtonTitles: "立即下载")
                        alert.tag = 10
                        alert.show()
                        tlPrint(message: "当前bundleID为：\(SystemInfo.getBundleID())")
                    }
                }
                tlPrint(message: "response:\(String(describing: response))")
            }, failure: { (task, error) in
                tlPrint(message: "请求失败\nERROR:\n\(error)")
            })
        }
    }
    
    func btnAct(sender:UIButton) -> Void {
        switch sender.tag {
        case HomeTag.loginBtnTag.rawValue:
            tlPrint(message: "点击了登录按钮")
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        case HomeTag.registerBtnTag.rawValue:
            tlPrint(message: "点击了注册按钮")
            let registerVC = RegisterViewController()
            self.navigationController?.pushViewController(registerVC, animated: true)
        //礼盒
        case HomeTag.giftBoxBtnTag.rawValue:
            tlPrint(message: "点击了礼盒按钮")
            self.checkLoginStatus {
                let giftBoxVC = GiftBoxViewController()
                self.navigationController?.pushViewController(giftBoxVC, animated: true)
            }
        //宝箱已经关闭
        case HomeTag.treasureBoxBtnTag.rawValue:
            tlPrint(message: "点击了宝箱按钮")
            self.checkLoginStatus {
                let treasureBoxVC = TreasureBoxViewController()
                self.navigationController?.pushViewController(treasureBoxVC, animated: true)
            }
        //红包
        case HomeTag.redPacketBtnTag.rawValue:
            tlPrint(message: "点击了红包按钮")
            self.checkLoginStatus {
                let redPacketVC = RedPacketViewController(haveStart: self.isStart)
                self.navigationController?.pushViewController(redPacketVC, animated: true)
            }
        //3D福彩
        case HomeTag.lotteryBtnTag.rawValue:
            tlPrint(message: "点击了3D福彩按钮")
            self.checkLoginStatus {
                let lotteryVC = LotteryViewController()
                self.navigationController?.pushViewController(lotteryVC, animated: true)
            }
        default:
            tlPrint(message: "no such case!")
        }
    }
    
    //===========================================
    //Mark:- 弹窗处理函数
    //===========================================
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        tlPrint(message: "alertView - clickedButtonAt")
        switch alertView.tag {
        case 10:
            //app更新弹窗
            if buttonIndex == 1 {
                //确认更新app
                let url = URL(string: appUpdateUrl)
                tlPrint(message: "new app url: \(String(describing: url))")
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: { (response) in
                        tlPrint(message: "response:\(response)")
                    })
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
        case 11:
            //没有登录弹窗
            tlPrint(message: "buttonIndex:\(buttonIndex)")
            if buttonIndex == 1 {
                tlPrint(message: "选择了进入注册")
                let loginVC = LoginViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        default:
            tlPrint(message: "no such case")
        }
    }
    
    private func refreshPull() ->Void {
        tlPrint(message: "refreshViewOfBlock")
        let header = MJRefreshNormalHeader()
        //修改字体
        header.stateLabel.font = UIFont.systemFont(ofSize: 15)
        header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
        //隐藏刷新提示文字
        header.stateLabel.isHidden = true
        //隐藏上次刷新时间
        header.lastUpdatedTimeLabel.isHidden = true
        header.setRefreshingTarget(self, refreshingAction: #selector(self.refreshAct))
        self.scroll.mj_header = header
    }
    
    func refreshAct() -> Void {
        tlPrint(message: "refreshAct")
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if !(hasLogin as! Bool) {//未登录
                self.scroll.mj_header.endRefreshing()
                return
            }
        } else {//持久存储没有登录信息
            self.scroll.mj_header.endRefreshing()
            return
        }
        self.getAccount()
        self.scroll.mj_header.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


func refreshHeader(scrollView:UIScrollView,action:Selector) -> Void {
    tlPrint(message: "refreshViewOfBlock")
    let header = MJRefreshNormalHeader()
    //修改字体
    header.stateLabel.font = UIFont.systemFont(ofSize: 15)
    header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
    
    //隐藏刷新提示文字
    header.stateLabel.isHidden = true
    //隐藏上次刷新时间
    header.lastUpdatedTimeLabel.isHidden = true
    header.setRefreshingTarget(nil, refreshingAction: action)
    scrollView.mj_header = header
}

