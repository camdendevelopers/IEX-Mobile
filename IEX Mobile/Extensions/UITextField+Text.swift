//
//  UITextField+Text.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/25/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

extension UITextField {
    var isEmpty: Bool {
        guard let text = text else { return true }
        return text.isEmpty
    }
}
