//
//  NewsArticleView.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/27/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

protocol NewsArticleViewDelegate: class {
    func tapped(with url: URL)
}

class NewsArticleView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var imageView: UIImageView!

    weak var delegate: NewsArticleViewDelegate?
    var articleURL: String?

    init() {
        super.init(frame: .zero)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }

    func commonSetup() {
        setupView()
    }

    func setupView() {
        Bundle.main.loadNibNamed("NewsArticleView", owner: self)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func configure(with article: CompanyNewsArticle) {
        sourceLabel.text = article.source
        headlineLabel.text = article.headline
        articleURL = article.url
        timestampLabel.text = IEXMobileUtilities.relativeFormattingFromToday(article.datetime)

        guard let imageURL = article.image else { return }
        guard let url = URL(string: imageURL) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        let image = UIImage(data: data)
        imageView.image = image
    }

    @IBAction func articleTapped() {
        guard let urlString = articleURL, let url = URL(string: urlString) else { return }
        delegate?.tapped(with: url)
    }
}
