//
//  BalanceSheetPageViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/5/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

class BalanceSheetPageViewController: UIViewController {
    @IBOutlet var balanceSheetView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var leftArrowImageView: UIImageView!
    @IBOutlet var rightArrowImageView: UIImageView!

    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var currentIndex = 0

    var balanceSheetViewControllers: [UIViewController] = []
    var balanceSheets: [BalanceSheet] = [] {
        didSet {
            balanceSheets.forEach { sheet in
                let balanceSheetViewController = BalanceSheetViewController.instantiate(from: .company)
                balanceSheetViewController.balanceSheet = sheet

                balanceSheetViewControllers.append(balanceSheetViewController)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupImages()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        flashArrows(left: false)
    }

    private func setupPageViewController() {
        guard let firstViewController = balanceSheetViewControllers.first else { return }
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)

        balanceSheetView.addSubview(pageViewController.view)

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.topAnchor.constraint(equalTo: balanceSheetView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: balanceSheetView.bottomAnchor).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: balanceSheetView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: balanceSheetView.trailingAnchor).isActive = true

        pageControl.numberOfPages = balanceSheets.count
    }

    private func setupImages() {
        leftArrowImageView.tintColor = UIColor.IEX.main
        rightArrowImageView.tintColor = UIColor.IEX.main
    }

    private func flashArrows(left: Bool = true, right: Bool = true) {
        UIView.animate(withDuration: 1, delay: 0.10, options: .curveEaseInOut, animations: {
            self.leftArrowImageView.alpha = left ? 1 : 0
            self.rightArrowImageView.alpha = right ? 1 : 0

            UIView.animate(withDuration: 0.50, delay: 0.25, options: .curveEaseInOut, animations: {
                self.leftArrowImageView.alpha = 0
                self.rightArrowImageView.alpha = 0
            }, completion: nil)
        }, completion: nil)
    }
}

// MARK: - UIPageViewController Delegate Extensions
extension BalanceSheetPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 1. Check if there are any more view controllers to display
        guard let viewControllerIndex = balanceSheetViewControllers.firstIndex(of: viewController) else { return nil }
        // 2. If yes, decrease the index by one
        let previousIndex = viewControllerIndex - 1

        // 3. Make sure you are not at the first screen
        guard previousIndex >= 0 else { return nil }

        // 4. Return the view controller to display
        return balanceSheetViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 1. Check if there are any more view controllers to display
        guard let viewControllerIndex = balanceSheetViewControllers.firstIndex(of: viewController) else { return nil }

        // 2. If yes, increase the index by one
        let nextIndex = viewControllerIndex + 1

        // 3. Make sure you are not at the first screen
        guard balanceSheetViewControllers.count != nextIndex else { return nil }

        // 4. Return the view controller to display
        return balanceSheetViewControllers[nextIndex]
    }
}

extension BalanceSheetPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        // 1. Check if screen has finished transition from one view to next
        guard completed else { return }

        // 2. If yes, update the page control current indicator to change to index
        pageControl.currentPage = currentIndex
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {

        // 1. Update the current index to the view controller index user will transition to
        guard let firstViewController = pendingViewControllers.first else { return }
        guard let viewControllerIndex = balanceSheetViewControllers.firstIndex(of: firstViewController) else { return }
        currentIndex = viewControllerIndex
        flashArrows(left: currentIndex != 0, right: currentIndex != balanceSheetViewControllers.count - 1)
    }
}
