//
//  TradeTableViewCell.swift
//  FuTu
//
//  Created by Administrator1 on 28/12/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

import UIKit

class TradeTableViewCell: UITableViewCell {

    

    var info: [Any]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tlPrint(message: "****")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        setUpUI()
    }
    func setUpUI() {
        
        //amountLabel
        let amountFrame = CGRect(x: adapt_W(width: isPhone ? 16 : 30), y: adapt_H(height: isPhone ? 18 : 12), width: adapt_W(width: isPhone ? 250 : 150), height: adapt_H(height: isPhone ? 15 : 10))
        let amountLabel = UILabel(frame: amountFrame)
        setLabelProperty(label: amountLabel, text: "\(info[0])  ¥\(info[1])", aligenment: .left, textColor: .colorWithCustom(r: 35, g: 35, b: 35), backColor: .clear, font: fontAdapt(font: isPhone ? 17 : 11))
        self.addSubview(amountLabel)
        
        
        //trade status
        let statusFrame = CGRect(x: deviceScreen.width - adapt_W(width: isPhone ? 255 : 230), y: amountFrame.origin.y, width: adapt_W(width: isPhone ? 250 : 200), height: amountFrame.height)
        let statusLabel = UILabel(frame: statusFrame)
        //let tradeStatus:(String,UIColor) = (info[2] as! String == "交易成功") ? ("交易成功",UIColor.colorWithCustom(r: 27, g: 123, b: 233)):("交易失败",UIColor.colorWithCustom(r: 211, g: 18, b: 0))
        let statusString = info[2] as! String
        let tradeStatus:(String,UIColor) = (statusString,statusString.range(of: "成功") != nil ? UIColor.colorWithCustom(r: 27, g: 123, b: 233) : UIColor.colorWithCustom(r: 211, g: 18, b: 0))
        setLabelProperty(label: statusLabel, text: tradeStatus.0, aligenment: .right, textColor: tradeStatus.1, backColor: .clear, font: fontAdapt(font: isPhone ? 15 : 10))
        self.addSubview(statusLabel)
        
        //order number
        let orderFrame = CGRect(x: amountFrame.origin.x, y: adapt_H(height: isPhone ? 45 : 30), width: adapt_W(width: 260), height: adapt_H(height: isPhone ? 12 : 8))
        let orderLabel = UILabel(frame: orderFrame)
        setLabelProperty(label: orderLabel, text: "订单号 \(info[3])", aligenment: .left, textColor: .colorWithCustom(r: 161, g: 161, b: 161), backColor: .clear, font: fontAdapt(font: isPhone ? 14 : 9))
        self.addSubview(orderLabel)
        
        //trade date 
        let dateFrame = CGRect(x: deviceScreen.width - adapt_W(width: isPhone ? 90 : 80), y: orderFrame.origin.y, width: adapt_W(width: isPhone ? 85 : 50), height: adapt_H(height: isPhone ? 12 : 8))
        let dateLabel = UILabel(frame: dateFrame)
        setLabelProperty(label: dateLabel, text: "\(info[4])", aligenment: .right, textColor: .colorWithCustom(r: 161, g: 161, b: 161), backColor: .clear, font: fontAdapt(font: isPhone ? 14 : 9))
        self.addSubview(dateLabel)
        
        
        
    }
}
