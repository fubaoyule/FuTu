//
//  GameLobbyViewController.swift
//  FuTu
//
//  Created by Administrator1 on 22/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit





protocol lobbyDelegate {
    func alertBtnAct(sender:UIButton)
}

class GameLobbyViewController: UIViewController,UITextFieldDelegate, UIScrollViewDelegate, lobbyDelegate ,UIAlertViewDelegate{

    var gameIndex:Int!
    var gameName,gameId:String!
    var scroll: UIScrollView!
    let model = LobbyModel()
    let baseVC = BaseViewController()
    var transInOutView:LobbyTransInOutView!
    var bannerImageURL:String!
    var refreshIndicator:RefreshIndicator!
    var width,height: CGFloat!
    var playBtn: UIButton!
    var dataSource: Array<String>!
    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var indecator:TTIndicators!
    var hotGameArray:Array<Int>!
    
    //优惠券张数
    //var preferentNumber = 2
    override func viewDidLoad() {
        tlPrint(message: "gameLobby")
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        height = self.view.frame.height
        width = self.view.frame.width
        self.view.backgroundColor = UIColor.white
        dataSource = self.model.PTDataSource
        //计算优惠券张数
        //preferentNumber = model.couponData.count
        
//        let scrollView = GameLobbyView()
//        scrollView.imgDataSource = self.model.PTImgDataSource
//        scrollView.lobbyModel = model
//        self.addChildViewController(scrollView)
//        //self.view.addSubview(scrollView.scroll)
        tlPrint(message: "\n\n\n热门游戏列表：\(self.hotGameArray)\n\\n\n")
        
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if hasLogin as! Bool {
                self.getAccount(success: {
                    tlPrint(message: "游戏详情页获取数据成功")
                }, failure: {
                    tlPrint(message: "游戏详情页获取数据失败")
                })
            }
        }
        notifyRegister()
        
