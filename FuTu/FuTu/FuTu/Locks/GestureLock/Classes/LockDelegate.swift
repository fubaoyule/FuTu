//  FuTu
//
//  Created by Administrator1 on 14/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

public protocol LockDelegate {
    var hideBarBottomLine: Bool { get }
    var barTintColor: UIColor { get }
    var barTittleColor: UIColor {  get }
    var barTittleFont: UIFont { get }
    var barBackgroundColor: UIColor? { get }
    var statusBarStyle: UIStatusBarStyle { get }
}
