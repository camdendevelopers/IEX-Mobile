//
//  UIColor+IEX.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/25/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

extension UIColor {
    static let coreBlue = UIColor(hex: 0x308CF9)!
    static let corePink = UIColor(hex: 0xF222AC)!
}

extension UIColor {
    private convenience init?(hex6: Int, alpha: Float) {
        self.init(red: CGFloat( (hex6 & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0,
                  alpha: CGFloat(alpha))
    }

    public convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }

    public convenience init?(hex: Int, alpha: Float) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: hex, alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
}
