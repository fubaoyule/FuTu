//: Playground - noun: a place where people can play

import UIKit






//let img = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//img.image = UIImage(named: "commission_ball_light.png")
//img.layer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(M_PI / 180) * 0.6 * 360))
//
//
//
//
//
//var str = "Hello, playground"
//let indexs = 3
//CGFloat(indexs % 4)
//func test1() {
//
//    for i in 0 ... 7 {
//        _ = i / 4
//        _ = i % 4
//    }
//}
//test1()
//let test = "hello world"
//test.range(of: "hello") != nil
////判断子串
//let url = URL(string: "http")
//String(describing: url).range(of: "ht") != nil
//"O2P-01" == "02P"
//let urlString = "www.baidu.com"
//
//let url_t = URL(string: urlString)
//var domain = "https://m.futu.com"
//let index = domain.range(of: "https://") == nil ? 7 : 8
//domain = (domain as NSString).substring(from: index)
//
//let sourceString: String = "[\"通知：中国人民银行将于2016年11月26日00：00至8：00系统维护\",\"通知：BBIN平台电子游戏进行系统升级维护\"]"
//
//
//var sourceArray = sourceString.components(separatedBy: "\"")
//
//sourceArray.count
//var sourceArray2:Array<String> = [""]
//for i in 0 ... sourceArray.count - 2 {
//    if i % 2 != 0 {
//        sourceArray2.append(sourceArray[i])
//    }
//}
//sourceArray2.removeFirst()
//sourceArray2
//
//
//
//var firstArray = ["通知：中国人民银行将于2016年11月26日00：00至8：00系统维护", "通知：BBIN平台电子游戏进行系统升级维护"]
//let maxWord = 20
//var temp:Array<String>!
//var newValue: Array<String> = ["tt"]
//for i in 0 ... firstArray.count - 1 {
//    
//    var temp = firstArray[i] as String
//    for j in 0 ... (temp.characters.count - 1) / maxWord {
//            
//        var wordNum = maxWord
//        if temp.characters.count < wordNum {
//            wordNum = temp.characters.count
//        }
//        let index = temp.index(temp.startIndex, offsetBy: wordNum)
//        newValue.append(temp.substring(to: index))
//        temp = temp.substring(from: index)
//    }
//    
//}
//newValue.removeFirst()
//newValue
//var TextStyle : [String : NSObject] {
//get {
//    
//    let paraStyle = NSMutableParagraphStyle()
//    
//    paraStyle.minimumLineHeight = 17.3
//    
//    paraStyle.lineSpacing = 0
//    
//    paraStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
//    
//    paraStyle.paragraphSpacing = 0
//    
//    paraStyle.paragraphSpacingBefore = 0
//    
//    return [NSForegroundColorAttributeName: UIColor.black,
//            NSKernAttributeName: CGFloat(0.5) as NSObject,
//            NSFontAttributeName: UIFont.systemFont(ofSize: 15.0),
//            NSParagraphStyleAttributeName: paraStyle
//    ]
//}
//}
//let label = UILabel()
//label.attributedText = NSAttributedString(string: "Hello World", attributes: TextStyle)
//
//
//let value = Int("2")! - Int("1")!
//
//
//let stringInfo = "0.00"
//let stringArray = stringInfo.components(separatedBy: ".")
//var newString = stringArray[1].substring(to: stringArray[1].index(stringArray[1].startIndex, offsetBy: 2))
//newString = stringArray[0] + "." + newString
//
//let strings = "1223"
//let ints = Int(strings)
//
//
//
//
//func isChiness(string:String) -> Bool {
////    tlPrint(message: "isChiness")
//    let match = "(^[\\u4e00-\\u9fa5]+$)"
//    let predicate = NSPredicate(format: "SELF matches %@", match)
//    let isChines = predicate.evaluate(with: string)
//    return isChines
//}
//
//
//let ischiness = isChiness(string: "最佳2平面广告")

////将字符串转换为浮点型
//let float1:String = "0.3"
//
//let float2 = NumberFormatter().number(from: float1)
//
//let float3 = float1.appendingFormat("%d", float1)
//
//(float1 as NSString).integerValue


//var firstDateStr = "2017-03-02 22:22:22"
//var secondDateStr = "2011-01-01 22:22:22"
//
//var dm: DateFormatter = DateFormatter()
//dm.dateFormat = "yyyy-MM-dd HH:mm:ss"
//let D_SECENDS = 1
//let D_MINUTE = D_SECENDS * 60
//let D_HOUR = D_MINUTE * 60
//let D_DAY = D_HOUR * 24
//var firstDate :Date = dm.date(from: firstDateStr)!
//var secondDate :
//    Date = dm.date(from: secondDateStr)!
//var interval:TimeInterval = firstDate.timeIntervalSinceNow
//var days = (Int(interval)) / D_DAY
//let hours = (Int(interval)) / D_HOUR % 24
//let minuts = (Int(interval)) / D_MINUTE % 60
//let secends = (Int(interval)) / D_SECENDS % 60
//


