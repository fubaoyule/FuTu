//123456
//
////
////  ViewController.swift
////  FuTu
////
////  Created by Administrator1 on 12/9/16.
////  Copyright © 2016 BESVICT. All rights reserved.
////
////  Swift调用JS方法:    wkWebView.evaluateJavaScript("TestMsg()", completionHandler: nil)
////  JS调用Swift方法:
//
//import UIKit
//import WebKit
//
//class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIAlertViewDelegate, URLSessionDelegate {
//    
//    var wkWebView: WKWebView!
//    let share = ShareViewController()
//    var indicator: TTIndicators!
//    var loginVC: LoginViewController!
//    //var isFirstEnter = 0
//    
//    //判断消息通知是否注册,默认没有
//    var isNotificationRegistered = false
//    
//    let isQRCodeTest = false
//    
//    let userDefaults = UserDefaults.standard
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tlPrint(message: "viewDidLoad")
//        self.navigationController?.isNavigationBarHidden = true
//        
//        autoLoginDeal()                 //判断是否自动登录
//        reloadMainPage(url: nil)        //加载主页
//        //上线之前必须开启
//        //requestLatestInfo()             //请求必要信息（获取动态域名）
//        //TouchIDViewController.touchIDStart(rootViewController: self)//指纹锁
//        
//        DispatchQueue.global().async {
//            self.share.initShareSDK()            //分享功能初始化
//            self.removeNotificationObserver()  //注册消息通知
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        RotateScreen.portrait()
//        //测试方法
//        if isQRCodeTest {
//            //二维码生成，Create QR code.
//            let QRCodeVC = QRCodeViewController()
//            self.navigationController?.pushViewController(QRCodeVC, animated: true)
//        }
//    }
//    //用户屏幕方向发生变化时触发
//    override func viewDidLayoutSubviews() {
//        tlPrint(message: "=== viewDidLayoutSubviews ===")
//        
//        
//    }
//    
////    override func viewWillLayoutSubviews() {
////        tlPrint(message: "=== viewWillLayoutSubviews ===")
////    }
//    //===========================================
//    //Mark:- 状态栏修改
//    //===========================================
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        //修改状态栏颜色
//        return UIStatusBarStyle.lightContent
//    }
//    
//    
////    override var prefersStatusBarHidden: Bool {
////        //隐藏状态栏
////        return true
////    }
//    
//    
//    //===========================================
//    //Mark:- WKNavigationDelegate代理方法-［生命周期］
//    //===========================================
//    // 页面开始加载时调用
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        tlPrint(message: "webView didStartProvisionalNavigation")
//        
//        tlPrint(message: "current start url: \(String(describing: webView.url))")
//        
//        let indicatorFrame: CGRect!
//        if currentScreenOritation == UIInterfaceOrientationMask.portrait {
//            indicatorFrame = portraitIndicatorFrame
//            
//            if indicator == nil {
//                indicator = TTIndicators(view: wkWebView, frame: indicatorFrame)
//            }
//            indicator.play(frame: indicatorFrame)
//            webView.isUserInteractionEnabled = false
//        }
//    }
//    
//    // 当内容开始返回时调用
//    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
//        tlPrint(message: "webView commitPreviewingViewController")
//    }
//    
//    // 页面加载完成之后调用
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        tlPrint(message: "webView didFinish")
//        if indicator != nil {
//            indicator.stop()
//            webView.isUserInteractionEnabled = true
//        }
//        tlPrint(message: "current end url: \(String(describing: webView.url))")
//
//    }
//    
//    // 页面加载失败时调用
//    /* Error Code
//     * -1001:  timeout
//     */
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        
//        let Error = error as NSObject
//        let code = Error.value(forKey: "code") as! Int
//        var message = ""
//        switch code {
//        case -1001:
//            message = "网络请求超时"
//        case NSURLErrorCancelled:
//            tlPrint(message: "网络请求删除. Error: \(error)")
//            return
//        default:
//            break
//        }
//        tlPrint(message: "网络请求错误，请重新再试. Error: \(message)")
//        indicator.stop()
//        webView.isUserInteractionEnabled = true
//    }
//    //** 警告框 **
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        tlPrint(message: "runJavaScriptAlertPanelWithMessage message:\(message)")
//        let alert = UIAlertController(title: "富宝娱乐", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
//            // We must call back js
//            completionHandler()
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//    //** 确认框 **
//    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
//        tlPrint(message: "runJavaScriptConfirmPanelWithMessage message:\(message)")
//        let alert = UIAlertController(title: "富宝娱乐", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
//            // 点击完成后，可以做相应处理，最后再回调js端
//            completionHandler(true)
//        }))
//        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
//            // 点击取消后，可以做相应处理，最后再回调js端
//            completionHandler(false)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//    //** 输入框 **
//    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
//        tlPrint(message: "runJavaScriptTextInputPanelWithPrompt")
//        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
//        alert.addTextField { (textField: UITextField) -> Void in
//            textField.textColor = UIColor.red
//        }
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
//            // 处理好之前，将值传到js端
//            completionHandler(alert.textFields![0].text!)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    //==============================
//    //Mark:- 初始化网络视图，加载默认网页
//    //==============================
//    private func configWebView() {
//        
//        tlPrint(message: "configWebView")
//        //Mark:- HTML5调用Native部分
//        let scriptHandle = WKUserContentController()    //新建一个处理类
//        addScriptHanle(handle: scriptHandle)
//        let config = WKWebViewConfiguration()   //新建一个WKWebView的配置
//        config.userContentController = scriptHandle
//        
//        //Mark:- 网页加载部分
//        let bouds = self.view.frame
//        let wkFrame = CGRect(x: 0, y: 0, width: bouds.width, height: bouds.height)
//        self.automaticallyAdjustsScrollViewInsets = false
//        
//        wkWebView = WKWebView(frame: wkFrame, configuration: config)
//        wkWebView.navigationDelegate = self
//        wkWebView.uiDelegate = self
//        self.view.addSubview(wkWebView)
//    }
//    
//    //============================
//    //Mark:- 重新加载主界面
//    //============================
//    public func reloadMainPage(url: String?) -> Void {
//        tlPrint(message: "----->>>> reload page url: \(String(describing: url))")
//        //加载<富途娱乐>主界面
//        var urlString: String!
//        if let url_t = url {
//            urlString = url_t
//        } else {
//            urlString = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//            urlString = urlString + "HomePage"
//        }
//
//        tlPrint(message: "url: \(String(describing: url))")
//        tlPrint(message: "urlString: \(urlString)")
//        let urls = URL(string: urlString)
//        tlPrint(message: "urls: \(String(describing: urls))")
//        let request = URLRequest(url: urls!)
//        tlPrint(message: "request: \(request)")
//        if (wkWebView == nil) {
//            tlPrint(message: "wkWebView == nil")
//            configWebView()                 //配置网页信息
//        }
//        tlPrint(message: "load...")
//        wkWebView.stopLoading()
//        wkWebView.load(request)
//        tlPrint(message: "isLoading3: \(wkWebView.isLoading)")
//    }
//    
////    //========================
////    //Mark:- 消息通知注册
////    //========================
////    private func registerNotificationObserver()  {
////        tlPrint(message: "registerNotificationObserver")
////        tlPrint(message: "消息通知注册")
////        if isNotificationRegistered {
////            tlPrint(message: "当前已经注册了消息通知，请勿重复注册！")
////            return
////        }
////        //消息通知没有注册，或者已经移除
////        isNotificationRegistered = true
////        let notificationCenter = NotificationCenter.default
////        notificationCenter.addObserver(self, selector: #selector(paymentDeal(sender:)), name: NSNotification.Name(notificationName.PaymentRequestReturn.rawValue), object: nil)
////        
////        notificationCenter.addObserver(self, selector: #selector(paySuccessReturn), name: NSNotification.Name(notificationName.paySuccessReturn.rawValue), object: nil)
////    
////        notificationCenter.addObserver(self, selector: #selector(loginCallWebPage(sender:)), name: NSNotification.Name(notificationName.LoginCallWebPage.rawValue), object: nil)
////    }
//    
//    //========================
//    //Mark:- 消息通知移除
//    //========================
//    private func removeNotificationObserver() {
//        tlPrint(message: "消息通知移除")
//        if !isNotificationRegistered {
//            tlPrint(message: "当前消息通知还没有注册，无法进行移除操作")
//            return
//        }
//        //当前消息通知可以移除
//        isNotificationRegistered = false
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.removeObserver(self, name: NSNotification.Name(notificationName.PaymentRequestReturn.rawValue), object: nil)
//        notificationCenter.removeObserver(self, name: NSNotification.Name(notificationName.paySuccessReturn.rawValue), object: nil)
//        notificationCenter.removeObserver(self, name: NSNotification.Name(notificationName.LoginCallWebPage.rawValue), object: nil)
//        
//    }
//    
//    //==================================
//    //Mark:- 将用户名和密码传递个网页端进行登录
//    //==================================
//    func loginCallWebPage(sender: AnyObject) -> Void {
//        
//        tlPrint(message: "login call web page sender: \(sender)")
//        let object = sender.value(forKey: "object") as! Dictionary<String, String>
//        if let requests  = object["request"] {
//            
//            if userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) == nil {
//                tlPrint(message: "没有拿到域名")
//                return
//            }
//            let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//            var url: String!
//            tlPrint(message: "request: \(requests)")
//            var token = ""
//            if requests == "login" {
//                //用户登录成功，带token重载页面
//                tlPrint(message: "进入Home页面")
//                token = object["token"]!
//                //登录成功，发送token和版本号给前端
//                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendToken(sender:)), userInfo: token, repeats: true)
//            } else if requests == "register" {
//                //进入注册页面
//                tlPrint(message: "进入注册页面")
//                url = domain + "Register"
//                
//                DispatchQueue.main.async(execute: {
//                    self.reloadMainPage(url: url)
//                })
//                
//            } else if requests == "forget" {
//                //进入忘记密码页面
//                tlPrint(message: "进入忘记密码页面")
//                url = domain + "RetrievePwd"
//                DispatchQueue.main.async(execute: {
//                    self.reloadMainPage(url: url)
//                })
//            }
//        }
//    }
//    var timer: Timer!
//    
//    func sendToken(sender: AnyObject) {
//        
//        
//        let token = sender.value(forKey: "userInfo") as! String
//        tlPrint(message: "token:\(token)")
//        let version = SystemInfo.getCurrentVersion()
//        self.wkWebView.evaluateJavaScript("AccessToken('\(token)','\(version)')", completionHandler: { (response, error) in
//            tlPrint(message: "**************  response:\(String(describing: response))\t error:\(String(describing: error))")
//            if (response != nil) {
//                self.timer.invalidate()
//            }
//        })
//    }
//    
//    //========================
//    //Mark:- HTML5事件监听注册方法
//    //========================
//    private func addScriptHanle(handle:WKUserContentController) -> Void {
//        
//        let funcName = ["share", "futuPayment", "systemSound", "getTouchIDStatus", "updateUserInfo", "rotateScreen", "logOut", "showGameList", "startGame", "callLoginPage", "getAppVersion"]
//        
//        for name in funcName {
//            handle.add(self, name: name)
//        }
//    }
//    //=====================================
//    //Mark:- WKScriptMessageHandler代理方法
//    //=====================================
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        let fun = message.name
//        tlPrint(message: "fun = \(fun)")
//        let arg: AnyObject = message.body as AnyObject
//        switch fun {
//        case "share":           //分享
//            shareSDK(sender: arg)
//        case "futuPayment":     //支付
//            futuPayment(sender: arg)
//        case "systemSound":     //系统提示音和振动
//            SystemTool.systemSound(soundNumber: arg as! Int)
//        case "getTouchIDStatus"://获取手机指纹锁状态
//            TouchIDViewController.sendTouchIDStatus(sender: arg, wkWebView: wkWebView, rootViewController: self)
//        case "updateUserInfo":  //更新用户数据
//            TouchIDViewController.updateUserInfo(sender: arg)
//        case "rotateScreen":    //屏幕旋转
//            rotateScreen(sender: arg)
//        case "logOut":          //登出，清空本地存储
//            LogoutController.logOut()
//            reloadMainPage(url: nil)
//        case "showGameList":    //调用游戏列表页面
//            showGameList(sender: arg)
//        case "startGame":       //开始游戏，跳转到游戏界面
//            startGame(sender: arg)
//        case "callLoginPage":   //调用登陆页面
//            callLoginPage()
//        case "getAppVersion":
//            getAppVersion()
//        default:
//            tlPrint(message: "no such case!")
//        }
//    }
//    
//    //========================
//    //Mark:- 调用本地登陆页面
//    //========================
//    func callLoginPage() -> Void {
//        if loginVC == nil {
//            loginVC = LoginViewController()
//        }
//        self.navigationController?.pushViewController(loginVC, animated: true)
//    }
//    
//    //========================
//    //Mark:- 旋转屏幕
//    //========================
//    func  rotateScreen(sender: AnyObject) -> Void {
//        
//        tlPrint(message: "rotateScrenn sender: \(sender)")
//        if let oritation = sender.value(forKey: "oritation") {
//            switch oritation as! String {
//            case "portrait":
//                
//                RotateScreen.portrait()
//            case "right":
//
//                RotateScreen.right()
//            case "left":
//
//                RotateScreen.left()
//            default:
//                break
//            }
//        }
//    }
//    
//    
//    //===========================================
//    //Mark:- 已经登陆过，自动登录处理
//    //===========================================
//    func autoLoginDeal() -> Void {
//        
//        tlPrint(message: "autoLoginDeal")
//        if let hasLogin = userDefaults.value(forKey: userDefaultsKeys.userHasLogin.rawValue) {
//            if hasLogin as! Bool {      //用户已经登录
//                
//                let network = TTNetworkRequest()
//                let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//                let url = domain + loginApi
//                let username = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue) as! String
//                let password = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue) as! String
//                let info =  ["isApp":"2", "grant_type":"password","username":username, "password":password]
//                tlPrint(message: "----------------------   \n        login info :\(info)\n-------------------------")
//                if loginVC == nil {
//                    loginVC = LoginViewController()
//                }
//                network.postWithPath(path: url, paras: info, success: { (response) in
//                    
//                    if let value = response {
//                        self.loginVC.longinReturnDeal(response: value as AnyObject, username: username, password: password, isLoginPage: true)
//                    } else {
//                        self.loginVC.longinReturnDeal(response: ["error":"","error_description":"用户名或密码不正确"] as AnyObject, username: username, password: password, isLoginPage: true)
//                    }
//                    
//                    }, failure: { (error) in
//                        tlPrint(message: "error:\(error)")
//                        DispatchQueue.main.async(execute: {
//                            let errorCode = error.localizedDescription
//                            tlPrint(message: "error code: \(errorCode)")
//                            //let alert = UIAlertView(title: "登录失败", message: errorCode, delegate: self, cancelButtonTitle: "确定")
//                            let alert = UIAlertView(title: "登录失败", message: "当前出现网络错误，请检查网络连接状态后再试！", delegate: self, cancelButtonTitle: "确定")
//                            alert.show()
//                            self.callLoginPage()
//                        })
//                })
//            } else {
//                tlPrint(message: "userHasLogin = false")
//                callLoginPage()         //跳转到登陆界面
//            }
//        } else {
//            tlPrint(message: "userHasLogin 没有")
//            userDefaults.setValue(false, forKey: userDefaultsKeys.userHasLogin.rawValue)
//            callLoginPage()             //跳转到登陆界面
//        }
//    }
//    
//    //========================
//    //Mark:- 支付成功以后回到中心钱包界面
//    //========================
//    func paySuccessReturn() -> Void {
//        tlPrint(message: "paySuccessReturn")
//        
//        
//        if let domain_t = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) {
//            let domain = domain_t as! String
//            let url = domain + "wallet"
//            reloadMainPage(url: url)
//        }
//    }
//    
//    //========================
//    //Mark:- 分享功能入口
//    //========================
//    private func shareSDK(sender: AnyObject) -> Void {
//        
//        tlPrint(message: "shareSDK:\(sender)")
//        if let info = sender as? Dictionary<String, Any> {
//            tlPrint(message: "info:\(info)")
//            self.wkWebView.evaluateJavaScript("ShareAbled()", completionHandler: nil)
////            share.showActionSheet(info)//此方法为弹出分享窗
//            
//        } else {
//            tlPrint(message: "received error data.")
//        }
//    }
//    
//    //==============================================
//    //Mark:- 支付处理函数（根据中专API返回的内容选择支付方式）
//    //==============================================
//    public func paymentDeal(sender: NSMutableDictionary) -> Void {
//        
//        if let object = sender.value(forKey: "object") {
//            tlPrint(message: "paymentDeal object: \(object)")
//            let value = object as AnyObject
//            if let success = value.value(forKey: "Success") {
//                if !(success as! Bool) {
//                    //返回值为0，弹窗提示，不进行支付
//                    if let message = value.value(forKey: "Message") {
//                        let alert = UIAlertView(title: "支付提醒", message: (message as! String), delegate: self, cancelButtonTitle: "确 定")
//                        alert.show()
//                        return
//                    }
//                }
//                
//                if let orderModel = value.value(forKey: "OrderModel") {
//                    //返回值为1，进行支付
//                    tlPrint(message: "orderModel = \(orderModel)")
//                    
//                    if (orderModel as AnyObject).value(forKey: "PayName") != nil {
//                        //                        switch payTypeConfirm(payName: payName as! String)  {
//                        //                        //判断支付方式
//                        //                        case "ZF":
//                        //                            //dinpay(sender: orderModel as AnyObject)
//                        //                            FutuPayController.dinpay(sender: orderModel as AnyObject, rootViewControler: self)
//                        //                        case "O2P":
//                        //                            tlPrint(message: "---  02P  ---")
//                        //                            //webPay(sender: value)
//                        //                            WebPayController.webPay(sender: value, wkWebView: self.wkWebView)
//                        //                        default:
//                        //                            tlPrint(message: "未知的支付选项")
//                        //                        }
//                        //                        if payTypeConfirm(payName: payName as! String) == "ZF" {
//                        //                            FutuPayController.dinpay(sender: orderModel as AnyObject, rootViewControler: self)
//                        //                        } else {
//                        //WebPayController.webPay(sender: value, wkWebView: self.wkWebView)
//                        tlPrint(message: "***  跳转到支付页面  ***")
//                        let onlinePayVC = OnlinePayViewController(param: value)
//                        self.navigationController?.pushViewController(onlinePayVC, animated: true)
//                        //}
//                        
//                    } else {
//                        tlPrint(message: "can not get the PayName")
//                    }
//                } else {
//                    tlPrint(message: "can not get the OrderModel")
//                }
//            }
//        }
//    }
//    
//    //========================
//    //Mark:- 根据返回的PayName判断支付方式
//    //========================
//    func payTypeConfirm(payName: String) -> String {
//        
//        tlPrint(message: "payTypeConfirm payName: \(payName)")
//        var returnValue = ""
//        
//        if (payName.range(of: "zf") != nil) || (payName.range(of: "ZF") != nil) {
//            //智付
//            returnValue = "ZF"
//        } else if (payName.range(of: "O2P") != nil || payName.range(of: "O2p") != nil) {
//            //OpenToPay
//            returnValue = "O2P"
//        }
//        return returnValue
//    }
//    
//    //========================
//    //Mark:- 富途支付总入口
//    //========================
//    private func futuPayment(sender: AnyObject) -> Void {
//        
//        tlPrint(message: "sender: \(sender)")
//        //中转接口请求参数
//        var urlString: String
//        var token: String
//        
//        //给中转接口的传递参数
//        var amount: Float
//        var paytype: String
//        var bankCode: String
//        
//        if let url = sender.value(forKey: "url") {
//            urlString = url as! String
//        } else {
//            tlPrint(message: "not have url recieved")
//            return
//        }
//        if let receiveToken = sender.value(forKey: "token") {
//            token = receiveToken as! String
//        } else {
//            tlPrint(message: "not have token recieved")
//            return
//        }
//        if let receiveAmount = sender.value(forKey: "amount") {
//            amount = receiveAmount as! Float
//        } else {
//            tlPrint(message: "not have Amount Amount")
//            return
//        }
//        if let receivepaytype = sender.value(forKey: "paytype") {
//            paytype = receivepaytype as! String
//        } else {
//            tlPrint(message: "not have paytype recieved")
//            return
//        }
//        if let receiveBankCode = sender.value(forKey: "bankcode") {
//            bankCode = receiveBankCode as! String
//            var bankName = ""
//            if bankCode == "weixin" {
//                bankName = "微信支付"
//            } else if bankCode == "online" {
//                bankName = "在线支付"
//            } else if bankCode == "alipay" {
//                bankName = "支付宝支付"
//            }
//            userDefaults.setValue(bankName, forKey: "onlinePayName")
//            
//        } else {
//            tlPrint(message: "not have bankcode recieved")
//            return
//        }
//        tlPrint(message: "支付请求中转API地址：\(urlString)")
//        
//        
//        let Amount = String(amount)
//        var domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//        
//        //去掉hppt:// 或者 https://
//        let index = domain.range(of: "https://") == nil ? 7 : 8
//        domain = (domain as NSString).substring(from: index)
//        
//        let url = domain + "WalletRecharge"
//        
//        let params: NSMutableDictionary = ["Amount":Amount,"paytype":paytype,"BankCode":bankCode,"ReturnDomain":url]
//        FuTuPayNetworking.httpPostRequest(urlString: urlString, token: token, params: params, returnNotificationName: notificationName.PaymentRequestReturn)
//    }
//    
//    //===========================================
//    //Mark:- get请求获得当前最新域名和版本信息等
//    //===========================================
//    func requestLatestInfo() -> Void {
//        tlPrint(message: "requestLatestInfo")
//        let userDefaults = UserDefaults.standard
//        
//        var returnValue  = NSDictionary()
//        
//        //动态域名url字符串的转码
//        let urlString = dynamicDomainUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//        
//        //创建管理者对象
//        let manager = AFHTTPSessionManager()
//        
//        //设置允许请求的类别
//        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "text/json", "application/json","charset=utf-8","text/javascript","text/html", "application/javascript", "text/js") as? Set<String>
//        manager.securityPolicy.allowInvalidCertificates = true
//        
//        //数据类型选择
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFJSONResponseSerializer()
//        
//        let _ = DispatchQueue.global().sync {
//            manager.get(urlString, parameters: nil, progress: { (progress) in
//                
//                
//                }, success: { (task, response) in
//                    returnValue = response as! NSDictionary
//                    
//                    tlPrint(message: "response:\(String(describing: response))")
//                    let oldDomainName = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue)
//                    let oldAppVersion = SystemInfo.getCurrentVersion()
//                    let newDomainName = returnValue.value(forKey: "doMain")
//                    let newAppVersion = returnValue.value(forKey: "version")
//                    if let domainName = newDomainName {
//                        if (domainName as! String) != (oldDomainName as! String)  {
//                            //将新的域名写进数据库，发送重新加载网页的消息通知
//                            let domain = domainName as! String
//                            tlPrint(message: "domain1: \(domain)")
//                            userDefaults.setValue((domain), forKey: userDefaultsKeys.domainName.rawValue)
//                            userDefaults.synchronize()
//                            self.reloadMainPage(url: nil)
//                        }
//                        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
//                        tlPrint(message: "domain2: \(domain)")
//                    }
//                    
//                    if let appVersion = newAppVersion {
//                        if (appVersion as! String) != oldAppVersion {
//                            //有新的版本，提示用户更新
//                            tlPrint(message: "请更新版本")
//                            if let updateUrl = returnValue.value(forKey: "downloadAddr") {
//                                //获取app的更新地址
//                                tlPrint(message: "get the download address: \(updateUrl)")
//                                self.appUpdateUrl = (updateUrl as! String)
//                                let alert = UIAlertView(title: "升级提示", message: "你当前的版本是V\(oldAppVersion)，发现新版本V\(appVersion as! String),是否下载新版本？", delegate: self, cancelButtonTitle: "下次再说", otherButtonTitles: "立即下载")
//                                alert.tag = 10
//                                alert.show()
//                                tlPrint(message: "当前bundleID为：\(SystemInfo.getBundleID())")
//                            }
//                        }
//                    }
//                    tlPrint(message: "response:\(String(describing: response))")
//                }, failure: { (task, error) in
//                    tlPrint(message: "请求失败\nERROR:\n\(error)")
//            })
//        }
//    }
//    
//    var appUpdateUrl = ""
//    //弹窗处理函数
//    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
//        tlPrint(message: "alertView - clickedButtonAt")
//        switch alertView.tag {
//        case 10:
//            if buttonIndex == 1 {
//                //确认更新app
//                let url = URL(string: appUpdateUrl)
//                tlPrint(message: "new app url: \(String(describing: url))")
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url!, options: [:], completionHandler: { (response) in
//                        tlPrint(message: "response:\(response)")
//                    })
//                } else {
//                    UIApplication.shared.openURL(url!)
//                }
//            }
//        default:
//            tlPrint(message: "no such case")
//        }
//    }
//    
//    
//    //===========================================
//    //Mark:- 进入游戏列表页面
//    //===========================================
//    func showGameList(sender: AnyObject) -> Void {
//        tlPrint(message: "showGameList")
//        tlPrint(message: "sender: \(sender)")
//        
//        
//        //进入列表页之前旋转为横屏
//        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        //appDelegate.blockRotation = UIInterfaceOrientationMask.landscapeRight
//        self.rotateScreen(sender: ["oritation":"right"] as AnyObject)
//       
////        let gameListVC = ListViewController()
////        gameListVC.param = sender
////        tlPrint(message: "开始跳转到游戏列表界面")
////        self.navigationController?.pushViewController(gameListVC, animated: true)
//     
////        DispatchQueue.global().async {
////            
////            sleep(1)
////            tlPrint(message: "调用js OpenGame()")
////            self.wkWebView.evaluateJavaScript("OpenGame()", completionHandler: nil)
////        }
//        
//        //RotateScreen.right()
//        userDefaults.setValue(sender.value(forKey: "gameType"), forKey: userDefaultsKeys.gameType.rawValue)
//        let gameListVC = GameListViewController()
//        gameListVC.param = sender
//        self.navigationController?.pushViewController(gameListVC, animated: true)
//
//    }
//
//
//    //===========================================
//    //Mark:- 开始游戏，跳转到游戏界面
//    //===========================================
//    func startGame(sender: AnyObject) -> Void {
//        tlPrint(message: "startGame")
//        tlPrint(message: "sender: \(sender)")
//        userDefaults.setValue(sender.value(forKey: "gameType"), forKey: userDefaultsKeys.gameType.rawValue)
//        let gameVC = GameViewController()
//        gameVC.param = sender
//                tlPrint(message: "开始跳转到游戏界面")
//        self.navigationController?.pushViewController(gameVC, animated: true)
//        
//        DispatchQueue.global().async {
//            sleep(1)
//            tlPrint(message: "调用js OpenGame()")
//            self.wkWebView.evaluateJavaScript("OpenGame()", completionHandler: nil)
//        }
//    }
//    
//    //===========================================
//    //Mark:- 将app的版本信息发送给H5
//    //===========================================
//    func getAppVersion() -> Void {
//        tlPrint(message: "getAppVersion")
//        let version = SystemInfo.getCurrentVersion()
//        wkWebView.evaluateJavaScript("AccessToken('','\(version)')") { (response, error) in
//            tlPrint(message: "response: \(String(describing: response))")
//        }
//    }
//}
