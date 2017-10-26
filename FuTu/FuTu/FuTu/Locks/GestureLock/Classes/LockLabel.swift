//  FuTu
//
//  Created by Administrator1 on 14/10/16.
//  Copyright © 2016 Taylor Tan. All rights reserved.
//

class LockLabel: UILabel {

    var options: LockOptions!

    init(frame: CGRect, options: LockOptions) {
        super.init(frame: frame)
        textAlignment = .center
        backgroundColor = options.backgroundColor
        self.options = options
    }

    func showNormal(_ message: String?) {
        text = message
        textColor = options.normalTitleColor
    }

    func showWarn(_ message: String?) {
        text = message
        textColor = options.warningTitleColor
        layer.shake()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
