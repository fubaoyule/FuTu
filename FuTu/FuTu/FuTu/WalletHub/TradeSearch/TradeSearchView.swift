//
//  TradeSearchView.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class TradeSearchView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    var scroll: UIScrollView!
    var delegate:BtnActDelegate!
    var textFieldDelegate: UITextFieldDelegate!
    var width,height: CGFloat!
    let model = TradeSearchModel()
    var tableDelegate: UITableViewDelegate!
    var tableDataSource: UITableViewDataSource!
    var searchType: tradeSearchType!
    var infoTable: UITableView!
    
    var currentTabBtn:UIButton!
    var currentTabLine:UIView!
    
    let baseVC = BaseViewController()
    init(frame:CGRect, searchType:tradeSearchType,rootVC:UIViewController) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.backgroundColor = UIColor.colorWithCustom(r: 226, g: 227, b: 231)
        self.searchType = searchType
        
        self.delegate = rootVC as! BtnActDelegate
        self.textFieldDelegate = rootVC as! UITextFieldDelegate
        self.tableDelegate = rootVC as! UITableViewDelegate
        self.tableDataSource = rootVC as! UITableViewDataSource
        
        initNavigationBar()
        initTabBtn()
        initDateView()
        initInfoTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initNavigationBar() -> Void {
        //view
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20 + navBarHeight))
        self.addSubview(navigationView)
        navigationView.backgroundColor = UIColor.colorWithCustom(r: 26, g: 123, b: 233)
        //label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: width, height: navBarHeight))
        setLabelProperty(label: titleLabel, text: "交易查询", aligenment: .center, textColor: .white, backColor: .clear, font: 17)
        navigationView.addSubview(titleLabel)
        
        
        //back button
        let backBtn = baseVC.buttonCreat(frame: CGRect(x: 0, y: 20, width: navBarHeight, height: navBarHeight), title: "", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .clear, fonsize: 0, events: .touchUpInside)
        navigationView.addSubview(backBtn)
        backBtn.tag = tradeSearchTag.TradeSearchBackBtnTag.rawValue
        //back button image
