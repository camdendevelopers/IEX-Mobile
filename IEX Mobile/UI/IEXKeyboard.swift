//
//  IEXKeyboard.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/27/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

protocol IEXKeyboardDelegate: class {
    func amountChange(_ amount: Double)
}

@IBDesignable class IEXKeyboard: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var oneButton: UIButton!
    @IBOutlet var twoButton: UIButton!
    @IBOutlet var threeButton: UIButton!
    @IBOutlet var fourButton: UIButton!
    @IBOutlet var fiveButton: UIButton!
    @IBOutlet var sixButton: UIButton!
    @IBOutlet var sevenButton: UIButton!
    @IBOutlet var eightButton: UIButton!
    @IBOutlet var nineButton: UIButton!
    @IBOutlet var zeroButton: UIButton!
    @IBOutlet var decimalButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var elements: [UIView]!

    override var tintColor: UIColor! {
        didSet { updateInterface() }
    }

    private var string: String = ""
    weak var delegate: IEXKeyboardDelegate?
    lazy var amount: Double = Double(string) ?? 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }

    private func commonSetup() {
        Bundle.main.loadNibNamed("IEXKeyboard", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    private func updateInterface() {
        elements.forEach { $0.tintColor = tintColor }
    }

    @IBAction func oneTapped() {
        string += "1"
        delegate?.amountChange(amount)
    }

    @IBAction func twoTapped() {
        string += "2"
        delegate?.amountChange(amount)
    }

    @IBAction func threeTapped() {
        string += "3"
        delegate?.amountChange(amount)
    }

    @IBAction func fourTapped() {
        string += "4"
        delegate?.amountChange(amount)
    }

    @IBAction func fiveTapped() {
        string += "5"
        delegate?.amountChange(amount)
    }

    @IBAction func sixTapped() {
        string += "6"
        delegate?.amountChange(amount)
    }

    @IBAction func sevenTapped() {
        string += "7"
        delegate?.amountChange(amount)
    }

    @IBAction func eightTapped() {
        string += "8"
        delegate?.amountChange(amount)
    }

    @IBAction func nineTapped() {
        string += "9"
        delegate?.amountChange(amount)
    }

    @IBAction func zeroTapped() {
        string += "0"
        delegate?.amountChange(amount)
    }

    @IBAction func decimalTapped() {
        string += "."
        delegate?.amountChange(amount)
    }

    @IBAction func deleteButtonTapped() {
        string.removeLast(1)
        delegate?.amountChange(amount)
    }
}
