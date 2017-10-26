////
////  TouchIDViewController.swift
////  FuTu
////
////  Created by Administrator1 on 11/10/16.
////  Copyright © 2016 Taylor Tan. All rights reserved.
////
//
//
//
//import UIKit
//import LocalAuthentication
//import WebKit
//
//var isTouchIDLock = false
//
//class TouchIDViewController: UIViewController {
//    
//    
//    let userDefaults = UserDefaults.standard
//    
//    var rootViewController: ViewController?
//    let touchIDView:UIView = UIView()
//    let userNameLabel:UILabel = UILabel()
//    let otherUserLoginBtn:UIButton = UIButton()
//    let touchIDLoginBtn:UIButton = UIButton()
//    let otherUserLoginBtnTag = 100
//    let touchIDLoginBtnTag = 101
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tlPrint(message: " you have entered TouchIDVC")
//        let width = self.view.frame.width
//        let height = self.view.frame.height
//        let widthP = width * 0.5
//        let widthB = width * 0.9
////        let widthL = width * 0.8
//        let cornerRadius = CGFloat(4.25)
////        let userDefaults = UserDefaults.standard
//        self.view.backgroundColor = UIColor.futuBlue()
//        
//        // Do any additional setup after loading the view.
//        touchIDView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        touchIDView.backgroundColor = UIColor.futuWhite()
//        
//        self.view.addSubview(touchIDView)
//        
//        
//        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44))
//        titleLabel.backgroundColor = UIColor.futuBlue()
//        titleLabel.text = "指纹密码"
//        titleLabel.textColor = UIColor.white
//        titleLabel.textAlignment = .center
//        
//        touchIDView.addSubview(titleLabel)
//        
//        //Add user name label
//        //var userName = userDefaults.object(forKey: "login_user_name")as? String
////        var userName = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue) as? String
////        if userName == nil{
////            userName = ""
////        }
////        userNameLabel.frame = CGRect(x: ( width - widthL) / 2, y: widthL / 5, width: widthL, height: widthL / 3)
////        
////        userNameLabel.text = userName
////        userNameLabel.textColor = UIColor.futuBlue()
////
////        userNameLabel.font = UIFont.systemFont(ofSize: 25)
////        userNameLabel.textAlignment = NSTextAlignment.center
////        touchIDView.addSubview(userNameLabel)
//        
//        //Create the button for verify by TouchID
//        touchIDLoginBtn.frame = CGRect(x: (width - widthP) / 2, y: (height * 0.6 + 64 - widthP) / 2, width: widthP, height: widthP)
//        touchIDLoginBtn.setBackgroundImage(UIImage(named: "TouchIDImage"), for: .normal)
//        touchIDLoginBtn.showsTouchWhenHighlighted = true
//        touchIDLoginBtn.backgroundColor = UIColor.clear
//        touchIDLoginBtn.tag = touchIDLoginBtnTag
//        touchIDLoginBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
//        touchIDView.addSubview(touchIDLoginBtn)
//        
//        
//        //otherUserLoginBtn
//        otherUserLoginBtn.frame = CGRect(x: (width - widthB) / 2, y: height * 0.6, width: widthB, height: 44)
//        
//        otherUserLoginBtn.setTitle("密码验证", for: .normal)
//        otherUserLoginBtn.setTitleColor(UIColor.white, for: .normal)
//        otherUserLoginBtn.backgroundColor = UIColor.futuBlue()
//        otherUserLoginBtn.showsTouchWhenHighlighted = true
//        otherUserLoginBtn.layer.cornerRadius = cornerRadius
//        otherUserLoginBtn.tag = otherUserLoginBtnTag
//        otherUserLoginBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
//        touchIDView.addSubview(otherUserLoginBtn)
//        
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        isTouchIDLock = true
//        verifyTouchID()
//    }
//    
//    func buttonAction(sender:UIButton!){
//        if sender.tag == otherUserLoginBtnTag {
//            backToLoginPage()
//            
//        } else if sender.tag == touchIDLoginBtnTag {
//            verifyTouchID()
//        }
//    }
//    //获取当前设备的指纹识别开启状态
//    class func touchIDStatus() -> Bool {
//        var authError : NSError?
//        return LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)
//    }
//    
//    
//    //========================
//    //Mark:-更新用户信息
//    //========================
//    class func updateUserInfo(sender: AnyObject){
//        
//        tlPrint(message: "updateUserInfo sender: \(sender)")
//        let userDefaults = UserDefaults.standard
//        //获取本地存储的用户信息,可能为空
//        let oldTouchIDStatus_t = userDefaults.value(forKey: userDefaultsKeys.touchIDStatus.rawValue)
//        let oldUserName_t = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue)
//        let oldPassWord_t = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue)
//        var oldTouchIDStatus : String!
//        var oldUserName: String!
//        var oldPassWord: String!
//        //空值处理
//        if let touch = oldTouchIDStatus_t {
//            oldTouchIDStatus = String(describing: touch)
//        } else {
//            oldTouchIDStatus = ""
//        }
//        if let user = oldUserName_t {
//            oldUserName = user as! String
//        } else {
//            oldUserName = ""
//        }
//        if let pass = oldPassWord_t {
//            oldPassWord = pass as! String
//        } else {
//            oldPassWord = ""
//        }
//        //新旧值对比处理
//        if let userName = sender.value(forKey: "userName") {
//            //获取到的用户名与本地的用户名不匹配，则更新本地用户名
//            if oldUserName != (userName as! String) {
//                userDefaults.setValue(userName, forKey: userDefaultsKeys.userName.rawValue)
//                userDefaults.synchronize()
//            }
//        }
//        
//        if let passWord = sender.value(forKey: "password") {
//            //获取到的密码与本地的用户名不匹配，则更新本地密码
//            if oldPassWord != (passWord as! String) {
//                userDefaults.setValue(passWord, forKey: userDefaultsKeys.passWord.rawValue)
//                userDefaults.synchronize()
//            }
//        }
//        
//        if let touchIDStatus = sender.value(forKey: "touchIDStatus") {
//            //获取到的指纹识别开关状态与本地的不一致，则更新本地数据
//            if oldTouchIDStatus != String(describing: touchIDStatus) {
//                
//                userDefaults.setValue(touchIDStatus, forKey: userDefaultsKeys.touchIDStatus.rawValue)
//                userDefaults.synchronize()
//            }
//        }
//    }
//    
//    
//    //===================================
//    //Mark:-给前端发送当前手机的指纹锁的开关状态
//    //===================================
//    class func sendTouchIDStatus(sender: AnyObject, wkWebView: WKWebView, rootViewController: ViewController) {
//        
//        let value = TouchIDViewController.touchIDStatus()
//        if value {
//            return
//        }
//        //调用JS，告诉前端当前指纹锁不可以使用
//        tlPrint(message: "TouchIDForbiden()")
//        wkWebView.evaluateJavaScript("TouchIDForbiden()", completionHandler: nil)
//        
//        if let type = sender.value(forKey: "type") {
//            if type as! String == "Opening" {
//                //弹窗提示
//                let alert = UIAlertController(title: "富宝娱乐", message: "您还没有启用指纹锁功能，请在设置中启用后再试", preferredStyle: .alert)
//                
//                alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
//                rootViewController.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
//    
//    //========================
//    //Mark:-判断是否需要启用指纹锁
//    //========================
//    class func touchIDStart(rootViewController: ViewController) -> Void {
//        
//        let userDefaults = UserDefaults.standard
//        let touchIDStatus = userDefaults.value(forKey: userDefaultsKeys.touchIDStatus.rawValue)
//        
//        if !TouchIDViewController.touchIDStatus() || touchIDStatus == nil || ((touchIDStatus as! Int) != 1) {
//            tlPrint(message: "touchIDStatus = \(String(describing: touchIDStatus))")
//            userDefaults.setValue(false, forKey: userDefaultsKeys.touchIDStatus.rawValue)
//            userDefaults.synchronize()
//            return
//        }
//        //指纹锁状态为打开状态，跳转到指纹锁界面
//        let touchVC = TouchIDViewController()
//        touchVC.rootViewController = rootViewController
//        rootViewController.present(touchVC, animated: true, completion: nil)
//        
//    }
//    
//    
//    
//    //返回密码登录界面
//    func backToLoginPage()
//    {
//        
//        tlPrint(message: "[backToLoginPage]")
//        isTouchIDLock = false
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    func verifyTouchID()
//    {
//        tlPrint(message: "[verifyTouchID]")
//        let touchIDAuth = LAContext()
//        //touchIDAuth.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Need your Touch ID to authentication", reply: { (success, error) -> Void in
//        touchIDAuth.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "请验证您的指纹", reply: { (success, error) -> Void in
//            if success {
//                isTouchIDLock = false
//                //发送用户信息到前端
//                //self.sendUserInfo()
//                //重新请求带用户名密码的网页
//                let userDefaults = UserDefaults.standard
//                var domainName: String
//                var userName: String
//                var passWord: String
//                var touchIDStatus: Int
//                
//                if let domainName_t = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue) {
//                    domainName = domainName_t as! String
//                } else {
//                    tlPrint(message: "dont get the domainName info")
//                    return
//                }
//                if let userName_t = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue) {
//                    userName = userName_t as! String
//                } else {
//                    tlPrint(message: "dont get the userName info")
//                    return
//                }
//                if let passWord_t = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue) {
//                    passWord = passWord_t as! String
//                } else {
//                    tlPrint(message: "dont get the passWord info")
//                    return
//                }
//                if let touchIDStatus_t = userDefaults.value(forKey: userDefaultsKeys.touchIDStatus.rawValue) {
//                    touchIDStatus = touchIDStatus_t as! Int
//                } else {
//                    tlPrint(message: "dont get the touchIDStatus info")
//                    return
//                }
//                
//                let url = "\(domainName)login?userName=\(userName)&passWord=\(passWord)&touchIDStatus=\(touchIDStatus)"
//                tlPrint(message: "touchID verify URL:\n  \(url)")
//                self.rootViewController?.reloadMainPage(url: url)
//                self.dismiss(animated: true, completion: nil)
//                
//            } else {
//                
////                let int32errcode = error.code
////                tlPrint(message: "int32errorcode: \(int32errcode)")
////                tlPrint(message: "kLAErrorUserFallback: \(kLAErrorUserFallback)")
////                tlPrint(message: "kLAErrorUserCancel: \(kLAErrorUserCancel)")
////                tlPrint(message: "kLAErrorSystemCancel: \(kLAErrorSystemCancel)")
////                
////                
////                switch (int32errcode) {
////                    
////                case kLAErrorUserFallback:
////                    
////                    print(" You taped Enter password!\nkLAErrorUserFallback")
////                    self.backToLoginPage()
////                    break
////                    
////                case kLAErrorUserCancel:
////                    print("You taped cancel!\nkLAErrorUserCancel")
////                    break
////                    
////                case kLAErrorSystemCancel:
////                    print("kLAErrorSystemCancel")
////                    break
////                    
////                default:
////                    print("Sorry,You didn't pass the Touch ID authentication!!")
////                    break
////                }
//                
//                tlPrint(message: "Sorry,You didn't pass the Touch ID authentication!!")
//            }
//        })
//    }
//    
//    //给前端发送当前用户信息
//    func sendUserInfo() -> Void {
//        
//        let userDefaults = UserDefaults.standard
//        
//        let domainName_t = userDefaults.value(forKey: userDefaultsKeys.domainName.rawValue)
//        let userName_t = userDefaults.value(forKey: userDefaultsKeys.userName.rawValue)
//        let passWord_t = userDefaults.value(forKey: userDefaultsKeys.passWord.rawValue)
//        let touchIDStatus_t = userDefaults.value(forKey: userDefaultsKeys.touchIDStatus.rawValue)
//        var domainName : String!
//        var userName: String!
//        var passWord: String!
//        var touchIDStatus: String!
//        if let domain = domainName_t {
//            domainName = domain as! String
//        } else {
//            domainName = ""
//        }
//        
//        if let user = userName_t {
//            userName = user as! String
//        } else {
//            userName = ""
//        }
//        
//        if let pass = passWord_t {
//            passWord = pass as! String
//        } else {
//            passWord = ""
//        }
//        
//        if let touch = touchIDStatus_t {
//            touchIDStatus = String(describing: touch)
//        } else {
//            touchIDStatus = ""
//        }
//        
//        tlPrint(message: "userName: \(userName)  password: \(passWord)  touchIDStatus: \(touchIDStatus)")
//        
//        let url = domainName + "/login?userName=" + userName + "&passWord=" + passWord + "&touchIDStatus=" + touchIDStatus
//        
//        
//        
//        TouchIDViewController.touchIDRequest(urlString: url)
//        
//    }
//    
//    class func touchIDRequest(urlString: String) -> Void {
//        
//        tlPrint(message: "request url: \(urlString)")
//        
//        //字符串的转码
//        let url = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
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
//        _ = DispatchQueue.global().sync {
//            manager.get(url, parameters: nil, progress: { (progress) in
//                
//                }, success: { (task, response) in
//                   tlPrint(message: "请求成功!!!!!")
//                }, failure: { (task, error) in
//                    tlPrint(message: "请求失败\nERROR:\n\(error)")
//            })
//        }
//        //return returnValue
//    }
//    
//    
//    
//  
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    /*
//     // MARK: - Navigation
//     
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//    
//}
//
