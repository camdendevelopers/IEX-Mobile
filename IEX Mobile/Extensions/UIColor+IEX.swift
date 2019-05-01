//
//  UIColor+IEX.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/25/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

extension UIColor {
    enum IEX {
        static let main         = UIColor(hex: 0xEF0073)!
        static let shadowMain   = UIColor(hex: 0xEF0073, alpha: 0.15)!
        static let shadowGray   = UIColor(hex: 0x142130, alpha: 0.05)!
        static let offWhite     = UIColor(hex: 0xF7F9FA)!
        static let silver       = UIColor(hex: 0xf1f3f4)!
        static let lightGray    = UIColor(hex: 0xEEEFF1)!
        static let gray         = UIColor(hex: 0xdcdde1)!
        static let midGray      = UIColor(hex: 0xBBBCBE)!
        static let darkGray     = UIColor(hex: 0x142130)!
        static let key          = UIColor(hex: 0x080e14)!
        static let navy1        = UIColor(hex: 0x21303c)!
        static let navy2        = UIColor(hex: 0x2d3c4e)!
        static let navy3        = UIColor(hex: 0x4b5a6c)!
        static let navy4        = UIColor(hex: 0x738294)!
        static let green        = UIColor(hex: 0x26cea1)!
        static let neonGreen    = UIColor(hex: 0x1ef78f)!
        static let paleGreen    = UIColor(hex: 0xC6E5D8)!
        static let palestGreen  = UIColor(hex: 0xc6e5d8, alpha: 0.5)!
        static let grayGreen    = UIColor(hex: 0xc6e5d8, alpha: 0.25)!
        static let yellow       = UIColor(hex: 0xffe158)!
        static let paleYellow   = UIColor(hex: 0xfff792)!
        static let paleBlue     = UIColor(hex: 0xbae5ff)!
        static let skyBlue      = UIColor(hex: 0x8BC5E9)!
        static let lightBlue    = UIColor(hex: 0x22d0ff)!
        static let blue         = UIColor(hex: 0x4271ff)!
        static let purpleBlue   = UIColor(hex: 0x5099FF)!
        static let darkBlue     = UIColor(hex: 0x353BE3)!
        static let plum         = UIColor(hex: 0x1F1C78)!
        static let purple       = UIColor(hex: 0x734cf2)!
        static let palePurple   = UIColor(hex: 0xf3e8ff)!
        static let paleRed      = UIColor(hex: 0xffc7c0)!
        static let palestRed    = UIColor(hex: 0xfff2f0)!
        static let errorRed     = UIColor(hex: 0xfb5960)!
        static let pink         = UIColor(hex: 0xec7f84)!
        static let orange       = UIColor(hex: 0xffa25c)!
        static let paleOrange   = UIColor(hex: 0xffebdb)!
    }
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