////保留小数点后两位
//let award = "13.444234"
//let newAward = String(format: "%.2f", (award as NSString).doubleValue)
//
//
//let dd = String(format: "%.2f", 22.4444)
//
//
////数组种制定为止插入元素
//var array1 = [1,1,1,1,5] as Array<Any>
//array1.insert(5, at: 3)


//普通同步和异步队列
//let queue = DispatchQueue(label: "com.besvict.futu")
//queue.sync {
//    for i in 0 ..< 10 {
//        print(i)
//    }
//}
//for i in  100 ..< 110 {
//    print(i)
//}

//制定优先级的队列
//let queue1 = DispatchQueue(label: "com.besvict.futu1", qos: .background)
//
//let queue2 = DispatchQueue(label: "com.besvict.futu2", qos: .utility)
//
//queue1.async {
//    for i in  0 ..< 10 {
//        print(i)
//    }
//}
//
//queue2.async {
//    for i in  100 ..< 110 {
//        print(i)
//    }
//}
//
//
//for i in 200 ..< 210 {
//    print(i)
//}

//let string = "[{\"Actclassid\":6,\"test\":5},{\"Actclassid\":6,\"test\":7}]"
//let string = "[{\"Actclassid\":6,\"Activity_Code\":\"FirstDpBonus\",\"Condition\":\"\",\"Main_Title\":\"首存奖金\",\"Sub_Title\":\"针对老虎机的首存奖金\",\"Description\":\"?针对老虎机的首存奖金\",\"Imagelink\":\"/FileUpload/20170619170258416.png\",\"Start_Time\":\"2017-06-19T00:00:00\",\"End_Time\":\"2020-06-19T00:00:00\",\"Fake_Number\":0,\"Is_Need_Approve\":0,\"Is_Published\":1,\"Published_Admin_Id\":\"\",\"Is_Closed\":1,\"Update_Admin_Id\":95,\"Update_Time\":\"2017-06-19T17:07:00\",\"Create_Admin_Id\":6,\"Create_Time\":\"2017-06-19T10:57:00\",\"Is_Del\":0,\"Id\":88}]"
//var array = string.components(separatedBy: ",{")
//array[0] = array[0].replacingOccurrences(of: "[{", with: "{")
//array[array.count - 1] = array[array.count - 1].replacingOccurrences(of: "}]", with: "}")
//for i in 0 ..< array.count {
//    if i > 0 {
//    array[i] = "{" + array[i]
//    }
//}
//array[0]
////array[1]
//var dictonary:NSDictionary?
//if let data = array[0].data(using: String.Encoding.utf8) {
//    do {
//        dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
//        
//        if let myDictionary = dictonary
//        {
//            print(" First name is: \(myDictionary["Actclassid"]!)")
//        }
//    } catch let error as NSError {
//        print(error)
//    }
//}

//let thisJSON = try  JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//
//let datastring:String = String(data: thisJSON, encoding: String.Encoding.utf8)!

//let string = "[\"Actclassid\":6]"
//(string).objectFromJSONString() as! Dictionary<String, Any>
//var activesListDic = string[0]
//let value = activesListDic["Update_Admin_Id"]


//var listDicArray:[Dictionary<String,Any>]!
//let listInfo:Dictionary<String,Any> = ["1":1]
//if listDicArray == nil {
//    listDicArray = [listInfo]
//}
//listDicArray.insert(listInfo, at: 1)
//listDicArray.insert(listInfo, at: 2)
//


//let url = "www.baidu.com/1245/en?lobbyURL=www.123.com&bankingURL=www.234.com&username=\(123)&password=\(123)"
//let url = "https://bsistage.playngonetwork.com/casino/PlayMobile?div=pngCasinoGame&lang=zh_CN&pid=295&practice=0&width=1024px&height=1&gameid=100005&username=12345678910"
//let Url = URL(string: url)
//
//
//let string = "taylor loves world"
//let array = string.components(separatedBy: "world")


//let payStartTime = Date()
//sleep(10)
//let interval = DateInterval(start: payStartTime, end: Date())
//print(interval.duration)

let string = "12345"
string.contains("31")





//let dateFormatter = DateFormatter()
//let date1 = Date()
//sleep(1)
//let date2 = Date()
//let interval = (date1.timeIntervalSinceReferenceDate) -   (date2.timeIntervalSinceReferenceDate)
//if  interval >= 0{
//    print("大于等于")
//}
//else{
//    print("小于")
//}
//
//dateFormatter.dateFormat = "HH:mm:ss zzz"
//let intervalDate = dateFormatter.date(from: "00:05:00 GMT")

//let startDate_s = "2017-10-15 12:20:00"
//let dateFormatter = DateFormatter()
//dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//let startDate = dateFormatter.date(from: startDate_s)


//tlPrint(message: "startDate_s = \(startDate_s)\tstartDate:\(startDate)")




var valueArray = [0,0,0]
var newValue = 123

for i in 0 ..< 3 {
    valueArray[2 - i] = newValue % 10
    newValue = Int(newValue / 10)
}
valueArray









