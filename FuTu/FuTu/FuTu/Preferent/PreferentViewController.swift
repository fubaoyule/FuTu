//
//  PreferentViewController.swift
//  FuBao
//
//  Created by Administrator1 on 16/8/17.
//  Copyright © 2017 Taylor Tan. All rights reserved.
//

import UIKit
import WebKit

class PreferentViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    
    var wkWebView: WKWebView!
    var indicator : TTIndicators!
    let screenSize = UIScreen.main.bounds.size
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.gray
        tlPrint(message: "game view controller")
    
        
        self.configWebView()
//        //判断是否需要返回按钮
//        if param.value(forKey: "notNeedReturnBtn") == nil {
//            initReturnBtn()
//        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        //修改状态栏颜色
        return UIStatusBarStyle.default
    }

    
    //===========================================
    //Mark:- WKUIDelegate代理方法-［生命周期］
    //===========================================
    //** 警告框 **
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        tlPrint(message: "runJavaScriptAlertPanelWithMessage message:\(message)")
        let alert = UIAlertController(title: "富宝娱乐", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            // We must call back js
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //** 确认框 **
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        tlPrint(message: "runJavaScriptConfirmPanelWithMessage message:\(message)")
        let alert = UIAlertController(title: "富宝娱乐", message: message, preferredStyle: .alert)
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
    
    
    //===========================================
    //Mark:- WKNavigationDelegate代理方法-［生命周期］
    //===========================================
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        tlPrint(message: "webView didStartProvisionalNavigation")
        tlPrint(message: "game start Url: \(String(describing: webView.url))")

        if indicator == nil {
            indicator = TTIndicators(view: wkWebView, frame: portraitIndicatorFrame)
        }
        indicator.play(frame: portraitIndicatorFrame)
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController){
        tlPrint(message: "webView commitPreviewingViewController")
    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tlPrint(message: "webView didFinish")
        
        if indicator != nil {
            indicator.stop()
        }
        let gameUrl = webView.url
        tlPrint(message: "game end Url: \(String(describing: gameUrl))")
        tlPrint(message: "game end time: \(getTime())")
    }
    
    
    
    
    //==============================
    //Mark:- 初始化网络视图，加载默认网页
    //==============================
    private func configWebView() {
        
        tlPrint(message: "configWebView")
        //Mark:- HTML5调用Native部分
        let scriptHandle = WKUserContentController()    //新建一个处理类
        //addScriptHanle(handle: scriptHandle)
        let config = WKWebViewConfiguration()   //新建一个WKWebView的配置
        config.userContentController = scriptHandle
        //Mark:- 网页加载部分
        let bouds = self.view.frame
        let wkFrame = CGRect(x: 0, y: 0, width: bouds.width, height: bouds.height)
        let userDefaults = UserDefaults.standard
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        wkWebView = WKWebView(frame: wkFrame, configuration: config)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        wkWebView.backgroundColor = UIColor.white
//        wkWebView.scrollView.showsVerticalScrollIndicator = false
//        wkWebView.scrollView.alwaysBounceVertical = true
        wkWebView.scrollView.bounces = false//关闭回弹效果
//        wkWebView.scrollView.isScrollEnabled = false
        self.view.insertSubview(wkWebView, at: 3)
        let domain = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) as! String
        
        let url = URL(string: domain + "Offer")
        clearCacheWithURL(url: url!)
//        var request = URLRequest(url: url!)
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        wkWebView.load(request)
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
        if indicator != nil {
            indicator.stop()
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func refreshAct() -> Void {
        tlPrint(message: "refreshAct()")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
