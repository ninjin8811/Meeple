//
//  ColorPalette.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/21.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

final class ColorPalette: NSObject {
    class func meepleColor() -> UIColor {
        return #colorLiteral(red: 0.8784313725, green: 0.4, blue: 0.3450980392, alpha: 1)
    }
    class func titleColor() -> UIColor {
        return #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
    }
    class func textColor() -> UIColor {
        return #colorLiteral(red: 0.4039215686, green: 0.4039215686, blue: 0.4039215686, alpha: 1)
    }
    class func lightTextColor() -> UIColor {
        return #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
    }
    class func disabledColor() -> UIColor {
        return #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
}