        //初始化返回按钮
        initBackBtn()
        //初始化滚动视图
        initScrollView()
        //初始化下拉刷新
        //refreshPull()
        initStatuBarBackColor()
        tlPrint(message: "gameIndex: \(gameIndex)")
        tlPrint(message: "game lobby game name: \(gameName)")
        
    }
    
    init(hotGameArray:Array<Int>) {
        super.init(nibName: nil, bundle: nil)
        self.hotGameArray = hotGameArray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //===========================================
    //Mark:- set the style of status bar
    //===========================================
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tlPrint(message: "viewWillAppear")
        self.refreshAct()
    }
    
    func getAccount(success:@escaping(()->()),failure:@escaping(()->())) -> Void {
        //获取各个平台的余额
//        futuNetworkRequest(type: .get,serializer: .http, url: model.gameBalanceUrl, params: ["gamecode":globleGameCode[self.gameIndex]], success: { (response) in
        
        futuNetworkRequest(type: .get,serializer: .http, url: model.gameBalanceUrl, params: ["gamecode":gameLobbyGameCode[self.gameIndex]], success: { (response) in
            tlPrint(message: "response:\(response)")
            var string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: "string:\(String(describing: string))")
            string = retain2Decima(originString: string!)
            self.model.gameAccountDeal(account: string!, index: self.gameIndex, success: {
                tlPrint(message: "游戏详情页处理数据成功")
                success()
            })
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            failure()
        })
        
    }
    
    //注册消息通知
    func notifyRegister() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.modifyAccountLabel(sender:)), name: NSNotification.Name(rawValue: notificationName.PlatformGameAccountModify.rawValue), object: nil)
        
    }
    //消息通知改变中心钱包金额
    func modifyAccountLabel(sender:Notification) -> Void {
        let accountLabel = self.view.viewWithTag(LobbyTag.gameAccountLabel.rawValue) as! UILabel
        
        var account = sender.object
        if "\(String(describing: account))" == "\"Failed\"" {
            tlPrint(message: "拿到的数据为Failed")
            account = "0.0"
        }
        accountLabel.text = "¥ \(account!)"
    }
    
    //初始化状态条背景
    func initStatuBarBackColor() -> Void {
        
        let statusBarImg = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        self.view.addSubview(statusBarImg)
        statusBarImg.image = UIImage(named: "home_statusBar_img.png")
    }
    
    //初始化返回按钮
    func initBackBtn() -> Void {
        tlPrint(message: "initBackBtn")
        let backFrame = CGRect(x: adapt_W(width: isPhone ? 12 : 18), y: adapt_H(height: isPhone ? 25 : 15), width: adapt_W(width: isPhone ? 35 : 25), height: adapt_W(width: isPhone ? 35 : 25))
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: dataSource[0]), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        self.view.insertSubview(backBtn, at: 1)
        backBtn.tag = LobbyTag.backBtnAct.rawValue
        
    }

    var bannerImgView:UIImageView!
    var shadowImg:UIImageView!
    //初始化滚动视图
    func initScrollView() -> Void {
        tlPrint(message: "initScrollView")
        let scrollFrame = CGRect(x: 0, y: 0, width: width, height: height)
        scroll = UIScrollView(frame: scrollFrame)
        self.view.insertSubview(scroll, at: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        let scrollHeight:CGFloat = height + adapt_H(height: 100)
        scroll.contentSize = CGSize(width: width, height: scrollHeight)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        
        //初始化游戏图片视图
        initImageView()
        //初始化播放按钮
        initPlayBtn()
        //初始化帐户信息视图
        initAccountView()
        
        if self.gameIndex == 1 || self.gameIndex == 2 {
            //AG真人和AG捕鱼不显示热门游戏
            return
        }
        initGameDetail()
        //初始化优惠信息视图
        //initPreferentView()
    }
    
     //初始化游戏图片视图
    func initImageView() -> Void {
        tlPrint(message: "initImageView")
        let imgFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: isPhone ? 210 : 190))
        bannerImgView = UIImageView(frame: imgFrame)
        bannerImgView.sd_setImage(with: URL(string: self.bannerImageURL), placeholderImage: UIImage(named: "auto-image.png"))
        self.scroll.insertSubview(bannerImgView, at: 0)
        shadowImg = UIImageView(frame: CGRect(x: 0, y: imgFrame.height - adapt_H(height: 20), width: width, height: adapt_H(height: 20)))
        bannerImgView.addSubview(shadowImg)
        shadowImg.image = UIImage(named: "prefer_detail_curve.png")
        
        
    }
    
    func initPlayBtn() -> Void {
        tlPrint(message: "initPlayBtn")
        let playBtn = baseVC.buttonCreat(frame: initFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: dataSource[2]), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        self.scroll.addSubview(playBtn)
        playBtn.frame = CGRect(x: (width - adapt_H(height: (isPhone ? 85 : 60))) / 2 , y: adapt_H(height: isPhone ? 210 - (85 / 2) : 190 - 30), width: adapt_W(width: isPhone ? 85 : 60), height: adapt_W(width: isPhone ? 85 : 60))
        playBtn.tag = LobbyTag.gamePlayBtnTag.rawValue
    }
    //===========================================
    //Mark:- 进入游戏列表页面
    //===========================================
    
    //增加游戏需要修改
    let gameType = ["MG","AG","AGFish","SG","PNG","HB","TTG","BS"]
    //增加游戏需要修改
    let gameTokenAddr = ["Game/GetMgToken","Game/GetAGloginLink","Game/GetAGloginLink","Game/GetSgToken","Game/GetPngToken","Game/GetHabaToken","Game/GetTtgToken","Game/GetBetSoftToken"]
    
    func playBtnAct() -> Void {
        tlPrint(message: "playBtnAct")
        //gameType用去区分游戏游戏列表显示的数据
        if self.indecator == nil {
            self.indecator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
        }
        self.indecator.play(frame: portraitIndicatorFrame)
        
        let currentType = gameType[self.gameIndex]
        let playBtn = self.scroll.viewWithTag(LobbyTag.gamePlayBtnTag.rawValue) as! UIButton
        playBtn.isUserInteractionEnabled = false
        var param = ["":""]
        switch currentType {
        case "AG":
            param = ["gameType":"0","fromUrl":"www.toobet.com","oddType":"A"]
            self.getGameToken(type: .post, isGameList: false, param: param,url: gameTokenAddr[self.gameIndex])
        case "AGFish":
            param = ["gameType":"6","fromUrl":"www.toobet.com","oddType":"A"]
            self.getGameToken(type: .post, isGameList: false, param: param,url: gameTokenAddr[self.gameIndex])
        default:
            self.getGameToken(type: .get, isGameList: true, param: param,url: gameTokenAddr[self.gameIndex])
        }
        
        
        playBtn.isUserInteractionEnabled = true

    }
    
    func getHotGameToken(param:Dictionary<String,Any>,url:String,success: @escaping ((_ token: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) -> Void {
        futuNetworkRequest(type: .get, serializer: .http, url: url, params: param, success: { (response) in
            tlPrint(message: "response:\(response)")
            //去空格
            let gameToken_t = response as! Data
            var gameToken = String(data: gameToken_t , encoding: String.Encoding.utf8)
            gameToken = gameToken!.replacingOccurrences(of: "\"", with: "")
            
            //返回游戏token
            gameToken = gameToken!.replacingOccurrences(of: "\\", with: "")
            tlPrint(message: "gameToken:\(String(describing: gameToken))")
//            let sender = ["gameToken":gameToken,"gameType":self.gameType[self.gameIndex]]
//            self.rotateScreen(sender: ["oritation":"right"] as AnyObject)
            userDefaults.setValue(self.gameType[self.gameIndex], forKey: userDefaultsKeys.gameType.rawValue)
            success(gameToken ?? "default_token")
            
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
            
        })
    }
    
    func getGameToken(type:NetworkRequestType,isGameList:Bool,param:Dictionary<String,Any>,url:String) -> Void {
        tlPrint(message: "getGameToken")
        //gameURL用于获取游戏Token
            futuNetworkRequest(type: .get, serializer: .http, url: url, params: param, success: { (response) in
                tlPrint(message: "response:\(response)")
                //去空格
                let gameToken_t = response as! Data
                var gameToken = String(data: gameToken_t , encoding: String.Encoding.utf8)
                gameToken = gameToken!.replacingOccurrences(of: "\"", with: "")
                tlPrint(message: "current game index = \(self.gameIndex)")
                if isGameList {
                    //返回游戏token
                    gameToken = gameToken!.replacingOccurrences(of: "\\", with: "")
                    tlPrint(message: "gameToken:\(String(describing: gameToken))")
                    let sender = ["gameToken":gameToken,"gameType":self.gameType[self.gameIndex]]
                    self.rotateScreen(sender: ["oritation":"right"] as AnyObject)
                    userDefaults.setValue(self.gameType[self.gameIndex], forKey: userDefaultsKeys.gameType.rawValue)
                    let gameListVC = GameListViewController()
                    gameListVC.param = sender as AnyObject!
                    if self.indecator != nil {
                        self.indecator.stop()
                    }
                    self.navigationController?.pushViewController(gameListVC, animated: true)
                } else if self.gameType[self.gameIndex] == "AG" || self.gameType[self.gameIndex] == "AGFish" {
                    
                    //该游戏返回的游戏地址
                    gameToken = gameToken!.replacingOccurrences(of: "\\", with: "")
                    tlPrint(message: "gameToken:\(String(describing: gameToken))")
                    var url:String = gameToken!
                    url = url.replacingOccurrences(of: "\\u", with: "&")
                    url = url.replacingOccurrences(of: "\"", with: "")
                    tlPrint(message: "new url: \(url)")
                    
                    let sender = ["gameType":self.gameType[self.gameIndex],"orientation":self.gameType[self.gameIndex] == "AG" ? "all" : "right","url":"\(url)"]
                    self.rotateScreen(sender: ["oritation":sender["orientation"]] as AnyObject)
                    userDefaults.setValue(self.gameType[self.gameIndex], forKey: userDefaultsKeys.gameType.rawValue)
                    let gameVC = GameViewController()
                    gameVC.param = sender as AnyObject!
                    self.navigationController?.pushViewController(gameVC, animated: true)
                    if self.indecator != nil {
                        self.indecator.stop()
                    }
                    
               
                    
//                } else if self.gameType[self.gameIndex] == "BBIN" {
//                    tlPrint(message: "BBIN:\(String(describing: gameToken))")
//                    if (gameToken != nil) && gameToken == "true" {
//                        tlPrint(message: "%%%%%%%%%%%%%%%%%%%%   BBIN == ture")
//                        self.getGameToken(isGameList: false, param: ["gametype":"game"],url: "Game/GetBBINLoginLink")
//                        futuNetworkRequest(type: .post, serializer: .http, url: "Game/GetBBINLoginLink", params: ["gametype":"game"], success: { (response) in
//                            tlPrint(message: "response:\(response)")
//                            let gameToken_t = response as! Data
//                            var gameToken = String(data: gameToken_t , encoding: String.Encoding.utf8)
//                            gameToken = gameToken!.replacingOccurrences(of: "\"", with: "")
//                            var url:String = gameToken!
//                            url = url.replacingOccurrences(of: "\\u", with: "&")
//                            url = url.replacingOccurrences(of: "\"", with: "")
//                            url = url.replacingOccurrences(of: "\\", with: "")
//                            tlPrint(message: "new url: \(url)")
//                            
//                            let sender = ["gameType":"BBIN","orientation":"portrait","url":"\(url)"]
//                            let gameVC = GameViewController()
//                            gameVC.param = sender as AnyObject!
//                            self.navigationController?.pushViewController(gameVC, animated: true)
//                            
//                        }, failure: { (error) in
//                            tlPrint(message: "error:\(error)")
//                        })
                    } else {
                        if (gameToken != nil) && gameToken == "false" {
                            self.getGameToken(type: .get, isGameList: false, param: ["":""],url: self.gameTokenAddr[self.gameIndex])
                        } else {
                            var url:String = gameToken!
                            url = url.replacingOccurrences(of: "\\u0026", with: "&")
                            url = url.replacingOccurrences(of: "\"", with: "")
                            url = url.replacingOccurrences(of: "\\", with: "")
                            tlPrint(message: "new url: \(url)")
                            
                            let sender = ["gameType":"BBIN","orientation":"portrait","url":"\(url)"]
                            let gameVC = GameViewController()
                            gameVC.param = sender as AnyObject!
                            if self.indecator != nil {
                                self.indecator.stop()
                            }
                            self.navigationController?.pushViewController(gameVC, animated: true)
                        }
                    }
//                } else if self.gameType[self.gameIndex] == "BBIN_City" {
//                    tlPrint(message: "BBIN_City:\(String(describing: gameToken))")
//                    if (gameToken != nil) && gameToken == "true" {
//                        tlPrint(message: "BBIN_City == ture")
//                        self.getGameToken(isGameList: false, param: ["gametype":3003,"gamekind":3,"gamecode":1],url: "Game/GetBBINGameH5Link")
//                        //["gamecode": 1, "gametype": 3003, "gamekind": 3]
//                        
//                    } else {
//                        if (gameToken != nil) && gameToken == "false" {
//                            self.getGameToken(isGameList: false, param: ["":""],url: self.gameTokenAddr[self.gameIndex])
//                        } else {
//                            var url:String = gameToken!
//                            url = url.replacingOccurrences(of: "\\u", with: "&")
//                            url = url.replacingOccurrences(of: "\"", with: "")
//                            url = url.replacingOccurrences(of: "\\", with: "")
//                            tlPrint(message: "new url: \(url)")
//                            
//                            let sender = ["gameType":"BBIN_City","orientation":"portrait","url":"\(url)"]
//                            let gameVC = GameViewController()
//                            gameVC.param = sender as AnyObject!
//                            self.indecator.stop()
//                            self.navigationController?.pushViewController(gameVC, animated: true)
//                            
//                        }
//                    }
//                }
        
                    
            }, failure: { (error) in
                tlPrint(message: "error:\(error)")
            
            })
    }
    
    //http://888.futubet.co/app/WebService/JSON/display.php/PlayGameByH5?website=LWIN999&0026username=fttiger01&0026gamekind=3&0026gametype=3003&0026gamecode=1&0026lang=zh-cn&0026key=gdposfe77e20560b282f48fe6c365cb04c1dcc3g)
    //http://888.futubet.co/app/WebService/JSON/display.php/Login?website=LWIN999&username=fttestchen005&uppername=dfutu888&password=&lang=zh-cn&page_site=game&page_present=game&key=jrsikoej5aaff308269c8d93254ca1860fd15eb0j
    
    func check(string:String) -> String {
        let  result = NSMutableString()
        // 使用正则表达式一定要加try语句
        do {
            // - 1、创建规则
            let pattern = "[a-zA-Z_0-9]"
            // - 2、创建正则表达式对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            // - 3、开始匹配
            let res = regex.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count))
            // 输出结果
            for checkingRes in res {
                let nn = (string as NSString).substring(with: checkingRes.range) as NSString
                result.append(nn as String)
            }
        } catch {
            print(error)
        }
        return result as String
        
    }

    

    //========================
    //Mark:- 旋转屏幕
    //========================
    func  rotateScreen(sender: AnyObject) -> Void {
        
        tlPrint(message: "rotateScrenn sender: \(sender)")
        if let oritation = sender.value(forKey: "oritation") {
            switch oritation as! String {
            case "portrait":
                
                RotateScreen.portrait()
            case "right":
                
                RotateScreen.right()
            case "left":
                
                RotateScreen.left()
                
            case "all":
                
                RotateScreen.all()
            default:
                break
            }
        }
    }


    
    //初始化帐户信息视图
    func initAccountView() -> Void {
        tlPrint(message: "initAccountView")
        
        
        let accountView = UIView()
        self.scroll.addSubview(accountView)
        accountView.frame = CGRect(x: 0, y: adapt_H(height: isPhone ? 217 + 85 / 2 : 190 + 60 / 2), width: width, height: adapt_H(height: isPhone ? 162 : 110))
        //image
        let img = UIImageView()
        accountView.addSubview(img)
        img.image = UIImage(named: model.gameIconArray[self.gameIndex])
        img.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height: 5))
            _ = make?.width.equalTo()(adapt_H(height: isPhone ? 83 : 60))
            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 83 : 60))
            _ = make?.left.equalTo()(accountView.mas_left)?.setOffset(adapt_W(width: isPhone ? 16 : 22))
        }
        
        //infoView
        let infoView = UIView()
        infoView.backgroundColor = UIColor.yellow
        accountView.addSubview(infoView)
        infoView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height: 8))
            _ = make?.left.equalTo()(img.mas_right)?.setOffset(adapt_W(width: isPhone ? 7 : 15))
            _ = make?.right.equalTo()(accountView.mas_right)?.setOffset(adapt_W(width: isPhone ? -16 : -22))
            _ = make?.height.equalTo()(adapt_H(height: isPhone ? 71 : 55))
        }
        infoView.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
        infoView.layer.borderColor = UIColor.colorWithCustom(r: 225, g: 225, b: 225).cgColor
        infoView.layer.borderWidth = 0.5
        infoView.layer.cornerRadius = adapt_H(height: isPhone ? 7 : 5)
        
        
        //game label
        let gameNameLabel = UILabel()
        infoView.addSubview(gameNameLabel)
        //Balance label
        let balanceLabel = UILabel()
        infoView.addSubview(balanceLabel)
        
        gameNameLabel.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(adapt_H(height: isPhone ? 10 : 8))
            _ = make?.left.equalTo()(adapt_W(width: 15))
            _ = make?.right.equalTo()
            _ = make?.height.equalTo()(adapt_H(height: 20))
        }
        gameNameLabel.text = gameLobbyGameName[self.gameIndex]
