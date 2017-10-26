//
//  GameViewController.swift
//  FuTu
//
//  Created by Administrator1 on 23/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit
import WebKit

class GameViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {


    var param: AnyObject!
    var isFromLandscap = false  //上一页的屏幕方向（默认竖屏）
    var wkWebView: WKWebView!
    var indicator : TTIndicators!
    let screenSize = UIScreen.main.bounds.size
    var gameType:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.gray
        tlPrint(message: "game view controller")
        //self.gameType = self.param.value(forKey: "gameType") as! String
        //旋转当前页面到指定的方向
        if let orientation = self.param.value(forKey: "orientation") {
            if (orientation as! String) == "right" {
//                RotateScreen.right()
                self.rotateToLanscap()
            } else if (orientation as! String) == "portrait" {
//                RotateScreen.portrait()
                self.rotateToPortrait()
            }
        }
    
        
        configWebView(sender: param)
        
        //判断是否需要返回按钮
        if param.value(forKey: "notNeedReturnBtn") == nil {
            initReturnBtn()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        //修改状态栏颜色
        return UIStatusBarStyle.lightContent
    }
    
    
    //===========================================
    //Mark:- WKUIDelegate代理方法-［生命周期］
    //===========================================
    //** 警告框 **
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        tlPrint(message: "runJavaScriptAlertPanelWithMessage message:\(message)")
        let alert = UIAlertController(title: "富途娱乐", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            // We must call back js
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //** 确认框 **
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        tlPrint(message: "runJavaScriptConfirmPanelWithMessage message:\(message)")
        let alert = UIAlertController(title: "富途娱乐", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            // 点击完成后，可以做相应处理，最后再回调js端
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            // 点击取消后，可以做相应处理，最后再回调js端
            completionHandler(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //** 输入框 **
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        tlPrint(message: "runJavaScriptTextInputPanelWithPrompt")
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) -> Void in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            // 处理好之前，将值传到js端
            completionHandler(alert.textFields![0].text!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     http://777.futubet.co/game/casino/5068/
     http://777.futubet.co/game/casino/5805/
     http://777.futubet.co/game/casino/5823/
     http://777.futubet.co/game/casino/5014/
     
     http://777.futubet.co/game/casino/5013/
     http://777.futubet.co/game/casino/5835/
     http://777.futubet.co/elibom/SlotGameTemplate/index.html?GameType=5010
     http://777.futubet.co/elibom/SlotGameTemplate/index.html?GameType=5407
     
     http://777.futubet.co/elibom/SlotGameTemplate/index.html?GameType=5044
     http://777.futubet.co/elibom/SlotGameTemplate/index.html?GameType=5043
     http://777.futubet.co/elibom/SlotGameTemplate/index.html?GameType=5404
     http://777.futubet.co/elibom/SlotGameTemplate/index.html?GameType=5005
     
     http://777.futubet.co/game/casino/5095
     http://777.futubet.co/elibom/SlotGameTemplate/index.html?GameType=5076
     http://777.futubet.co/elibom/SlotGameTemplate/index.html?GameType=5083
     http://777.futubet.co/game/casino/5084/
     
     http://777.futubet.co/game/casino/5837/
     http://777.futubet.co/ipl/app/member/game/Game.php?HTML5=Y&Client=2&GameType=5902&lang=cn&HALLID=3517499 (OK竖屏)
     http://777.futubet.co/ipl/app/member/game/Game.php?HTML5=Y&Client=2&GameType=5901&lang=cn&HALLID=3517499 (OK竖屏)
     http://777.futubet.co/game/casino/5106/
     
     http://777.futubet.co/game/casino/5402/
     http://777.futubet.co/game/casino/5015（OK不用滑动）
     http://777.futubet.co/game/casino/5067/
     http://777.futubet.co/game/casino/5803/
     
     http://777.futubet.co/game/casino/5810/
     http://777.futubet.co/ipl/app/member/game/Game.php?HTML5=Y&Client=2&GameType=5054&lang=cn&HALLID=3517499(OK竖屏)
     http://777.futubet.co/ipl/app/member/game/Game.php?HTML5=Y&Client=2&GameType=5090&lang=cn&HALLID=3517499（需要横屏）
     http://777.futubet.co/game/casino/5069
     */
    
    //===========================================
    //Mark:- WKNavigationDelegate代理方法-［生命周期］
    //===========================================
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        tlPrint(message: "webView didStartProvisionalNavigation")
        let indicatorFrame: CGRect!
        tlPrint(message: "game start Url: \(webView.url)")
        tlPrint(message: "game start time: \(getTime())")
    
        let urlString = "\(webView.url)"
        
        tlPrint(message: "还没有gameType 传递过来")
//        if self.gameType == "BBIN" {
//            if urlString.components(separatedBy: "game/casino").count >= 2 {
//                tlPrint(message: "BBIN准备开始游戏，需要横屏显示")
//                self.rotateToLanscap()
//                self.wkWebView.frame = CGRect(x: 20, y: 20, width: 400, height: 250)
////                self.wkWebView.scrollView.contentSize = CGSize(width: deviceScreen.width, height: 50)
//            }
//        }
        
        
        
        if currentScreenOritation == UIInterfaceOrientationMask.portrait {
            indicatorFrame = portraitIndicatorFrame
        } else {
            indicatorFrame = landscapeIndicatorFrame
            tlPrint(message: "当前为横屏")
        }
        if indicator == nil {
            indicator = TTIndicators(view: wkWebView, frame: indicatorFrame)
        }
        indicator.play(frame: indicatorFrame)
        
        //判断是否在请求列表页
        if let currentURL = wkWebView.url {
            
            if (String(describing: currentURL).range(of: "_List") != nil) {
                tlPrint(message: "需要跳转回列表页")
                if isFromLandscap {
                    RotateScreen.right()
                }
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController){
        tlPrint(message: "webView commitPreviewingViewController")
    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tlPrint(message: "webView didFinish")

        if indicator != nil {
            let userDefaults = UserDefaults.standard
            if let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue){
                if gameType as! String == "BS" {
                    sleep(5)
                }
            }
            indicator.stop()
        }
        
        let gameUrl = webView.url
        tlPrint(message: "game end Url: \(gameUrl)")
        tlPrint(message: "game end time: \(getTime())")
    }
    

    /*GD failed url:
    http://gd.toobet.com/main.php?OperatorCode=futuu0026lang=zh-cnu0026playerid=Taylor4u0026LoginTokenID=KXNYfrJKX4wu0026Currency=CNYu0026Key=af8af420f94a1cbd6b6e3ee1bf8ee1523b65f77901edf1d8d268c443b7003e83u0026mobile=1
     
    http://gd.toobet.com/main.php?OperatorCode=futu&lang=zh-cn&playerid=tiger01&LoginTokenID=9vqT7lhu6jg&Currency=CNY&Key=c1f6404cedabfb246877fa8977e234975fcc744ddb25755bc65626dbe30e644f&mobile=1

     GD html success url:
 
     */
    
    
    
    //==============================
    //Mark:- 初始化网络视图，加载默认网页
    //==============================
    private func configWebView(sender: AnyObject) {
        
        tlPrint(message: "configWebView")
        //Mark:- HTML5调用Native部分
        let scriptHandle = WKUserContentController()    //新建一个处理类
        //addScriptHanle(handle: scriptHandle)
        let config = WKWebViewConfiguration()   //新建一个WKWebView的配置
        config.userContentController = scriptHandle
        //Mark:- 网页加载部分
        let bouds = self.view.frame
        var wkFrame = CGRect(x: 0, y: 0, width: bouds.width, height: bouds.height)
        let userDefaults = UserDefaults.standard
        
        if let gameType = userDefaults.value(forKey: userDefaultsKeys.gameType.rawValue) {
            tlPrint(message: "gameType:\(gameType)")
            let gameType = gameType as! String
            if currentScreenOritation == .portrait && (gameType == "SB" || gameType == "BBIN_City" || gameType == "service") {
                wkFrame = CGRect(x: 0, y: 20, width: bouds.width, height: bouds.height - 20)
            }
//            else if (gameType == "BBIN") {
//                wkFrame = CGRect(x: 0, y: 0, width: bouds.width, height: bouds.height)
//            }
        }
//        
//        if (self.param.value(forKey: "gameType") as! String) == "BBIN" {
//            wkFrame = CGRect(x: 0, y: 0, width: bouds.height, height: bouds.width)
//        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        wkWebView = WKWebView(frame: wkFrame, configuration: config)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        wkWebView.backgroundColor = UIColor.black
//        wkWebView.scrollView.showsVerticalScrollIndicator = false
//        wkWebView.scrollView.alwaysBounceVertical = true
        wkWebView.scrollView.bounces = false//关闭回弹效果
//        wkWebView.scrollView.isScrollEnabled = false
        self.view.insertSubview(wkWebView, at: 0)
        rotateScreen(sender: sender)
        //根据参数的地址显示游戏界面
        if let urlString = sender.value(forKey: "url") {
            tlPrint(message: "urlString:\(urlString)")
            if (urlString as! String) == "Failed" || (urlString as! String) == "" {
                tlPrint(message: "没有获取到游戏链接")
                let alert = UIAlertView(title: "", message: "获取游戏地址失败", delegate: nil, cancelButtonTitle: "确 认")
                DispatchQueue.main.async {
                    alert.show()
                }
                _ = self.navigationController?.popViewController(animated: true)
                return
            }
            let urlString_success = (urlString as! String).replacingOccurrences(of: "u0026", with: "&")
            let url = URL(string: urlString_success)
            var request = URLRequest(url: url!)
            
            request.timeoutInterval = 10
            wkWebView.load(request)
        } else {
            tlPrint(message: "没有拿到游戏地址")
        }
        tlPrint(message: "configWebView end")
    }
    
    
    
    
    //==============================
    //Mark:- 初始化返回按钮
    //==============================
    
    private func initReturnBtn() {
        
        tlPrint(message: "gameVC size: \(screenSize)")
        let returnFrame: CGRect!
        let returnBtn = UIButton()
        self.view.insertSubview(returnBtn, at: 1)
        
        if currentScreenOritation == UIInterfaceOrientationMask.portrait {
            //前面一个页面为竖屏
            returnFrame = CGRect(x: 0, y: 0, width: 40, height: 60)
            returnBtn.setImage(UIImage(named: "returnIcon"), for: .normal)
            returnBtn.backgroundColor = UIColor.clear
        } else {
            //前面一个页面为横屏
            returnFrame = CGRect(x: -5, y: screenSize.height/2 - 50, width: 40, height: 100)
            returnBtn.setImage(UIImage(named: "img_backBtn"), for: .normal)
            
        }
        returnBtn.frame = returnFrame
        
        tlPrint(message: "returnBtn.frame = \(returnBtn.frame)")
        returnBtn.addTarget(self, action: #selector(gameReturnAct), for: .touchUpInside)
        
    }

    func gameReturnAct() {
        tlPrint(message: "gameReturnAct")
        //返回的时候页面有可能正在loading,页面被禁止交互
        self.rotateToPortrait()
        if indicator != nil {
            indicator.stop()
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //========================
    //Mark:- 旋转屏幕
    //========================
    func  rotateScreen(sender: AnyObject) -> Void {
        
        tlPrint(message: "rotateScrenn sender: \(sender)")
        
        if let oritation = sender.value(forKey: "orientation") {
            switch oritation as! String {
            case "portrait":
                RotateScreen.portrait()
            case "right":
                RotateScreen.right()
            case "left":
                RotateScreen.left()
            default:
                break
            }
        } else {
            tlPrint(message: "没有收到旋转屏幕的命令")
        }
    }
    
    
    
    
    //旋转到横屏
    func rotateToLanscap() -> Void {
        
        currentScreenOritation = UIInterfaceOrientationMask.landscapeRight
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.landscapeRight
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    //旋转到竖屏
    func rotateToPortrait() -> Void {
        tlPrint(message: "旋转到竖屏")
        currentScreenOritation = UIInterfaceOrientationMask.portrait
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.portrait
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
