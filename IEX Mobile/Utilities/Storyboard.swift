//
//  Storyboard.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/25/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    case trips = "Authentication"

    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }

    func viewController<Element: UIViewController>(of viewControllerClass: Element.Type) -> Element {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! Element
    }
}