//        let backBtnImg = UIImageView(frame: CGRect(x: 10, y: 12, width: 12, height: 20))
        let backBtnImg = UIImageView(frame: CGRect(x: adapt_W(width: isPhone ? 10 : 12), y: adapt_H(height: isPhone ? 12 : 2), width: adapt_W(width: isPhone ? 12 : 7), height: adapt_H(height: isPhone ? 20 : 12)))
        backBtn.addSubview(backBtnImg)
        backBtnImg.image = UIImage(named: "person_navitation_back.png")
        
    }
    
    
    func initTabBtn() -> Void {
        
        for i in 0 ..< model.tabName.count {
            //button
            let tabFrame = CGRect(x: CGFloat(i) * width / CGFloat(model.tabName.count), y: 20 + navBarHeight, width: width / CGFloat(model.tabName.count), height: 44)
            let tabBtn = baseVC.buttonCreat(frame: tabFrame, title: model.tabName[i], alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .white, fonsize: 16, events: .touchUpInside)
            self.addSubview(tabBtn)
            tabBtn.tag = tradeSearchTag.TradeSearchTabBtnTag.rawValue + i
            tabBtn.setTitleColor(model.tabBtnColorNormal, for: .normal)
            //line
            let lineFrame = CGRect(x: tabFrame.width * (isPhone ? 0.25 : 0.35), y: tabFrame.height - adapt_W(width: isPhone ? 3 : 2), width: tabFrame.width * (isPhone ? 0.5 : 0.3), height: adapt_H(height: isPhone ? 3 : 2))
            let line = baseVC.viewCreat(frame: lineFrame, backgroundColor: .white)
            tabBtn.addSubview(line)
            line.tag = tradeSearchTag.TradeSearchTabLineTag.rawValue + i
            line.layer.cornerRadius = lineFrame.height / 2
            
            if (self.searchType == tradeSearchType.Recharge && i == 0) || (self.searchType == tradeSearchType.Withdraw && i == 1) || (self.searchType == tradeSearchType.Transfer && i == 2) || (self.searchType == tradeSearchType.Bonus && i == 3) {
                tabBtn.setTitleColor(model.tabBtnColorHigh, for: .normal)
                line.backgroundColor = model.tabBtnColorHigh
                currentTabBtn = tabBtn
                currentTabLine = line
            }
        }
    }
    
    func initDateView() -> Void {
        
        let dateBackFrame = CGRect(x: 0, y: 64 + navBarHeight, width: width, height: adapt_H(height: isPhone ? 60 : 40))
        let dateBackView = baseVC.viewCreat(frame: dateBackFrame, backgroundColor: .colorWithCustom(r: 244, g: 244, b: 244))
        self.addSubview(dateBackView)
        let currentDate:String = NSDate.getDate(type: .all)
        //first date selector
        let dateFrame1 = CGRect(x: adapt_W(width: isPhone ? 7 : 27), y: adapt_H(height: isPhone ? 10 : 7.5), width: adapt_W(width: isPhone ? 120 : 100), height: adapt_H(height: isPhone ? 40 : 25))
        let dateSelector1 = baseVC.textFieldCreat(frame: dateFrame1, placeholderText: currentDate, aligment: .left, fonsize: fontAdapt(font: isPhone ? 13 : 9), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 169, g: 169, b: 169), tag: tradeSearchTag.DateSelector1.rawValue)
        dateSelector1.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
        dateBackView.addSubview(dateSelector1)
        dateSelector1.layer.cornerRadius = adapt_W(width: 5)
        dateSelector1.delegate = textFieldDelegate
        dateSelector1.backgroundColor = UIColor.white
        
        let leftView = baseVC.viewCreat(frame: CGRect(x: 0, y: 0, width: adapt_W(width: 30), height: adapt_H(height: 40)), backgroundColor: .clear)
        let leftImg = UIImageView(frame: CGRect(x: adapt_W(width: 5), y: adapt_H(height: 10), width: adapt_W(width: 20), height: adapt_H(height: 20)))
        leftImg.image = UIImage(named: "wallet_recorde_date.png")
        leftView.addSubview(leftImg)
        dateSelector1.leftView = leftView
        dateSelector1.leftViewMode = .always
        
        //secend date selector
        let dateFrame2 = CGRect(x: adapt_W(width: isPhone ? 150 : 150), y: dateFrame1.origin.y, width: dateFrame1.width, height: dateFrame1.height)
        let dateSelector2 = baseVC.textFieldCreat(frame: dateFrame2, placeholderText: currentDate, aligment: .left, fonsize: fontAdapt(font: isPhone ? 13 : 9), borderWidth: adapt_W(width: 0.5), borderColor: .colorWithCustom(r: 169, g: 169, b: 169), tag: tradeSearchTag.DateSelector2.rawValue)
        dateSelector2.textColor = UIColor.colorWithCustom(r: 35, g: 35, b: 35)
        dateSelector2.layer.cornerRadius = adapt_W(width: 5)
        dateBackView.addSubview(dateSelector2)
        dateSelector2.delegate = textFieldDelegate
        dateSelector2.backgroundColor = UIColor.white
        
        let leftView2 = baseVC.viewCreat(frame: CGRect(x: 0, y: 0, width: adapt_W(width: 30), height: adapt_H(height: 40)), backgroundColor: .clear)
        let leftImg2 = UIImageView(frame: CGRect(x: adapt_W(width: 5), y: adapt_H(height: 10), width: adapt_W(width: 20), height: adapt_H(height: 20)))
        leftImg2.image = UIImage(named: "wallet_recorde_date.png")
        leftView2.addSubview(leftImg2)
        dateSelector2.leftView = leftView2
        dateSelector2.leftViewMode = .always
        dateSelector2.delegate = textFieldDelegate
       
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAct(sender:)))
        dateSelector1.addGestureRecognizer(tapGest)
        dateSelector2.addGestureRecognizer(tapGest)
        
        
        let label = baseVC.labelCreat(frame: CGRect(x: adapt_W(width: isPhone ? 130 : 130), y: adapt_H(height: isPhone ? 24 : 15), width: adapt_W(width: 15), height: adapt_H(height: isPhone ? 15 : 10)), text: "至", aligment: .center, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backgroundcolor: .clear, fonsize: fontAdapt(font: isPhone ? 17 : 11))
        dateBackView.addSubview(label)
        
        //search button
        let searchFrame = CGRect(x: width - adapt_W(width: isPhone ? 90 : 60), y: adapt_H(height: isPhone ? 15 : 10), width: adapt_W(width: isPhone ? 80 : 50), height: adapt_H(height: isPhone ? 30 : 20))
        let searchBtn = baseVC.buttonCreat(frame: searchFrame, title: "查询", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 27, g: 123, b: 233), fonsize: fontAdapt(font: isPhone ? 17 : 11), events: .touchUpInside)
        dateBackView.addSubview(searchBtn)
        searchBtn.tag = tradeSearchTag.DateSearchBtnTag.rawValue
        searchBtn.layer.cornerRadius = searchFrame.height / 2
        
    }
    
    func initInfoTable() -> Void {
        let tableY = 64 + navBarHeight + adapt_H(height: isPhone ? 60 : 40)
        infoTable = UITableView(frame: CGRect(x: 0, y: tableY, width:  width, height: height - tableY))
        self.addSubview(infoTable)
        infoTable.delegate = self.tableDelegate
        infoTable.dataSource = self.tableDataSource
    }
    
    var pickerView:UIView!
    var picker:UIPickerView!
    var currentTextField:UITextField!
    func initUIPickerView(textField:UITextField) {
        //先修改textField的日期为今日日期
        let currentDate:String = NSDate.getDate(type: .all)
        textField.text = currentDate
        currentTextField = textField
        
        tlPrint(message: "initUIPickerView")

        let pickerHeight = adapt_H(height: isPhone ? 267 : 90)
        if pickerView != nil {
            pickerView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: { 
                self.pickerView.frame = CGRect(x: 0, y: self.height - pickerHeight, width: self.width, height: pickerHeight)
            })
            return
        }
        
        pickerView = UIView(frame: CGRect(x: 0, y: height, width: width, height: pickerHeight))
        self.addSubview(pickerView)
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.width, height: pickerHeight - adapt_H(height: isPhone ? 50 : 30)))
        //picker = UIPickerView(frame: CGRect(x: 0, y: adapt_H(height: 400), width: width, height: height - adapt_H(height: 400)))
        picker.backgroundColor = UIColor(white: 1, alpha: 1)
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(5, inComponent: 0, animated: true)
        picker.selectRow(7, inComponent: 1, animated: true)
        picker.selectRow(7, inComponent: 2, animated: true)
        pickerView.addSubview(picker)
        
        //confirm button
        let confirmFrame = CGRect(x: 0, y: picker.frame.height, width: width, height: adapt_H(height: isPhone ? 50 : 30))
        
        let confirmBtn = baseVC.buttonCreat(frame: confirmFrame, title: "确     定", alignment: .center, target: self, myaction: #selector(self.btnAct(sender:)), normalImage: nil, hightImage: nil, backgroundColor: .colorWithCustom(r: 0, g: 101, b: 215), fonsize: fontAdapt(font: isPhone ? 17 : 11), events: .touchUpInside)
        confirmBtn.tag = tradeSearchTag.DateSelectConfirmBtnTag.rawValue
        pickerView.addSubview(confirmBtn)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerView.frame = CGRect(x: 0, y: self.height - pickerHeight, width: self.width, height: pickerHeight)
        })
    }
    

    
    let dateArray:[[String]] = [["2010","2012","2013","1014","2015","2016","2017","2018"],
                                ["01","02","03","04","05","06","07","08","09","10","11","12"],
                                ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]]
    let pickerUnit = ["年","月","日"]
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateArray[component].count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dateArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(dateArray[component][row])\(pickerUnit[component])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        tlPrint(message: "\(dateArray[component][row])")
        
        let oldDate = currentTextField.text
        var singleDate:[String] = oldDate!.components(separatedBy: "/")

        singleDate[component] = String(dateArray[component][row])
        let newDate = singleDate[0] + "/" + singleDate[1] + "/" + singleDate[2]
        currentTextField.text = newDate
    }
    
    func tabBtnChanged(btnTag:Int) -> Void {
        tlPrint(message: "tabBtnChanged btnTag = \(btnTag)")
        if btnTag == currentTabBtn.tag {
            return
        }
        currentTabBtn.setTitleColor(model.tabBtnColorNormal, for: .normal)
        currentTabLine.backgroundColor = UIColor.white
        let button = self.viewWithTag(btnTag) as! UIButton
        let line = self.viewWithTag(btnTag - tradeSearchTag.TradeSearchTabBtnTag.rawValue + tradeSearchTag.TradeSearchTabLineTag.rawValue)! as UIView
        
        button.setTitleColor(model.tabBtnColorHigh, for: .normal)
        line.backgroundColor = model.tabBtnColorHigh
        currentTabBtn = button
        currentTabLine = line
        
    }
    
    func reloadInfoTable() -> Void {
        infoTable.reloadData()
    }

    
    func btnAct(sender:UIButton) -> Void {

        tlPrint(message: "btnAct sender.tag = \(sender.tag)")
        
        if sender.tag >= tradeSearchTag.TradeSearchTabBtnTag.rawValue && sender.tag < tradeSearchTag.TradeSearchTabLineTag.rawValue {
            tabBtnChanged(btnTag:sender.tag)
        }
        if sender.tag == tradeSearchTag.DateSelectConfirmBtnTag.rawValue {
            hiddenPikerView()
            return
        }
        if sender.tag == tradeSearchTag.DateSearchBtnTag.rawValue {
            self.hiddenPikerView()
            let dateView1 = self.viewWithTag(tradeSearchTag.DateSelector1.rawValue) as! UITextField
            let dateView2 = self.viewWithTag(tradeSearchTag.DateSelector2.rawValue) as! UITextField
            let date1 = dateView1.text
            let date2 = dateView2.text
            let dateArray1 = date1?.components(separatedBy: "/")
            let dateArray2 = date2?.components(separatedBy: "/")
            if date1 == nil || date1 == "" || date2 == nil || date2 == "" {
                tlPrint(message: "请输入有效的日期")
                let alert = UIAlertView(title: "查询失败", message: "请输入有效的日期", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            }
            if dateArray1![0] > dateArray2![0] {
                tlPrint(message: "请输入有效的年份")
                let alert = UIAlertView(title: "查询失败", message: "请输入有效的日期", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            } else if dateArray1![0] == dateArray2![0] && dateArray1![1] > dateArray2![1] {
                tlPrint(message: "请输入有效的月份")
                let alert = UIAlertView(title: "查询失败", message: "请输入有效的日期", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            }  else if dateArray1![1] == dateArray2![1] && dateArray1![2] > dateArray2![2] {
                tlPrint(message: "请输入有效的日期")
                let alert = UIAlertView(title: "查询失败", message: "请输入有效的日期", delegate: nil, cancelButtonTitle: "确 定")
                DispatchQueue.main.async {
                    alert.show()
                }
                return
            }
        }
        
        delegate.btnAct(btnTag: sender.tag)
        
    }
    
    
    func hiddenPikerView() -> Void {
        if self.pickerView != nil {
            UIView.animate(withDuration: 0.5, animations: {
                self.pickerView.frame = CGRect(x: 0, y: self.height, width: self.width, height: self.height - adapt_H(height: 400))
            }, completion: { (finished) in
                self.pickerView.isHidden = true
                self.picker.selectRow(6, inComponent: 0, animated: true)
                self.picker.selectRow(7, inComponent: 1, animated: true)
                self.picker.selectRow(7, inComponent: 2, animated: true)
            })
        }
    }
    
    
    func tapGestureAct(sender:UITapGestureRecognizer) -> Void {
        tlPrint(message: "sender.view.tag: \(String(describing: sender.view?.tag))")
    }
    
    

    
}