//        if self.gameIndex == 2 {
//            gameNameLabel.text = homeGameName[3]
//        }
        gameNameLabel.textAlignment = .left
        gameNameLabel.textColor = UIColor.colorWithCustom(r: 58, g: 58, b: 58)
        gameNameLabel.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 17 : 12))
        //Balance label
        balanceLabel.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(gameNameLabel.mas_left)
            _ = make?.bottom.equalTo()(adapt_H(height: isPhone ? -10 : -8))
            _ = make?.width.equalTo()(adapt_W(width: 65))
            _ = make?.height.equalTo()(adapt_H(height: 15))
        }
        balanceLabel.text = "游戏余额:"
        balanceLabel.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 14 : 10))
        balanceLabel.textColor = UIColor.colorWithCustom(r: 177, g: 177, b: 177)
        //Balance amount label
        let balanceAmount = UILabel()
        infoView.addSubview(balanceAmount)
        balanceAmount.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(balanceLabel.mas_right)?.setOffset(adapt_W(width: 2))
            _ = make?.right.equalTo()
            _ = make?.height.equalTo()(adapt_H(height: 20))
            _ = make?.centerY.equalTo()(balanceLabel.mas_centerY)
        }
        var balanceValue:String = ""
        if let balanceValue_u = userDefaults.value(forKey: gameLobbyGameUserDefaults[self.gameIndex]) {
            balanceValue = balanceValue_u as! String
        }
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if hasLogin as! Bool {
                
            } else {
                balanceValue = "0.00"
            }
        } else {
            balanceValue = "0.00"
        }
        
        balanceAmount.text = "¥ \(balanceValue)"
        tlPrint(message: "balanceAmount.text = \(String(describing: balanceAmount.text))")
        balanceAmount.textColor = UIColor.colorWithCustom(r: 245, g: 63, b: 0)
        balanceAmount.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 20 : 13))
        balanceAmount.tag = LobbyTag.gameAccountLabel.rawValue

        if gameType[gameIndex] == "newPT" {
            tlPrint(message: "新PT 游戏")
            return
        }
        
        
        //recharge(充值) button
        let buttonHeight = adapt_H(height: isPhone ? 37 : 20)
        
        let rechargeBtn = baseVC.buttonCreat(frame: initFrame, title: "转  入", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.rechargeBtnColor, fonsize: fontAdapt(font: isPhone ? 15 : 10), events: .touchUpInside)
        rechargeBtn.setTitleColor(model.rechargeTextColor, for: .normal)
        accountView.addSubview(rechargeBtn)
        rechargeBtn.tag = LobbyTag.rechargeBtnTag.rawValue
        //Withdraw(提现) button
        let withdrawBtn = baseVC.buttonCreat(frame: initFrame, title: "转  出", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: model.withdrawBtnColor, fonsize: fontAdapt(font: isPhone ? 15 : 10), events: .touchUpInside)
        withdrawBtn.setTitleColor(model.withdrawTextColor, for: .normal)
        accountView.addSubview(withdrawBtn)
        withdrawBtn.tag = LobbyTag.withdrawBtnTag.rawValue
        rechargeBtn.mas_makeConstraints { (make) in
            //_ = make?.top.equalTo()(infoView.mas_bottom)?.setOffset( self.model.btnTop * self.height)
            _ = make?.left.equalTo()(adapt_W(width: isPhone ? 26 : 60))
            _ = make?.right.equalTo()(withdrawBtn.mas_left)?.setOffset(adapt_W(width: isPhone ? -12 : -20))
            _ = make?.bottom.equalTo()(adapt_H(height: isPhone ? -20 : -15) )
            _ = make?.height.equalTo()(buttonHeight)
        }
        tlPrint(message: "buttonHeight = \(buttonHeight)")
        rechargeBtn.layer.cornerRadius = buttonHeight / 2
        
        withdrawBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(rechargeBtn.mas_top)
            _ = make?.bottom.equalTo()(rechargeBtn)
            _ = make?.right.equalTo()(adapt_W(width: isPhone ? -26 : -60))
            _ = make?.left.equalTo()(rechargeBtn.mas_right)?.setOffset(adapt_W(width: isPhone ? 12 : 20))
            _ = make?.width.equalTo()(rechargeBtn.mas_width)
        }
        withdrawBtn.layer.cornerRadius = buttonHeight / 2
    }
    
    func initGameDetail() -> Void {
        tlPrint(message: "initGameDetail")
        let detailView = UIView()
        self.scroll.addSubview(detailView)
        let detailViewHeight = adapt_H(height: isPhone ? 500 : 460)
        
        detailView.frame = CGRect(x: 0, y:adapt_H(height: isPhone ? 412.5 :330), width: width, height: detailViewHeight)
        
        detailView.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
//        detailView.backgroundColor = UIColor.red
        
        //grey bar
        let grayBar = UIView()
        detailView.addSubview(grayBar)
        grayBar.backgroundColor = UIColor.colorWithCustom(r: 224, g: 225, b: 229)
        grayBar.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()
            _ = make?.right.equalTo()
            _ = make?.left.equalTo()
            _ = make?.height.equalTo()(adapt_H(height: self.model.grayLineHeight))
        }
        
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y:self.model.grayLineHeight, width: width, height: adapt_H(height: isPhone ? 40 : 30)))
        setLabelProperty(label: titleLabel, text: "热门游戏", aligenment: .center, textColor: .colorWithCustom(r: 10, g: 114, b: 232), backColor: .white, font: fontAdapt(font: isPhone ? 15 : 11))
        detailView.addSubview(titleLabel)
        
