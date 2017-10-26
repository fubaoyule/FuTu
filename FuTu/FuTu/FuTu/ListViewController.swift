//
//  ListViewController.swift
//  FuTu
//
//  Created by Administrator1 on 2/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit
import WebKit

class ListViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    var isTokenSend = false
    var param: AnyObject!
    var wkWebView: WKWebView!
    let screenSize = UIScreen.main.bounds.size
    var indicator : TTIndicators!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        tlPrint(message: "======= list View controller =======")
        self.navigationController?.isNavigationBarHidden = true
        
        initReturnBtn()
        
        configWebView(sender: param)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tlPrint(message: "viewWillAppear")
        rotateToLanscap()
        currentScreenOritation = UIInterfaceOrientationMask.landscapeRight
        wkWebView.isUserInteractionEnabled = true
    }
    
    var hasSendToken = false
    
    override func viewDidAppear(_ animated: Bool) {
        
        if hasSendToken {
            return
        }
        hasSendToken = true
        if let token_t = userDefaults.value(forKey: userDefaultsKeys.userToken.rawValue) {
            let token = token_t as! String
            tlPrint(message: "userToken = \(token)")
            self.wkWebView.evaluateJavaScript("setToken('\(token)')", completionHandler: nil)
            

        }
    }
    
    //===========================================
    //Mark:- WKNavigationDelegate代理方法-［生命周期］
    //===========================================
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        tlPrint(message: "webView didStartProvisionalNavigation")
        let gameUrl = webView.url
        tlPrint(message: "list start Url: \(String(describing: gameUrl))")
        tlPrint(message: "list start time: \(getTime())")

        if indicator == nil {
            indicator = TTIndicators(view: wkWebView, frame: landscapeIndicatorFrame)
        }
        indicator.play(frame: landscapeIndicatorFrame)
        
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
        tlPrint(message: "webView commitPreviewingViewController")
    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tlPrint(message: "webView didFinish")
        if indicator != nil {
            indicator.stop()
        }
        
    }
    
    //========================
    //Mark:- HTML5事件监听注册方法
    //========================
    private func addScriptHanle(handle:WKUserContentController) -> Void {
        tlPrint(message: "addScriptHanle")
        
        handle.add(self, name: "startGame")
    }
    //=====================================
    //Mark:- WKScriptMessageHandler代理方法
    //=====================================
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        tlPrint(message: "userContentController")
        let fun = message.name
        tlPrint(message: "fun = \(fun)")
        let arg: AnyObject = message.body as AnyObject
        switch fun {
        case "startGame":
            startGame(sender: arg)
            
        default:
            tlPrint(message: "no such case!")
        }
    }
    

    //===========================================
    //Mark:- 开始游戏，跳转到游戏界面
    //===========================================
    func startGame(sender: AnyObject) -> Void {
        tlPrint(message: "startGame")
        tlPrint(message: "sender: \(sender)")
        let gameVC = GameViewController()
        gameVC.param = sender
        gameVC.isFromLandscap = true
        //判断游戏界面的方向
        if let orientation = sender.value(forKey: "orientation") {
            if orientation as! String == "right" || orientation as! String == "left" {
                rotateToLanscap()
            } else if orientation as! String == "portrait" {
                rotateToPortrait()
            }
            gameVC.isFromLandscap = true
        }
        
        tlPrint(message: "开始跳转到游戏界面")
        self.navigationController?.pushViewController(gameVC, animated: true)
        
        DispatchQueue.global().async {
            sleep(1)
            //OpenGame() 为防重复的JS方法
            tlPrint(message: "调用js OpenGame()")
            self.wkWebView.evaluateJavaScript("OpenGame()", completionHandler: nil)
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
        currentScreenOritation = UIInterfaceOrientationMask.landscapeRight
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = UIInterfaceOrientationMask.portrait
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    //==============================
    //Mark:- 初始化网络视图，加载默认网页
    //==============================
    private func configWebView(sender: AnyObject) {
        
        tlPrint(message: "configWebView")
        //Mark:- HTML5调用Native部分
        let scriptHandle = WKUserContentController()    //新建一个处理类
        addScriptHanle(handle: scriptHandle)
        let config = WKWebViewConfiguration()   //新建一个WKWebView的配置
        config.userContentController = scriptHandle
        
        //Mark:- 网页加载部分
        let bouds = self.view.frame
        let wkFrame = CGRect(x: 0, y: 0, width: bouds.height, height: bouds.width)
        self.automaticallyAdjustsScrollViewInsets = false
        
        wkWebView = WKWebView(frame: wkFrame, configuration: config)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        wkWebView.backgroundColor = UIColor.black
        self.view.insertSubview(wkWebView, at: 0)
        
        
        //根据参数的地址显示列表界面
        if let urlString_t = sender.value(forKey: "url") {
            
            let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
            let urlString = domain + (urlString_t as! String)
            let url = URL(string: urlString )
            let request = URLRequest(url: url!)
//            tlPrint(message: "reqeust: \(request) \t url: \(url)")
            wkWebView.load(request)
            
            
        } else {
            tlPrint(message: "没有拿到列表地址")
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
        
        returnFrame = CGRect(x: 0, y: 0, width: 80, height: 50)
        returnBtn.backgroundColor = UIColor.clear
        
        returnBtn.frame = returnFrame
        tlPrint(message: "returnBtn.frame = \(returnBtn.frame)")
        returnBtn.addTarget(self, action: #selector(listReturnAct), for: .touchUpInside)
    }
    
    func listReturnAct() {
        
        tlPrint(message: "listReturnAct")
        rotateToPortrait()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override var shouldAutorotate: Bool{
        return false
    }

    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }

}
