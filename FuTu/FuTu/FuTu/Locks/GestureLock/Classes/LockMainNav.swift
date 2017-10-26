//  FuTu
//
//  Created by Administrator1 on 14/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

class LockMainNav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: LockManager.options.barTittleColor, NSFontAttributeName: LockManager.options.barTittleFont]

        if LockManager.options.hideBarBottomLine {
            navigationBar.hideBottomHairline()
        }
        
        if let backgroundColor = LockManager.options.barBackgroundColor {
            navigationBar.setMyBackgroundColor(backgroundColor)
        }
        navigationBar.tintColor = LockManager.options.barTintColor
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return LockManager.options.statusBarStyle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
