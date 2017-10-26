////
////  CommissionView.swift
////  FuTu
////
////  Created by Administrator1 on 12/12/16.
////  Copyright © 2016 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//class CommissionView: UIView {
//    
//    
//    var scroll: UIScrollView!
//    var progressView,ballImg,lightImg,topBackImg,titleBackImg: UIImageView!
//    var width,height: CGFloat!
//    var serviceBtn,detailBtn: UIButton!
//    var percentLabel,commissionLabel,titleText:UILabel!
//    var ballView: UIView!
//    var progressLayer: CAShapeLayer!
//    
//    let model = CommissionModel()
//    
//    let baseVC = BaseViewController()
//    init(frame:CGRect, param:AnyObject) {
//        super.init(frame: frame)
//        self.width = frame.width
//        self.height = frame.height
//
//        
//        initScrollView()
//    }
//    
//    
//    
//    var progress: CGFloat = 0.0
//    //滑动视图
//    func initScrollView() -> Void {
//        
//        scroll = UIScrollView(frame: frame)
//        self.addSubview(scroll)
//        scroll.contentSize = CGSize(width: frame.width, height: height + 1)
//        scroll.showsVerticalScrollIndicator = false
//        scroll.showsHorizontalScrollIndicator = false
//        scroll.isUserInteractionEnabled = true
//        
//        //顶部视图
//        let titleFrame = CGRect(x: 0, y: 0, width: width, height: adapt_H(height: model.titleViewHeight))
//        let titleView = UIView(frame: titleFrame)
//        scroll.addSubview(titleView)
//        //顶部背景图
//        titleBackImg = UIImageView(frame: titleFrame)
//        titleView.addSubview(titleBackImg)
//        titleBackImg.image = UIImage(named: "commission_title_bg.png")
//        
//        //昨日佣金
//        titleText = UILabel(frame: CGRect(x: 0, y: adapt_H(height: 37), width: width, height: adapt_H(height: 20)))
//        titleView.addSubview(titleText)
//        setLabelProperty(label: titleText, text: "昨日佣金(元)", aligenment: .center, textColor: UIColor.colorWithCustom(r: 199, g: 237, b: 255), backColor: .clear, font: fontAdapt(font: 14))
// 
//        //球形视图
//        ballView = UIView(frame: model.ballFrame)
//        titleView.addSubview(ballView)
//        //球形图片
//        self.ballImg = UIImageView(frame: CGRect(x: 0, y: 0, width: ballView.frame.width, height: ballView.frame.width))
//        ballView.addSubview(ballImg)
//        ballImg.image = UIImage(named: "commission_ball.png")
//        //进度条
//        progressView = initProgressView()
//        ballView.addSubview(progressView)
//        
//        //光点视图
//        lightImg = UIImageView(frame: ballImg.frame)
//        ballView.addSubview(lightImg)
//        lightImg.image = UIImage(named: "commission_ball_light.png")
//        lightImg.center = ballImg.center
//        
//        
//        //金额
//        let commissionValue = "\(model.dataSource[0])" as NSString
//        _ = commissionValue.size(attributes: [NSFontAttributeName :  UIFont.systemFont(ofSize: fontAdapt(font: model.commissionFont))])
//        let commissionFrame = CGRect(x: 0, y: ballView.frame.width * 0.3, width: ballView.frame.width, height: ballView.frame.height * 0.15)
//        
//        self.commissionLabel = UILabel(frame: commissionFrame)
//        
//        setLabelProperty(label: commissionLabel, text: commissionValue as String, aligenment: .center, textColor: .white, backColor: .clear, font: fontAdapt(font: model.commissionValueFont))
//        commissionLabel.layer.shadowColor = UIColor.colorWithCustom(r: 0, g: 59, b: 209).cgColor
//        commissionLabel.layer.shadowOffset = CGSize(width: 1.2, height: 2.4)
//        commissionLabel.layer.shadowOpacity = 1
//        ballView.addSubview(commissionLabel)
//        //百分比
//        self.percentLabel = UILabel(frame: CGRect(x: 0, y: ballView.frame.width * 0.5, width: ballView.frame.width, height: adapt_H(height: 60)))
//        ballView.addSubview(percentLabel)
//        let textString = "您已超越\n全国\(model.dataSource[1])％的小伙伴"
//        setLabelProperty(label: percentLabel, text: textString, aligenment: .center, textColor: UIColor.colorWithCustom(r: 158, g: 224, b: 255), backColor: .clear, font: fontAdapt(font: model.percentFont))
//        setLabelWithDiff(label: percentLabel, text: textString, font: fontAdapt(font: model.percentFont + 2), color: .colorWithCustom(r: 197, g: 255, b: 145), range: NSRange(location: 7, length: "\(model.dataSource[1])".characters.count + 1))
//        percentLabel.numberOfLines = 0
//        
//        
//        
//        //佣金奖励
//        let awardImg = UIImageView(frame: CGRect(x: adapt_W(width: 15), y: adapt_H(height: 325), width: adapt_W(width: 16), height: adapt_H(height: 21)))
//        scroll.addSubview(awardImg)
//        awardImg.image = UIImage(named: "commission_purse.png")
//        let awardText = UILabel(frame: CGRect(x: adapt_W(width: 40), y: adapt_H(height: 325), width: adapt_W(width: 120), height: adapt_H(height: 20)))
//        scroll.addSubview(awardText)
//        setLabelProperty(label: awardText, text: "佣金奖励", aligenment: .left, textColor: UIColor.colorWithCustom(r: 37, g: 37, b: 37), backColor: .clear, font: fontAdapt(font: 14))
//        let grayLine1 = UIView(frame: CGRect(x: 0, y: adapt_H(height: 357), width: width, height: adapt_H(height: model.grayLineWidth)))
//        grayLine1.backgroundColor = model.grayLineColor
//        scroll.addSubview(grayLine1)
//        //累计佣金
//        let totleText = UILabel(frame: CGRect(x: 0, y: adapt_H(height: 370), width: width / 2, height: adapt_H(height: 18)))
//        scroll.addSubview(totleText)
//        setLabelProperty(label: totleText, text: "累计佣金(元)", aligenment: .center, textColor: UIColor.colorWithCustom(r: 161, g: 161, b: 161), backColor: .clear, font: fontAdapt(font: 12))
//        let totleAmount = UILabel(frame: CGRect(x: 0, y: adapt_H(height: 395), width: width / 2, height: adapt_H(height: 20)))
//        scroll.addSubview(totleAmount)
//        setLabelProperty(label: totleAmount, text: "\(model.dataSource[2])", aligenment: .center, textColor: UIColor.colorWithCustom(r: 35, g: 35, b: 35), backColor: .clear, font: fontAdapt(font: 23))
//        let grayLine2 = UIView(frame: CGRect(x: width / 2, y: adapt_H(height: 383), width: adapt_W(width: model.grayLineWidth), height: adapt_H(height: 30)))
//        grayLine2.backgroundColor = model.grayLineColor
//        scroll.addSubview(grayLine2)
//        //可取佣金
//        let useText = UILabel(frame: CGRect(x: width / 2, y: adapt_H(height: 370), width: width / 2, height: adapt_H(height: 18)))
//        scroll.addSubview(useText)
//        setLabelProperty(label: useText, text: "可取现佣金(元)", aligenment: .center, textColor: UIColor.colorWithCustom(r: 161, g: 161, b: 161), backColor: .clear, font: fontAdapt(font: 12))
//        let useAmount = UILabel(frame: CGRect(x: width / 2, y: adapt_H(height: 395), width: width / 2, height: adapt_H(height: 20)))
//        scroll.addSubview(useAmount)
//        setLabelProperty(label: useAmount, text: "\(model.dataSource[3])", aligenment: .center, textColor: UIColor.colorWithCustom(r: 35, g: 35, b: 35), backColor: .clear, font: fontAdapt(font: 23))
//        let grayLine3 = UIView(frame: CGRect(x: 0, y: adapt_H(height: 434), width: width, height: adapt_H(height: model.grayLineWidth)))
//        grayLine3.backgroundColor = model.grayLineColor
//        scroll.addSubview(grayLine3)
//        
//        
//        
//        //成功推荐
//        let recommandImg = UIImageView(frame: CGRect(x: adapt_W(width: 15), y: adapt_H(height: 449), width: adapt_W(width: 20), height:  adapt_H(height: 17)))
//        scroll.addSubview(recommandImg)
//        recommandImg.image = UIImage(named: "commission_recommend.png")
//        let recomendText = UILabel(frame: CGRect(x: adapt_W(width: 40), y: adapt_H(height: 449), width: adapt_W(width: 120), height: adapt_H(height: 20)))
//        scroll.addSubview(recomendText)
//        setLabelProperty(label: recomendText, text: "成功推荐", aligenment: .left, textColor: UIColor.colorWithCustom(r: 37, g: 37, b: 37), backColor: .clear, font: fontAdapt(font: 14))
//        let grayLine4 = UIView(frame: CGRect(x: 0, y: adapt_H(height: 478), width: width, height: adapt_H(height: model.grayLineWidth)))
//        grayLine4.backgroundColor = model.grayLineColor
//        scroll.addSubview(grayLine4)
//        //推荐注册
//        let registerText = UILabel(frame: CGRect(x: 0, y: adapt_H(height: 492), width: width / 2, height: adapt_H(height: 18)))
//        scroll.addSubview(registerText)
//        setLabelProperty(label: registerText, text: "推荐注册(人)", aligenment: .center, textColor: UIColor.colorWithCustom(r: 161, g: 161, b: 161), backColor: .clear, font: fontAdapt(font: 12))
//        let registerNum = UILabel(frame: CGRect(x: 0, y: adapt_H(height: 517), width: width / 2, height: adapt_H(height: 20)))
//        scroll.addSubview(registerNum)
//        setLabelProperty(label: registerNum, text: "\(Int(model.dataSource[4]))", aligenment: .center, textColor: UIColor.colorWithCustom(r: 35, g: 35, b: 35), backColor: .clear, font: fontAdapt(font: 23))
//        let grayLine5 = UIView(frame: CGRect(x: width / 2, y: adapt_H(height: 505), width: adapt_W(width: model.grayLineWidth), height: adapt_H(height: 30)))
//        grayLine5.backgroundColor = model.grayLineColor
//        scroll.addSubview(grayLine5)
//        //推荐充值
//        let saveText = UILabel(frame: CGRect(x: width / 2, y: adapt_H(height: 492), width: width / 2, height: adapt_H(height: 18)))
//        scroll.addSubview(saveText)
//        setLabelProperty(label: saveText, text: "推荐充值(人)", aligenment: .center, textColor: UIColor.colorWithCustom(r: 161, g: 161, b: 161), backColor: .clear, font: fontAdapt(font: 12))
//        let saveNum = UILabel(frame: CGRect(x: width / 2, y: adapt_H(height: 517), width: width / 2, height: adapt_H(height: 20)))
//        scroll.addSubview(saveNum)
//        setLabelProperty(label: saveNum, text: "\(Int(model.dataSource[5]))", aligenment: .center, textColor: UIColor.colorWithCustom(r: 35, g: 35, b: 35), backColor: .clear, font: fontAdapt(font: 23))
//        let grayLine6 = UIView(frame: CGRect(x: 0, y: adapt_H(height: 555), width: width, height: adapt_H(height: model.grayLineWidth)))
//        grayLine6.backgroundColor = model.grayLineColor
//        scroll.addSubview(grayLine6)
//        
//        //按钮
//        let btnY = adapt_H(height: 555) + (height - adapt_H(height: 555) - tabBarHeight - adapt_H(height: 37)) / 2
//        let withdrawFrame = CGRect(x: adapt_W(width: 25), y: btnY, width: adapt_W(width: 155), height: adapt_H(height:37))
//        let withdrawBtn = baseVC.buttonCreat(frame: withdrawFrame, title: "提  款", alignment: .center, target: self, myaction: #selector(self.btnAction(sender:)), normalImage: nil, hightImage: nil, backgroundColor: UIColor.colorWithCustom(r: 27, g: 123, b: 233), fonsize: fontAdapt(font: 15), events: .touchUpInside)
//        withdrawBtn.tag = 42
//        withdrawBtn.setTitleColor(UIColor.white, for: .normal)
//        withdrawBtn.layer.cornerRadius = withdrawFrame.height / 2
//        scroll.addSubview(withdrawBtn)
//        
//        let earnFrame = CGRect(x: adapt_W(width: 195), y: btnY, width: adapt_W(width: 155), height: adapt_H(height: 37))
//        let earnBtn = baseVC.buttonCreat(frame: earnFrame, title: "赚 佣 金", alignment: .center, target: self, myaction: #selector(self.btnAction(sender:)), normalImage: nil, hightImage: nil, backgroundColor: UIColor.colorWithCustom(r: 255, g: 162, b: 0), fonsize: fontAdapt(font: 15), events: .touchUpInside)
//        earnBtn.tag = 43
//        earnBtn.setTitleColor(UIColor.white, for: .normal)
//        earnBtn.layer.cornerRadius = earnFrame.height / 2
//        scroll.addSubview(earnBtn)
//        
//        //initServiceBtn()    //客服按钮
//        initDetailBtn()     //详情按钮
//    }
//    
//    
//    func initProgressView() -> UIImageView {
//        
//        progressLayer = CAShapeLayer()
//        //progress = 0
//        let imgFrame = CGRect(x: adapt_W(width:9) , y: adapt_W(width:9), width: model.ballFrame.width - adapt_W(width:22), height: model.ballFrame.width - adapt_W(width:22))
//        
//        let progressFrame2 = CGRect(x: adapt_W(width:6), y: adapt_W(width:6), width: model.ballFrame.width - adapt_W(width:50), height: model.ballFrame.width - adapt_W(width:50))
//        
//        let path = UIBezierPath(ovalIn: progressFrame2).cgPath
//        progressLayer.frame = progressFrame2
//        progressLayer.fillColor = UIColor.clear.cgColor
//        progressLayer.strokeColor = UIColor.green.cgColor
//        progressLayer.lineWidth = adapt_W(width: 3)
//        progressLayer.path = path
//        progressLayer.strokeStart = 0
//        progressLayer.strokeEnd = progress
//        progressLayer.lineCap = kCALineCapRound
//        
//        //翻转
//        var transform = CATransform3DIdentity
//        transform = CATransform3DRotate(transform, CGFloat(Double.pi / 2), 0, 0, 1)//z轴旋转
//        transform = CATransform3DRotate(transform, CGFloat(Double.pi), 0, 1, 0)//压轴旋转
//
//        //彩色背景
//        let backImg = UIImageView(frame: imgFrame)
//        backImg.image = UIImage(named: "commission_ball_colorBoard.png")
//        backImg.layer.mask = progressLayer
//        backImg.layer.transform = transform
//        return backImg
//    }
//    
//    
//    //初始化客服按钮
////    private func initServiceBtn() -> Void {
////        //service button
////        let serviceFrame = CGRect(x:width - adapt_W(width: 50), y:adapt_H(height: 25), width:adapt_W(width: 35), height:adapt_H(height: 35))
////        serviceBtn = baseVC.buttonCreat(frame: serviceFrame, title:"",alignment: .center, target: self, myaction: #selector(self.btnAction(sender:)), normalImage: UIImage(named:"home_service.png"), hightImage: nil, backgroundColor: .clear, fonsize: 12, events: .touchUpInside)
////        serviceBtn.tag = 40
////        scroll.addSubview(serviceBtn)
////    }
//    //初始化交易明细按钮
//    private func initDetailBtn() -> Void {
//        //service button
//        let detailFrame = CGRect(x:width - adapt_W(width: 72 + 13), y:adapt_H(height: 250), width:adapt_W(width: 72), height:adapt_H(height: 26))
//        detailBtn = baseVC.buttonCreat(frame: detailFrame, title:"收益明细",alignment: .center, target: self, myaction: #selector(self.btnAction(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: 12), events: .touchUpInside)
//        
//        detailBtn.tag = 41
//        detailBtn.setTitleColor(UIColor.white, for: .normal)
//        detailBtn.setTitleColor(UIColor.gray, for: .highlighted)
//        detailBtn.layer.borderColor = UIColor.white.cgColor
//        detailBtn.layer.borderWidth = adapt_W(width: 0.5)
//        detailBtn.layer.cornerRadius = adapt_H(height: 13)
//        scroll.addSubview(detailBtn)
//    }
//
//    
//    //按钮事件
//    func btnAction(sender:UIButton) -> Void {
//        tlPrint(message: "btnAction tag = \(sender.tag)")
//    }
//    
//    func setLabelWithDiff(label:UILabel, text:String, font:CGFloat, color:UIColor, range:NSRange) -> Void {
//        label.text = text
//        let attStr = NSMutableAttributedString(string: text)
//        attStr.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
//        attStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: font), range: range)
//        label.attributedText = attStr
//    }
//    
//    
//    
////    //设置Label的各个属性（文字，颜色，大小）
////    func setLabelProperty(label:UILabel,text:String,aligenment:NSTextAlignment,textColor:UIColor,backColor:UIColor,font:CGFloat) -> Void {
////        label.text = text
////        label.textAlignment = aligenment
////        label.textColor = textColor
////        label.backgroundColor = backColor
////        label.font = UIFont.systemFont(ofSize: font)
////        
////        
////    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
