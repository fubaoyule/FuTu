//
//  HomeScrollViewController.swift
//  FuTu
//
//  Created by Administrator1 on 22/11/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit


//@objc protocol HomeSlideVCDelegate{
//    
//    func backHomeImgArray()->NSMutableArray
//    @objc optional func backScrollerViewForWidthAndHeight()->CGSize
//}


class HomeScrollViewController: UIViewController, UIScrollViewDelegate {

    //var delegate : HomeSlideVCDelegate!
    var scrollerView : UIScrollView?
    
    let model = HomeModel()
    let userDefaults = UserDefaults.standard
    //当前展示的图片
    var currentIndex : Int?
    //数据源
    var imgArray : NSArray!
    
    //scrollView的宽和高
    var scrollerViewWidth, scrollerViewHeight : CGFloat?
    var pageControl : UIPageControl?
    var isPageControl : NSNumber!
    //当前游戏列表的总页数 >= 1
    var gameToken: String!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tlPrint(message: "viewDidLoad")
        self.currentIndex = 0
//        let size: CGSize = self.delegate.backScrollerViewForWidthAndHeight!()
        
        self.view.frame = CGRect(origin: model.scrollPoint, size: CGSize(width: deviceScreen.width, height: model.scrollHeight))
        
        //self.imgArray =  NSMutableArray(array: self.delegate.backHomeImgArray())
        self.imgArray = ["http://m.toobet.co/Content/Images/transfer-icon.png","http://m.toobet.co/Content/Images/transfer-icon.png","http://m.toobet.co/Content/Images/transfer-icon.png","http://m.toobet.co/Content/Images/transfer-icon.png"]
        self.scrollerViewWidth = deviceScreen.width
        self.scrollerViewHeight = model.scrollHeight
        
        self.configureScrollerView()
        
//        if(( self.isPageControl.boolValue ) != false){
//            self.configurePageController()
//        }
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ScrollViewController.letItScroll), userInfo: nil, repeats: true)
    }
    
    func letItScroll(){
        self.scrollerView?.setContentOffset( CGPoint(x: 2 * scrollerViewWidth!, y: 0), animated: true)
    }
    
    //==============================
    //Mark:- 配置滚动视图
    //==============================
    func configureScrollerView(){
        tlPrint(message: "configureScrollerView")
        self.scrollerView = UIScrollView(frame: CGRect(x: 0,y: 0,width: self.scrollerViewWidth!,height: model.scrollHeight))
        
        self.scrollerView?.delegate = self
        self.scrollerView?.contentSize = CGSize(width: self.scrollerViewWidth! * CGFloat(imgArray.count), height: scrollerViewHeight!)
        
        self.scrollerView?.contentOffset = CGPoint(x: self.scrollerViewWidth! * CGFloat(imgArray.count), y: 0)
        
        self.scrollerView?.isPagingEnabled = true
        self.scrollerView?.bounces = false
        //self.scrollerView?.backgroundColor = UIColor.randomColor()
        self.view.addSubview(self.scrollerView!)
        
        initImageView()
    }
    
    
    func initImageView() -> Void {
        tlPrint(message: "initImageView")
        if(self.imgArray?.count != 0){
            tlPrint(message: "-------  1  -------")
            for i in 0 ... (self.imgArray!.count - 1) {
                tlPrint(message: "-------  2  -------")
                let imgView = UIImageView(frame: self.scrollerView!.frame)
                tlPrint(message: "-------  3  -------")
                
                //imgView.sd_setImage(with: URL(string: imgArray[i] as! String)!, placeholderImage: UIImage(named: "home-banner1.png"))
                imgView.image = UIImage(named: "home-banner1.png")
                imgView.backgroundColor = UIColor.red
                self.scrollerView!.addSubview(imgView)
                tlPrint(message: "-------  4  -------")
            }
            tlPrint(message: "-------  5  -------")
        }
    }
    

    
    
    //==============================
    //Mark:- 滚动视图滑动处理函数
    //==============================
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // tlPrint(message: "scrollViewDidScroll")
        //let offset = scrollView.contentOffset.x
//        
//        
//        if(self.imgArray?.count != 0){
//            if(offset >= self.scrollerViewWidth! * 2 ){
//                
//            }
//            
//            if (offset <= 0){
//            
//            }
//        }
    }
    //==============================
    //Mark:- 游戏列表显示处理函数
    //==============================
    func slideDeal(leftIndex:Int, midlleIndex: Int, rightIndex:Int) -> Void {
        tlPrint(message: "slideDeal")
        //tlPrint(message: "slideDeal leftIndex: \(leftIndex)    midlleIndex: \(midlleIndex)   rightIndex: \(rightIndex)")
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func configurePageController() {
        tlPrint(message: "configurePageController")
        self.pageControl = UIPageControl(frame: CGRect(x: scrollerViewWidth!/2 - 80,y: self.scrollerViewHeight! - 20,width: 160,height: 20))
        self.pageControl?.numberOfPages = imgArray.count
        self.pageControl?.isUserInteractionEnabled = false
        self.view.addSubview(self.pageControl!)
    }
    
    func backCurrentClickPicture()-> NSInteger{
        tlPrint(message: "backCurrentClickPicture")
        return (self.pageControl?.currentPage)!
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
