////
////  BailoutsViewController.swift
////  FuTu
////
////  Created by Administrator1 on 25/2/17.
////  Copyright © 2017 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//class BailoutsViewController: UIViewController,BtnActDelegate {
//
//    
//    var bailoutsView:BailoutsView!
//    let model = BailoutsModel()
//    var haveRescure:Bool = false
//    var alertMsg:String!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.bailoutsView = BailoutsView(frame: self.view.frame, rootVC: self)
//        
//        
//        
//        self.view.addSubview(self.bailoutsView)
//        // Do any additional setup after loading the view.
//        
//        self.model.getBailoutsStatus { (alertMsg, haveRescure) in
//            tlPrint(message: "alertMsg:\(alertMsg) haveRescure:\(haveRescure)")
//            self.alertMsg = alertMsg
//            self.haveRescure = haveRescure
//        }
//    }
//    
//    
//    func btnAct(btnTag: Int) {
//        tlPrint(message: "btnAct tag:\(btnTag)")
//        switch btnTag {
//        case bailoutsTag.backBtnTag.rawValue:
//            tlPrint(message: "返回上一层")
//            _ = self.navigationController?.popViewController(animated: true)
//        case bailoutsTag.caseTapTag.rawValue:
//            tlPrint(message: "点击了宝箱")
//            self.showAlertAct()
//        case bailoutsTag.getBtnTag.rawValue:
//            tlPrint(message: "点击了获取按钮")
//            self.showAlertAct()
//            
//        case bailoutsTag.alergGetBtnTag.rawValue:
//            tlPrint(message: "点击了弹窗的按钮")
//            
//            self.alertBtnAct()
//        default:
//            tlPrint(message: "no such case")
//        }
//    }
//    
//    func showAlertAct() -> Void {
//        
//        
//        if self.haveRescure {
//            //可以获取救援金
//            self.model.getBailoutsAmount(success: { (alertMsg,amount) in
//                tlPrint(message: "get bailouts amount alert message:\(alertMsg) amount:\(amount)")
//                
//                self.alertMsg = alertMsg
//                self.bailoutsView.initAlertView(alertType: 0, amount: amount, alertMsg: self.alertMsg)
//            })
//
//        } else {
//            self.bailoutsView.initAlertView(alertType: 1, amount: 0, alertMsg: self.alertMsg)
//        }
//        
//    }
//    
//    
//    func alertBtnAct() -> Void {
//        tlPrint(message: "alertBtnAct")
//        if !self.haveRescure {
//            self.bailoutsView.removeAlertView()
//            return
//        }
//        self.haveRescure = false
//        self.model.getBailouts { (alertMsg) in
//            self.alertMsg = alertMsg
//            self.bailoutsView.initAlertView(alertType: 2, amount: 0, alertMsg: self.alertMsg)
//        }
//    }
//    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