//        if self.gameIndex == 0  {
//            tlPrint(message: "体育，无需没有游戏推荐")
//            return
//        }
        
        
        initHotGameList(detailView: detailView, gameListArray:self.hotGameArray)
        
//        let describeTextView = UITextView(frame: CGRect(x: adapt_W(width: 10), y: adapt_H(height: 20) + titleLabel.frame.height + imgScroll.frame.height, width: width - adapt_W(width: 20), height: adapt_H(height: 300)))
//        detailView.addSubview(describeTextView)
//        describeTextView.text = model.gameDetailInfoText[self.gameIndex]
//        describeTextView.backgroundColor = UIColor.clear
//        
//        describeTextView.font = UIFont.systemFont(ofSize: fontAdapt(font: isPhone ? 12 : 10))
//        describeTextView.textColor = UIColor.colorWithCustom(r: 169, g: 169, b: 169)
        
        

    }
    func initHotGameList(detailView:UIView, gameListArray:[Int]) -> Void {
        let detailImgInterval:CGFloat = isPhone ? 10 : 7
        let detailImgWidth:CGFloat = isPhone ? 160 : 160
//        var detailImgHeight:CGFloat = isPhone ? 90 : 90
        let gameListViewHeight:CGFloat = isPhone ? 120 : 120
//        if self.gameIndex == 0 {
//            return
//            detailImgWidth = isPhone ? 165 : 120
//            detailImgHeight = isPhone ? 325 : 200
//            self.scroll.contentSize = CGSize(width: width, height: height + adapt_H(height: isPhone ? 300 : 200))
//        }
        
        let gameScroll = UIScrollView(frame: CGRect(x: 0, y: adapt_H(height: 15 + (isPhone ? 40 : 30)), width: width, height: adapt_H(height: gameListViewHeight + detailImgInterval)))
        detailView.addSubview(gameScroll)
        gameScroll.contentSize = CGSize(width: adapt_W(width: detailImgWidth + detailImgInterval) * CGFloat(gameListArray.count) + adapt_W(width: detailImgInterval), height: gameScroll.frame.height)
        gameScroll.showsVerticalScrollIndicator = false
        gameScroll.showsHorizontalScrollIndicator = true
        
        
        let gameListModel = GameListModel()
        //游戏资源字典
        //增加游戏需要修改
        let dataSourceDic = ["BS":gameListModel.BSDataSource,"PT":gameListModel.PTDataSource,"MG":gameListModel.MGDataSource,"TTG":gameListModel.TTGDataSource,"SG":gameListModel.SGDataSource,"HB":gameListModel.HBDataSource,"PNG":gameListModel.PNGDataSource,"AG":gameListModel.AGDataSource,"AGFish":gameListModel.AGDataSource]
        
        //add game buttons
        for i in 0 ..< gameListArray.count {
            
            
            let gameBtnFrame = CGRect(x: adapt_W(width: detailImgInterval) + (adapt_W(width: detailImgInterval + detailImgWidth)) * CGFloat(i), y: 0, width: adapt_W(width: detailImgWidth), height: adapt_H(height: gameListViewHeight))
            let gameBtn = baseVC.buttonCreat(frame: gameBtnFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named: "list_cell_bg.png"), hightImage: UIImage(named: "list_cell_bg.png"), backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
            gameBtn.tag = LobbyTag.hotGameBtnTag.rawValue + i
            gameScroll.addSubview(gameBtn)
            let gameDetailImge = UIImageView(frame: CGRect(x: adapt_W(width: 4.5), y: adapt_W(width: 4.5), width: gameBtnFrame.width - adapt_W(width: 9), height: gameBtnFrame.height - adapt_H(height: 32)))
            gameBtn.addSubview(gameDetailImge)
            //图片名字根据游戏代码命名
            
//            let imageName = "lobby_shortScreen_\(globleGameCode[self.gameIndex])\(i + 1).png"
            //创建图片视图
//            let gameImgString = (self.gameType[self.gameIndex].range(of: "AG") != nil ? "AG" : self.gameType[self.gameIndex])
            
//            tlPrint(message: "gameImgString = \(gameImgString)")
            let imageName = (dataSourceDic[self.gameType[self.gameIndex]]![gameListArray[i]] as! NSArray)[1] as! String
            tlPrint(message: "Image Name: \(imageName)")
            gameDetailImge.image = UIImage(named: imageName)
            gameDetailImge.layer.cornerRadius = adapt_W(width: isPhone ? 5 : 3)
            //创建游戏名称
            let labelFrame = CGRect(x: 0, y: gameBtn.frame.height - adapt_H(height: isPhone ? 21 : 18), width: gameBtn.frame.width, height: adapt_H(height: isPhone ? 15 : 12))
            let gameName = (dataSourceDic[self.gameType[self.gameIndex]]![gameListArray[i]] as! NSArray)[0] as! String
            let label = baseVC.labelCreat(frame: labelFrame, text: gameName, aligment: .center, textColor: .white, backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 14 : 10))
            gameBtn.addSubview(label)

            
        }
    }
    
    
    
    
    
