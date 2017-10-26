//
//  TranserView.swift
//  FuTu
//
//  Created by Administrator1 on 8/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

@objc protocol Transferdelegate {
    
    func serviceBtnAct()
    func detailBtnAct()
    func gameBtnAct()
}

class TranserView: UIViewController,UIScrollViewDelegate {

    var delegate: Transferdelegate?
    var backgroundView: UIView = UIView()
    var topBackImg: UIImageView!
    
    var scroll: UIScrollView!
    var serviceBtn,detailBtn,changeBtn: UIButton!
    var width,height: CGFloat!
    let model = TransferModel()
    
    let initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let baseVC = BaseViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.width = deviceScreen.width
        self.height = deviceScreen.height
        
        
        //背景视图
        initBackImgView()
        //滑动3D视图
        initScrollView()
        
        
        

    }

    func initBackImgView() -> Void {
        tlPrint(message: "initBackImgView")
        
        //backgroundView = UIView(frame: self.view.frame)
        backgroundView.frame = self.view.frame
        self.view.addSubview(backgroundView)
        //头部背景
        let imgFrame = CGRect(x: 0, y: 0, width: width, height: distanceAdapt(distance: model.topBackHeight))
        topBackImg = UIImageView(frame: imgFrame)
        topBackImg.image = UIImage(named: "transfer_title_bg.png")
        backgroundView.insertSubview(topBackImg, at: 0)
        
        //下部渐变背景
        let gradientLayer = CAGradientLayer.GradientLayer(topColor: model.backgroundTopColor, buttomColor: model.backgroundBottomColor)
        gradientLayer.frame = CGRect(x: 0, y: distanceAdapt(distance: model.topBackHeight), width: width, height: height - distanceAdapt(distance: model.topBackHeight))
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func initScrollView() -> Void {
        tlPrint(message: "initScrollView")
        scroll = UIScrollView(frame: self.view.frame)
        self.view.addSubview(scroll)
        scroll.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.5)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        
        initBalanceLabel()  //余额标签
        initServiceBtn()    //客服按钮
        initDetailBtn()     //交易明细按钮
        
        
        let imgName = ["transfer_view_sports.png","transfer_view_TGP.png","transfer_view_GD.png","transfer_view_AV.png","transfer_view_BBIN-slot.png","transfer_view_BS.png","transfer_view_PT.png","transfer_view_BBIN-reality.png"]
        
        for i in 0 ... 7 {
            let gameView = initGameView(veiw: scroll, i: i, imgName: imgName[i])
            scroll.addSubview(gameView)
        }
    }
    
    func initGameView(veiw:UIView,i:Int,imgName:String) -> UIView{
        tlPrint(message: "initGameView")
        let gameView = UIView(frame: CGRect(x: distanceAdapt(distance: 10), y: distanceAdapt(distance: (model.gameViewTop + model.gameVeiwHeight * CGFloat(i) * 0.65)), width: width - distanceAdapt(distance: 20), height: distanceAdapt(distance: model.gameVeiwHeight)))
        gameView.tag = 30 + i
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: gameView.frame.width, height: gameView.frame.height))
        imgView.image = UIImage(named: imgName)
        gameView.insertSubview(imgView, at: 0)
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 400.0   //透视投影
        transform = CATransform3DRotate(transform, CGFloat(M_PI * 0.08), -1, 0, 0)//旋转
        gameView.layer.transform = transform
        return gameView
    }
    
    func initBalanceLabel() -> Void {
        tlPrint(message: "initBalanceLabel")
        //中心钱包余额文字部分
        let textFrame = CGRect(x: distanceAdapt(distance: 29.5), y: distanceAdapt(distance: 50), width: distanceAdapt(distance: 150), height: distanceAdapt(distance: 15))
        let textLabel = UILabel(frame: textFrame)
        scroll.insertSubview(textLabel, at: 0)
        setLabelProperty(label: textLabel, text: "中心钱包余额（元）", aligenment: .left, textColor: .white, backColor: .clear, font: fontAdapt(font: 14))
        //余额金额标签
        let balanceFrame = CGRect(x: distanceAdapt(distance: 29.5), y: distanceAdapt(distance: 80), width: width - distanceAdapt(distance: 29.5), height: distanceAdapt(distance: 33))
        let balanceLabel = UILabel(frame: balanceFrame)
        balanceLabel.tag = 20
        scroll.insertSubview(balanceLabel, at: 0)
        setLabelProperty(label: balanceLabel, text: "26,607.00", aligenment: .left, textColor: .white, backColor: .clear, font: fontAdapt(font: 40))
    }
    
    func initServiceBtn() -> Void {
        tlPrint(message: "initServiceBtn")
        //service button
        let serviceFrame = CGRect(x:distanceAdapt(distance: width - 50), y:distanceAdapt(distance: 25), width:distanceAdapt(distance: 35), height:distanceAdapt(distance: 35))
        serviceBtn = baseVC.buttonCreat(frame: serviceFrame, title:"",alignment: .center, target: self, myaction: #selector(delegate?.serviceBtnAct) , normalImage: UIImage(named:"home_service.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
        scroll.addSubview(serviceBtn)
    }
    
    func initDetailBtn() -> Void {
        tlPrint(message: "initDetailBtn")
        //service button
        let detailFrame = CGRect(x:distanceAdapt(distance: width - 69 - 20), y:distanceAdapt(distance: 98), width:distanceAdapt(distance: 69), height:distanceAdapt(distance: 20))
        detailBtn = baseVC.buttonCreat(frame: detailFrame, title:"交易明细",alignment: .center, target: self, myaction: #selector(delegate?.detailBtnAct) , normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: 12), events: .touchUpInside)
        detailBtn.setTitleColor(UIColor.white, for: .normal)
        detailBtn.setTitleColor(UIColor.gray, for: .highlighted)
        detailBtn.layer.borderColor = UIColor.white.cgColor
        detailBtn.layer.borderWidth = distanceAdapt(distance: 0.5)
        detailBtn.layer.cornerRadius = distanceAdapt(distance: 10)
        scroll.addSubview(detailBtn)
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        tlPrint(message: "scrollViewDidScroll")
    //        let offSetY:CGFloat = scrollView.contentOffset.y
    //        if offSetY < 0 {
    //            let originH = distanceAdapt(distance: model.topBackHeight)
    //            let originW:CGFloat = width
    //            let newHeight = -offSetY + originH
    //            let newWidth = -offSetY * originW / originH + originW
    //            topBackImg.frame = CGRect(x: offSetY * originW / originH / 2, y: offSetY, width: newWidth, height: newHeight)
    //        }
    //    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tlPrint(message: "scrollViewDidScroll")
    }
    
    
    
    func setLabelProperty(label:UILabel,text:String,aligenment:NSTextAlignment,textColor:UIColor,backColor:UIColor,font:CGFloat) -> Void {
        tlPrint(message: "setLabelProperty")
        label.text = text
        label.textAlignment = aligenment
        label.textColor = textColor
        label.backgroundColor = backColor
        label.font = UIFont.systemFont(ofSize: font)
    }

}
