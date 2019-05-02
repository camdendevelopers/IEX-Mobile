//
//  SelectionFeedbackGenerator.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/2/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation
import UIKit

class SelectionFeedbackGenerator {

    private let anyObject: AnyObject?

    init() {

        if #available(iOS 10, *) {
            anyObject = UISelectionFeedbackGenerator()
        } else {
            anyObject = nil
        }

    }

    func prepare() {

        if #available(iOS 10, *) {
            (anyObject as! UISelectionFeedbackGenerator).prepare()
        }

    }

    func selectionChanged() {

        if #available(iOS 10, *) {
            (anyObject as! UISelectionFeedbackGenerator).selectionChanged()
        }

    }

}

/**
 * A 3D Touch success feedback generator wrapper that uses the API only when available.
 */

class SuccessFeedbackGenerator {

    private let anyObject: AnyObject?

    init() {

        if #available(iOS 10, *) {
            anyObject = UINotificationFeedbackGenerator()
        } else {
            anyObject = nil
        }

    }

    func prepare() {

        if #available(iOS 10, *) {
            (anyObject as! UINotificationFeedbackGenerator).prepare()
        }

    }

    func success() {

        if #available(iOS 10, *) {
            (anyObject as! UINotificationFeedbackGenerator).notificationOccurred(.success)
        }

    }

}
