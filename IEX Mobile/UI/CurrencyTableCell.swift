//
//  CurrencyTableCell.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 5/27/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit

class CurrencyTableCell: UITableViewCell {
    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var codeLabel: UILabel!

    var name: String = "" { didSet { nameLabel.text = name } }

    var code: String = "" {
        didSet {
            codeLabel.text = code
            IEXMobileUtilities.fetchCountryFlag(with: code) { self.flagImageView.image = $0 }
        }
    }

    override func awakeFromNib() {
        nameLabel.text = name
        codeLabel.text = code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        flagImageView.accessibilityIgnoresInvertColors = true
        flagImageView.layer.cornerRadius = 2
    }
}
