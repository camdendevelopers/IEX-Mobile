//
//  FeedbackPageBulletinItem.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/2/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import Foundation
import BLTNBoard

class FeedbackPageBulletinItem: BLTNPageItem {

    private let feedbackGenerator = SelectionFeedbackGenerator()

    override func actionButtonTapped(sender: UIButton) {

        // Play an haptic feedback
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()

        // Call super
        super.actionButtonTapped(sender: sender)

    }

    override func alternativeButtonTapped(sender: UIButton) {

        // Play an haptic feedback
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()

        // Call super
        super.alternativeButtonTapped(sender: sender)

    }

}
