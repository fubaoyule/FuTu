//
//  CustomSearchBar.swift
//  FuTu
//
//  Created by Administrator1 on 26/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    var preferredFont: UIFont!
    
    var preferredTextColor: UIColor!
    
    var customSearchControllerdelegate: CustomSearchControllerDelegate!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRect(x: adapt_W(width: 40), y: 5.0, width: frame.size.width - adapt_W(width: 120), height: frame.size.height - 10.0)
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
        }
        
//        let startPoint = CGPoint(x: 0.0, y: frame.size.height)
//        let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
//        let path = UIBezierPath()
//        path.move(to: startPoint)
//        path.addLine(to: endPoint)
//        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path.cgPath
//        shapeLayer.strokeColor = preferredTextColor.cgColor
//        shapeLayer.lineWidth = adapt_H(height: 1)
//        
//        layer.addSublayer(shapeLayer)
//        
//        super.draw(rect)
    }
    
    
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        searchBarStyle = UISearchBarStyle.default
        //searchBarStyle = UISearchBarStyle.minimal
        self.isTranslucent = false
        
        
        initCustomBtn()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func indexOfSearchFieldInSubviews() -> Int! {
        // Uncomment the next line to see the search bar subviews.
        // println(subviews[0].subviews)
        
        var index: Int!
        let searchBarView = subviews[0]
        
        //for i in 0 ..< searchBarView.subviews.count += 1 {
        for i in 0 ..< searchBarView.subviews.count + 1 {
            if searchBarView.subviews[i].isKind(of: UITextField.self) {
                index = i
                break
            }
        }
        return index
    }
    func initCustomBtn() -> Void {
        tlPrint(message: "initCustomBtn")
        let baseVC = BaseViewController()
        let backFrame = CGRect(x: 0, y: 0, width: adapt_W(width: 40), height: 50)
        let backBtn = baseVC.buttonCreat(frame: backFrame, title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: UIImage(named:""), hightImage: nil, backgroundColor: .green, fonsize: 0, events: .touchUpInside)
        self.addSubview(backBtn)
        backBtn.tag = serviceTag.SearchBackBtn.rawValue
        
        let quesFrame = CGRect(x: 320 - adapt_W(width: 80), y: 0, width: adapt_W(width: 80), height: 50)
        let allQuesBtn = baseVC.buttonCreat(frame: quesFrame, title: "常见问题", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: fontAdapt(font: 14), events: .touchUpInside)
        allQuesBtn.setTitleColor(UIColor.colorWithCustom(r: 0, g: 101, b: 215), for: .normal)
        self.addSubview(allQuesBtn)
        allQuesBtn.tag = serviceTag.SearchQuesBtn.rawValue
    }
    
    func btnAct(sender:UIButton) -> Void {
        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
        if sender.tag == serviceTag.SearchBackBtn.rawValue {
            customSearchControllerdelegate.didClickBackButton()
        } else if sender.tag == serviceTag.SearchQuesBtn.rawValue {
            customSearchControllerdelegate.didClickQuesButton()
        }
    }
    
}