//    var preferentView,blueLine1,blueLine2:UIView!
//    var preferentBtn,gameDetailBtn:UIButton!
//    //优惠活动信息栏，包含了优惠券，和游戏信息
//    func initPreferentView() -> Void {
//        tlPrint(message: "initPreferentView")
//        //view
//        preferentView = UIView()
//        self.scroll.addSubview(preferentView)
//        let preferentViewHeight = model.preferentBtnHight * height + model.preferentInfoHeight_b * height * CGFloat(preferentNumber) + adapt_H(height: model.grayLineHeight)
//        preferentView.frame = CGRect(x: 0, y:height * (model.imgHeight + model.accounHeight) + model.playBtnWidth * width / 2, width: width, height: preferentViewHeight)
//        preferentView.backgroundColor = UIColor.colorWithCustom(r: 244, g: 244, b: 244)
//        
//        //grey bar
//        let grayBar = UIView()
//        preferentView.addSubview(grayBar)
//        grayBar.backgroundColor = UIColor.colorWithCustom(r: 224, g: 225, b: 229)
//        grayBar.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()
//            _ = make?.right.equalTo()
//            _ = make?.left.equalTo()
//            _ = make?.height.equalTo()(adapt_H(height: self.model.grayLineHeight))
//        }
    
//        //button1
//        preferentBtn = UIButton()
//        preferentBtn.setTitle("优惠活动", for: .normal)
//        preferentBtn.addTarget(self, action: #selector(self.preferentBtnAct(sender:)), for: .touchUpInside)
//        preferentBtn.backgroundColor = UIColor.white
//        preferentBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontAdapt(font: model.preferentBtnFont))
//        preferentBtn.setTitleColor(model.preferentTextColor1, for: .normal)
//        preferentBtn.tag = 10
//        preferentView.addSubview(preferentBtn)
//        //button2
//        gameDetailBtn = UIButton()
//        gameDetailBtn.setTitle("游戏详情", for: .normal)
//        //gameDetailBtn.addTarget(self, action: #selector(self.preferentBtnAct(sender:)), for: .touchUpInside)
//        gameDetailBtn.backgroundColor = UIColor.white
//        gameDetailBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontAdapt(font: model.preferentBtnFont))
//        gameDetailBtn.setTitleColor(model.preferentTextColor2, for: .normal)
//        gameDetailBtn.tag = 11
//        preferentView.addSubview(gameDetailBtn)
//        preferentBtn.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(grayBar.mas_bottom)
//            _ = make?.left.equalTo()
//            _ = make?.right.equalTo()(self.gameDetailBtn.mas_left)
//            _ = make?.height.equalTo()(self.model.preferentBtnHight * self.height)
//        }
//        gameDetailBtn.mas_makeConstraints { (make) in
//            _ = make?.top.equalTo()(self.preferentBtn)
//            _ = make?.left.equalTo()(self.preferentBtn.mas_right)
//            _ = make?.right.equalTo()
//            _ = make?.width.equalTo()(self.preferentBtn)
//            _ = make?.height.equalTo()(self.preferentBtn)
//        }
//        blueLine1 = UIView()
//        preferentBtn.addSubview(blueLine1)
//        blueLine1.mas_makeConstraints { (make) in
//            _ = make?.bottom.equalTo()(self.preferentBtn.mas_bottom)
//            _ = make?.height.equalTo()(adapt_H(height: 4))
//            _ = make?.centerX.equalTo()(self.preferentBtn.mas_centerX)
//            _ = make?.width.equalTo()(adapt_W(width: 62))
//        }
//        blueLine1.backgroundColor = model.preferentTextColor1
//        blueLine1.layer.cornerRadius = adapt_H(height: 4)/2
//        
//        
//        
//        blueLine2 = UIView()
//        gameDetailBtn.addSubview(blueLine2)
//        blueLine2.mas_makeConstraints { (make) in
//            _ = make?.bottom.equalTo()(self.gameDetailBtn.mas_bottom)
//            _ = make?.height.equalTo()(adapt_H(height: 4))
//            _ = make?.centerX.equalTo()(self.gameDetailBtn.mas_centerX)
//            _ = make?.width.equalTo()(adapt_W(width: 62))
//        }
//        blueLine2.backgroundColor = UIColor.clear
//        blueLine2.layer.cornerRadius = adapt_H(height: 4)/2
//        
//       
//        initActivityView()
//    }
    
    
//    var activityView:UIView!
//    var backImage:UIImageView!
//    func initActivityView() {
//        
//        let activityY = model.preferentBtnHight * height + adapt_H(height: model.grayLineHeight)
//        let activityHeight = model.preferentInfoHeight_b * height * CGFloat(preferentNumber) + adapt_H(height: 30)
//        
//        let activityFrame = CGRect(x: 0, y: activityY, width: width, height: activityHeight)
//        activityView = UIView(frame: activityFrame)
//        preferentView.addSubview(activityView)
//        
//        //优惠券
//        for i in 0 ... preferentNumber - 1 {
//            
//            let couponY = adapt_H(height: model.couponInterval) + (adapt_H(height: model.couponInterval) + height * model.preferentInfoHeight) * CGFloat(i)
//            let couponWidth = width - adapt_W(width: model.couponInterval) * 2
//            let couponHeight = height * model.preferentInfoHeight
//            let couponFrame = CGRect(x: adapt_W(width: model.couponInterval), y: couponY, width: couponWidth, height: couponHeight)
//            let couponView = UIButton(frame: couponFrame)
//            couponView.addTarget(self, action: #selector(self.couponBtnAct(sender:)), for: .touchUpInside)
//            couponView.tag = 20 + i
//            activityView.addSubview(couponView)
//            
//            //background image
//            backImage = UIImageView(frame: CGRect(x: 0, y: 0, width: couponView.frame.width, height: couponView.frame.height))
//            backImage.tag = couponView.tag + 10
//            couponView.addSubview(backImage)
//            if (model.couponData[i] as NSArray)[0] as! Int == 0 {
//                backImage.image = UIImage(named: "lobby_coupon2.png")//已领取
//            } else {
//                backImage.image = UIImage(named: "lobby_coupon1.png")//未领取
//            }
//            //icon1
//            let icon1 = UIImageView()
//            couponView.addSubview(icon1)
//            icon1.mas_makeConstraints({ (make) in
//                _ = make?.top.equalTo()(couponView.mas_top)?.setOffset(adapt_H(height: 12))
//                _ = make?.left.equalTo()(couponView.mas_left)?.setOffset(adapt_W(width: 18))
//                _ = make?.width.equalTo()(adapt_W(width: 10))
//                _ = make?.height.equalTo()(adapt_H(height: 10))
//            })
//            icon1.image = UIImage(named: "lobby_promo_ico.png")
//            
//            //label 1
//            let label1 = UILabel()
//            couponView.addSubview(label1)
//            
//            
//            let labelText1 = (model.couponData[i] as NSArray)[1] as! NSString
//            let label1Size = labelText1.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontAdapt(font: model.counponLabelFont1))])
//            label1.mas_makeConstraints({ (make) in
//                _ = make?.top.equalTo()(icon1.mas_top)
//                _ = make?.left.equalTo()(icon1.mas_right)?.setOffset(adapt_W(width: 4))
//                _ = make?.height.equalTo()(icon1.mas_height)
//                _ = make?.width.equalTo()(adapt_H(height: label1Size.width) + 1)
//            })
//            
//            label1.text = labelText1 as String
//            label1.textAlignment = .left
//            label1.textColor = UIColor.colorWithCustom(r: 37, g: 37, b: 37)
//            label1.font = UIFont.systemFont(ofSize: fontAdapt(font: fontAdapt(font: model.counponLabelFont1)))
//            //斜体字
//            let tan = -12 * M_PI / 180
//            let transform = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf( Float(tan))), d: 1.0, tx: 0, ty: 0)
//            label1.transform = transform
//            
//            //icon 2
//            let icon2 = UIImageView()
//            couponView.addSubview(icon2)
//            icon2.mas_makeConstraints({ (make) in
//                _ = make?.top.equalTo()(icon1.mas_top)
//                _ = make?.left.equalTo()(label1.mas_right)?.setOffset(adapt_W(width: 4))
//                _ = make?.width.equalTo()(adapt_W(width: 10))
//                _ = make?.height.equalTo()(adapt_H(height: 10))
//            })
//            icon2.image = UIImage(named: "lobby_promo_ico.png")
//            
//            let labelText2 = " \((model.couponData[i] as NSArray)[2] as! NSString)"
//            let label2Size = labelText1.size(attributes: [NSFontAttributeName :  UIFont.systemFont(ofSize: fontAdapt(font: model.counponLabelFont2))])
//            
//            //label2
//            let label2 = UILabel()
//            couponView.addSubview(label2)
//            
//            label2.mas_makeConstraints({ (make) in
//                _ = make?.bottom.equalTo()(couponView.mas_bottom)?.setOffset(adapt_H(height: -12))
//                _ = make?.left.equalTo()(icon1.mas_left)
//                _ = make?.height.equalTo()(label2Size.height)
//                _ = make?.width.equalTo()(adapt_W(width: label2Size.width) + 10)
//            })
//            
//            label2.text = labelText2 as String
//            label2.textAlignment = .left
//            label2.backgroundColor = UIColor.colorWithCustom(r: 255, g: 162, b: 0)
//            label2.textColor = UIColor.colorWithCustom(r: 255, g: 255, b: 255)
//            label2.font = UIFont.systemFont(ofSize: fontAdapt(font:fontAdapt(font: model.counponLabelFont2)))
//            //斜体字
//            label2.transform = transform
//            
//        }
//        
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSetY:CGFloat = scrollView.contentOffset.y
        if offSetY < 0 {
            let originH = adapt_H(height: isPhone ? 210 : 190)
            let originW:CGFloat = width
            let newHeight = -offSetY + originH
            let newWidth = -offSetY * originW / originH + originW
            bannerImgView.frame = CGRect(x: offSetY * originW / originH / 2, y: offSetY, width: newWidth, height: newHeight)
            shadowImg.frame = CGRect(x: 0, y: bannerImgView.frame.height - adapt_H(height: 40), width: bannerImgView.frame.width, height: adapt_H(height: 40))
        }
    }
    
    
    
    var dragOffset:CGFloat = 0
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tlPrint(message: "scrollViewDidEndDragging")
        dragOffset = scrollView.mj_offsetY
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        tlPrint(message: "scrollViewDidEndDecelerating")
        if dragOffset < -refreshHeight {
            refreshAct()
        }
    }
    
    var isRefreshing = false
    func refreshAct() -> Void {
        tlPrint(message: "refreshAct")
        
        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
            if !(hasLogin as! Bool) {//未登录
                return
            }
        } else {//持久存储没有登录信息
            return
        }
        
        if self.isRefreshing {
            return
        }
        self.isRefreshing = true
        let refreshIndecatorFrame = CGRect(x: (width - adapt_W(width: 20))/2 , y: adapt_H(height: isPhone ? 20 : 10), width: adapt_W(width: 20), height: adapt_W(width: 20))
        if self.refreshIndicator == nil {
            self.refreshIndicator = RefreshIndicator(view: self.view, frame: refreshIndecatorFrame)
            //self.walletHubView.refreshIndicator.refreshPlay(frame: refreshIndecatorFrame)
        } else {
            self.refreshIndicator.refreshPlay(frame: refreshIndecatorFrame)
        }
        self.getAccount(success: { 
            tlPrint(message: "中心钱包页刷新数据成功")
            self.refreshIndicator.refreshStop()
            self.isRefreshing = false
//            let notify = NSNotification.Name(rawValue: notificationName.HomeAccountValueRefresh.rawValue)
//            NotificationCenter.default.post(name: notify, object: nil)
        }, failure: {
            tlPrint(message: "游戏详情页刷新数据失败")
            self.refreshIndicator.refreshStop()
            self.isRefreshing = false
        })
    }
    
