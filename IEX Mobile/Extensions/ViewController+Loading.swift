//
//  ViewController+Loading.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/25/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    var loadingIndicatorTag: Int { return 999999 }

    static var storyboardID: String { return "\(self)" }

    static func instantiate(from storyboard: Storyboard) -> Self {
        return storyboard.viewController(of: self)
    }

    func startLoading() {
        let indicator = NVActivityIndicatorView(
            frame: CGRect(x: (view.frame.width - 60) / 2, y: (view.frame.height - 60) / 2, width: 60, height: 60),
            type: .ballScaleRippleMultiple,
            color: UIColor.IEX.main,
            padding: 0)

        indicator.tag = loadingIndicatorTag
        indicator.startAnimating()

        view.addSubview(indicator)

        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func stopLoading() {
        let loadingIndicator = view.viewWithTag(loadingIndicatorTag) as? NVActivityIndicatorView
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()

        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
