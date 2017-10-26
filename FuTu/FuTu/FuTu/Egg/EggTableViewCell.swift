////
////  EggTableViewCell.swift
////  FuTu
////
////  Created by Administrator1 on 6/1/17.
////  Copyright © 2017 Taylor Tan. All rights reserved.
////
//
//import UIKit
//
//class EggTableViewCell: UITableViewCell {
//
//    var info:[Any]!
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    init(info:[Any]) {
//        super.init(style: .default, reuseIdentifier: "ABC")
//        self.info = info
//        tlPrint(message: "info : \(info)")
//        self.backgroundColor = UIColor.colorWithCustom(r: 110, g: 7, b: 38)
//        //self.backgroundColor = UIColor.randomColor()
//        initCell()
//    }
//    
//    func initCell() -> Void {
//        let label = UILabel(frame: CGRect(x: adapt_W(width: isPhone ? 15 : 80), y: 0, width: deviceScreen.width - adapt_W(width: isPhone ? 50 : 100), height: adapt_H(height: isPhone ? 25 : 15)))
//        self.addSubview(label)
//        let name = String(describing: info[0])
//        var showName = name.substring(to: name.index(name.startIndex, offsetBy: 2))
//        showName.append("***")
//        showName.append(name.substring(from: name.index(name.endIndex, offsetBy: -2)))
//        var award = String(describing: info[1])
//        award = retain2Decima(originString: award)
//        let date = String(describing: info[2])
//        let text = "恭喜 \(showName)砸中\(award)元 \(date)"
//        setLabelProperty(label: label, text: "", aligenment: .left, textColor: .colorWithCustom(r: 241, g: 241, b: 241), backColor: .clear, font: fontAdapt(font: isPhone ? 14 : 10))
//        //label.text = text
//        let attStr = NSMutableAttributedString(string: text)
//        attStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithCustom(r: 255, g: 204, b: 0), range: NSRange(location: 3, length: 7))
//        attStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithCustom(r: 255, g: 204, b: 0), range: NSRange(location: 12, length: award.characters.count + 1))
//        label.attributedText = attStr
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