//    func preferentBtnAct(sender:UIButton) -> Void {
//        tlPrint(message: "preferentBtnAct")
//        switch sender.tag {
//        case 10:
//            tlPrint(message: "优惠活动按钮事件")
//            preferentBtn.setTitleColor(model.preferentTextColor1, for: .normal)
//            gameDetailBtn.setTitleColor(model.preferentTextColor2, for: .normal)
//            blueLine1.backgroundColor = model.preferentTextColor1
//            blueLine2.backgroundColor = UIColor.clear
//        case 11:
//            tlPrint(message: "游戏详情按钮事件")
//            preferentBtn.setTitleColor(model.preferentTextColor2, for: .normal)
//            gameDetailBtn.setTitleColor(model.preferentTextColor1, for: .normal)
//            blueLine1.backgroundColor = UIColor.clear
//            blueLine2.backgroundColor = model.preferentTextColor1
//        default:
//            tlPrint(message: "no such case")
//        }
//    }
    
//    func couponBtnAct(sender:UIButton) -> Void {
//        tlPrint(message: "couponBtnAct")
//        tlPrint(message: "你选择了第 －\(sender.tag - 20)－ 个优惠券")
//        let selectedBtnImg = activityView.viewWithTag(sender.tag + 10) as! UIImageView
//        selectedBtnImg.image = UIImage(named: "lobby_coupon2.png")
//        
//    }
    
    
    func btnAct(sender:UIButton) -> Void {
        
        if sender.tag == LobbyTag.backBtnAct.rawValue {
            tlPrint(message: "返回")
            let notify = NSNotification.Name(rawValue: notificationName.HomeAccountValueRefresh.rawValue)
            NotificationCenter.default.post(name: notify, object: nil)
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.checkLoginStatus {
            switch sender.tag {
            case LobbyTag.gamePlayBtnTag.rawValue:
                tlPrint(message: "开始游戏")
                self.playBtnAct()
            case LobbyTag.rechargeBtnTag.rawValue:
                tlPrint(message: "充值按钮")
                self.gameBtnAct(sender: sender)
            case LobbyTag.withdrawBtnTag.rawValue:
                tlPrint(message: "提现按钮")
                self.gameBtnAct(sender: sender)
            default:
                sender.isEnabled = false
                if self.indecator == nil {
                    self.indecator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
                }
                self.indecator.play(frame: portraitIndicatorFrame)
                self.getHotGameToken(param: ["":""], url: self.gameTokenAddr[self.gameIndex], success: { (token) in
                    tlPrint(message: "token:\(token)")
                    self.startHotGame(sender: sender, token: token as! String)
                }, failure: { (error) in
                    tlPrint(message: error)
                })
                
            }
        }
        
        
    }
    
    func startHotGame(sender:UIButton,token:String) -> Void {
        if sender.tag >= LobbyTag.hotGameBtnTag.rawValue {
            tlPrint(message: "热门推荐游戏按钮\(sender.tag - LobbyTag.hotGameBtnTag.rawValue)")
            let gameNumber = sender.tag - LobbyTag.hotGameBtnTag.rawValue
            let gameListModel = GameListModel()
            //增加游戏需要修改
            //游戏资源字典
            let dataSourceDic = ["BS":gameListModel.BSDataSource,"PT":gameListModel.PTDataSource,"MG":gameListModel.MGDataSource,"TTG":gameListModel.TTGDataSource,"SG":gameListModel.SGDataSource,"HB":gameListModel.HBDataSource,"PNG":gameListModel.PNGDataSource,"AG":gameListModel.AGDataSource,"AGFish":gameListModel.AGDataSource]
            //游戏地址字典
            
            let gameAddrDic = ["BS":gameListModel.BSGameAddr,"PT":gameListModel.PTGameAddr,"MG":gameListModel.MGGameAddr,"TTG":gameListModel.TTGGameAddr,"SG":gameListModel.SGGameAddr,"HB":gameListModel.HBGameAddr,"PNG":gameListModel.PNGGameAddr,"AG":gameListModel.AGGameAddr,"AGFish":gameListModel.AGGameAddr]
            
            
            self.gameId = (dataSourceDic[gameType[gameIndex]]![sender.tag - LobbyTag.hotGameBtnTag.rawValue] as! NSArray)[2] as! String
            tlPrint(message: gameId)
            var url = gameAddrDic[gameType[gameIndex]]!
            let userName = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue)as! String
            let passWord = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue)as! String
            switch self.gameType[self.gameIndex] {
            case "BS":
                url = url+"&token=\(token)&gameId=\(gameId!)"
            case "AV":
                url = url+"&token=\(token)&gameconfig=\(gameId!)"
            case "PT":
                url = url+"&token=\(token)&gameconfig=\(gameId!)"
            case "TTG":
                url = url+"&playerHandle=\(token)&gameId=\(gameId!)&gameName=\((gameListModel.TTGDataSource[gameNumber] as! Array<String>)[3])&gameType=0"
            case "SG":
                url = url+"&acctId=ft\(userName)&token=\(token)&game=\(gameId!)"
            case "HB":
                url = url+"&token=\(token)&keyname=\(gameId!)"
            case "MG":
                let xmanEndPoints = "https://xplay22.gameassists.co.uk/xman/x.x"
                url = url+"\(gameId!)/zh-cn/?lobbyURL=&bankingURL=&username=ft\(userName)&password=\(passWord)&currencyFormat=%23%2C%23%23%23.%23%23&logintype=fullUPE&xmanEndPoints=\(xmanEndPoints)"
            case "PNG":
                url = url+"&gameid=\(gameId!)&ticket=\(token)"
            case "AG":
                url = url+"&gameid=\(gameId!)&ticket=\(token)"
            case "AGFish":
                tlPrint(message: "currentIndex = \(String(describing: gameIndex))")
                url = url+"&gameid=\(gameId!)&ticket=\(token)"
                
            default:
                tlPrint(message: "no such game type")
            }
            
            
            RotateScreen.right()
            let gameVC = GameViewController()
            gameVC.param = ["orientation":"right","url":url] as AnyObject
            gameVC.isFromLandscap = true
            tlPrint(message: "开始跳转到游戏界面")
            
            sender.isEnabled = true
            self.indecator.stop()
            self.navigationController?.pushViewController(gameVC, animated: true)
            
            
        } else {
            tlPrint(message: "no such case")
        }
    }
    
    func gameBtnAct(sender: UIButton) {
        tlPrint(message: "gameBtnAct")
        
//        if self.gameIndex == 4 || self.gameIndex == 5 {
//            tlPrint(message: "游戏正在建设中")
//            let alert = UIAlertView(title: "提 示", message: "游戏正在建设中", delegate: nil, cancelButtonTitle: "确 定")
//            DispatchQueue.main.async {
//                alert.show()
//            }
//            return
//        }
        
        let transferType:String = sender.tag == LobbyTag.rechargeBtnTag.rawValue ? "转入" : "转出"
        self.transInOutView = LobbyTransInOutView(frame: self.view.frame, param: [self.gameIndex,transferType], rootVC: self)

        self.view.insertSubview(transInOutView, aboveSubview: scroll)
        
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
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        switch alertView.tag {
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
    
    
    
    func alertBtnAct(sender: UIButton) {
        tlPrint(message: "alertBtnAct")
        switch sender.tag {
        case TransferTag.alertCloseBtnTag.rawValue:
            self.view.bringSubview(toFront: self.scroll)
        case TransferTag.alertConfirmBtnTag.rawValue:
//            self.view.bringSubview(toFront: self.scroll)
            transferValueDeal()
        default:
            tlPrint(message: "no such case")
        }
    }
    
    func transferValueDeal() -> Void {
        tlPrint(message: "transferValueDeal")

        
        let value = transInOutView.transferInTextField.text
        var amount:String = "0"
//        var preferenceNumber = 0
        if value == nil || value! == "" || value! <= "0" {
            tlPrint(message: "没有输入金额")
            let alert = UIAlertView(title: "转账失败", message: "您输入的金额有误，请重新输入！", delegate: nil, cancelButtonTitle: "确  定")
            DispatchQueue.main.async {
                alert.show()
            }
            return
        }
        
        if self.indecator == nil {
            self.indecator = TTIndicators(view: self.view, frame: portraitIndicatorFrame)
        }
        self.indecator.play(frame: portraitIndicatorFrame)
        
        
        amount = value!
//        if let referenceNumber = transInOutView.preferenceNumber {
//            preferenceNumber = referenceNumber
//            tlPrint(message: "选择的优惠编号为：\(referenceNumber)")
//        }
        let url = transInOutView.transferType == "转入" ? model.deposit : model.withdrawl
        futuNetworkRequest(type: .post, serializer: .http, url: url, params: ["amount":amount,"gameCode":gameLobbyGameCode[self.transInOutView.gameIndex]], success: { (response) in
            tlPrint(message: "response:\(response)")
            let string = String(data: response as! Data, encoding: String.Encoding.utf8)
            tlPrint(message: "string0:\(String(describing: string))")
            if "\(String(describing: string))".range(of: "Failed") != nil  {
                //test
                let loginAlert = UIAlertView(title: "提示", message: "您的账户在别的地方登陆，请重新登陆！", delegate: self, cancelButtonTitle: "确 定")
                loginAlert.show()
                
                LogoutController.logOut()
                let loginVC = LoginViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
                return
            }
            
            let stringDic = (string)?.objectFromJSONString() as! Dictionary<String, Any>
            let message = (stringDic as AnyObject).value(forKey: "Message") as! String
            let alert = UIAlertView(title: "转账", message: message, delegate: nil, cancelButtonTitle: "确 认")
            DispatchQueue.main.async {
                alert.show()
            }
            self.getAccount(success: { 
                tlPrint(message: "游戏详情页转入成功，刷新数据成功")
                
                self.indecator.stop()
            }, failure: {
                tlPrint(message: "游戏详情页转入成功，刷新数据失败")
                self.indecator.stop()
            })
            
        }, failure: { (error) in
            tlPrint(message: "error:\(error)")
        })
        
        //去掉弹窗
        //self.view.bringSubview(toFront: self.)
        self.transInOutView.backView.removeFromSuperview()
        self.transInOutView.backView = nil
        for view in self.transInOutView.subviews {
            view.removeFromSuperview()
        }
        self.transInOutView.removeFromSuperview()
        self.transInOutView = nil
    }
    
    
    
//    
//    private func refreshPull() ->Void {
//        tlPrint(message: "refreshViewOfBlock")
//        let header = MJRefreshNormalHeader()
//        //修改字体
//        header.stateLabel.font = UIFont.systemFont(ofSize: 15)
//        header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
//        //隐藏上次刷新时间
//        header.lastUpdatedTimeLabel.isHidden = true
//        header.setRefreshingTarget(self, refreshingAction: #selector(self.refreshAct))
//        self.scroll.mj_header = header
//    }
//    
//    @objc private func refreshAct() -> Void {
//        tlPrint(message: "refreshAct")
//        getAccount()
//        //耗时动作放到子线程
////        DispatchQueue.global().async {
////            sleep(2)
////        }
//    }
    
    
    
    //textField delegate
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if transInOutView == nil {
            return
        }
        if transInOutView.transferInTextField != nil {
            transInOutView.transferInTextField.resignFirstResponder()
        
            UIView.animate(withDuration: 0.3, animations: {
                self.transInOutView.alertView.center = self.transInOutView.center
            })
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            self.transInOutView.alertView.frame = CGRect(x: adapt_W(width: isPhone ? 20 : 80), y: adapt_H(height: isPhone ? 80 : 130), width: self.width - adapt_W(width: isPhone ? 40 : 160), height: adapt_H(height: isPhone ? 205 : 105))
        })
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        transInOutView.transferInTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.4, animations: {
            self.transInOutView.alertView.center = self.transInOutView.center
        })
        return true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
