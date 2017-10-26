//
//  TradeSearchViewController.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit



class TradeSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, BtnActDelegate {

    
    var searchView:TradeSearchView!
    var searchType:tradeSearchType!
    var model = TradeSearchModel()
    var dataSource: [[Any]]! = [["","",false,"",""]]
    var width,height: CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.width = self.view.frame.width
        self.height = self.view.frame.height
        self.searchView = TradeSearchView(frame: self.view.frame, searchType: searchType, rootVC: self)
        self.view.addSubview(self.searchView)
        
        notifyRegister()
    }

    //查询类型： 
    //0 表示充值提现查询，默认显示充值页
    //1 表示转账查询，默认显示转账页
    //2 表示红利查询，默认显示红利界面
    init(searchType:tradeSearchType) {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = model.dataSource
        self.searchType = searchType
        initSearchInfo(type: searchType)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initSearchInfo(type:tradeSearchType) -> Void {
        
        let year = NSDate.getDate(type: .year)
        let month = NSDate.getDate(type: .month)
        let day = NSDate.getDate(type: .day)
        let lastYear = (month == "01" ? "\(Int(year)! - Int("1")!)" : year)
        let lastMonth = (month == "01" ? "12" : month)
        tlPrint(message: "year:\(year)-month:\(month)-day:\(day)-lastYear:\(lastYear)-lastMonth:\(lastMonth)")
        model.getSearchedData(type: type, startDate: "\(lastYear)-\(lastMonth)-\(day)", endDate: "\(year)-\(month)-\(day)")
    }
    
    
    //消息通知
    func notifyRegister() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadInfoTable(sender:)), name: NSNotification.Name(rawValue: notificationName.TradeSearchInfoTableRefresh.rawValue), object: nil)
        
    }


    func searchTypeChoose(index:Int) -> tradeSearchType {
        var type:tradeSearchType!
        switch index {
        case 0:
            type = tradeSearchType.Recharge
        case 1:
            type = tradeSearchType.Withdraw
        case 2:
            type = tradeSearchType.Transfer
        default:
            type = tradeSearchType.Bonus
        }
        return type
    }
    
    func btnAct(btnTag: Int) {
        tlPrint(message: "tradeSearchBtnAct btnTag:\(btnTag)")
        switch btnTag {
        case tradeSearchTag.TradeSearchBackBtnTag.rawValue:
            _ = self.navigationController?.popViewController(animated: true)
            
        case tradeSearchTag.DateSearchBtnTag.rawValue:
            tlPrint(message: "查询按钮")
            let dateView1 = self.searchView.viewWithTag(tradeSearchTag.DateSelector1.rawValue) as! UITextField
            let dateView2 = self.searchView.viewWithTag(tradeSearchTag.DateSelector2.rawValue) as! UITextField
            let date1 = dateView1.text
            let date2 = dateView2.text
            let dateArray1 = date1?.components(separatedBy: "/")
            let dateArray2 = date2?.components(separatedBy: "/")
            let index = btnTag - tradeSearchTag.TradeSearchTabBtnTag.rawValue
            tlPrint(message: "index:\(index)")
//            let type = self.searchTypeChoose(index: index)
            model.getSearchedData(type: self.searchType, startDate: "\(dateArray1![0])-\(dateArray1![1])-\(dateArray1![2])", endDate: "\(dateArray2![0])-\(dateArray2![1])-\(dateArray2![2])")
        default:
            if btnTag >= tradeSearchTag.TradeSearchTabBtnTag.rawValue && btnTag < tradeSearchTag.TradeSearchTabLineTag.rawValue {
                tlPrint(message: "tab button")
                let index = btnTag - tradeSearchTag.TradeSearchTabBtnTag.rawValue
                let type = self.searchTypeChoose(index: index)
                self.initSearchInfo(type: type)
                self.searchType = type
                
                let dateView1 = self.searchView.viewWithTag(tradeSearchTag.DateSelector1.rawValue) as! UITextField
                let dateView2 = self.searchView.viewWithTag(tradeSearchTag.DateSelector2.rawValue) as! UITextField
                dateView1.text = ""
                dateView2.text = ""
            } else {
                tlPrint(message: "no such case")
            }
        }
    }
    
    func reloadInfoTable(sender:NotificationCenter) -> Void {
        
        
        self.dataSource = model.dataSource
        self.searchView.infoTable.reloadData()
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.searchView.hiddenPikerView()
    }
    
    
    //****************************************
    //      TextField delegate
    //****************************************
    
    var currentTextField:UITextField!
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tlPrint(message: "textFieldShouldBeginEditing")
        textField.resignFirstResponder()
        currentTextField = textField
        
        searchView.initUIPickerView(textField:textField)
        
        return false
    }

    
    
    
    //****************************************
    //      TablView delegate
    //****************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tlPrint(message: "numberOfRowsInSection")
        return dataSource.count
    }
    //返回行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tlPrint(message: "heightForRowAt")
        return adapt_H(height: isPhone ? 75 : 50)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tlPrint(message: "cellForRowAt \(indexPath)")
        
        let reuStr:String = "ABC"
        var cell:TradeTableViewCell!
        if cell == nil {
            cell=TradeTableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: reuStr)
        }
        tableView.separatorStyle = .singleLine
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.info = self.dataSource[indexPath[1]]
        return cell
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
