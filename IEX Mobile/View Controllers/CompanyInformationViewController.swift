//
//  CompanyInformationViewController.swift
//  IEX Mobile
//
//  Created by Marcos Ortiz on 4/26/19.
//  Copyright © 2019 Camden Developers. All rights reserved.
//

import UIKit
import SafariServices
import Charts

class CompanyInformationViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var ceoNameLabel: UILabel!
    @IBOutlet var sectorLabel: UILabel!
    @IBOutlet var industryLabel: UILabel!
    @IBOutlet var exchangeLabel: UILabel!
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var week52HighLabel: UILabel!
    @IBOutlet var week52LowLabel: UILabel!
    @IBOutlet var dividendYieldLabel: UILabel!
    @IBOutlet var YTDYieldLabel: UILabel!
    @IBOutlet var averageVolumeLabel: UILabel!
    @IBOutlet var marketCapLabel: UILabel!
    @IBOutlet var peRatioLabel: UILabel!
    @IBOutlet var betaLabel: UILabel!
    @IBOutlet var chartLoadingContent: UIStackView!
    @IBOutlet var chartRangeSegmentedControl: UISegmentedControl!
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var chartInformationLabel: UILabel!
    @IBOutlet var chartDataStackView: UIStackView!
    @IBOutlet var chartEntryDateLabel: UILabel!
    @IBOutlet var chartEntryPriceLabel: UILabel!

    @IBOutlet var companyDescriptionActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var companyDescriptionStackView: UIStackView!
    @IBOutlet var companyInformationStackView: UIStackView!
    @IBOutlet var advancedStatsStackView: UIStackView!
    @IBOutlet var newsStackView: UIStackView!
    @IBOutlet var chartStackView: UIStackView!

    var companyTicker: String = ""
    var chartRange: IEXChartRange = .ytd
    var companyInformation: CompanyInformation?
    var companyChartDataEntries: [CompanyChartDataItem] = []
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupChart()
        fetchCompanyInformation()
        fetchAdvancedStatistics()
        fetchCompanyNews()
        fetchChartData()
    }

    private func setupScrollView() {
        scrollView.delegate = self
    }

    private func setupChart() {
        chartView.delegate = self
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.noDataText = ""
        chartView.extraTopOffset = 10
    }

    private func fetchCompanyInformation() {
        IEXSwift.shared.fetchCompanyInformation(ticker: companyTicker) { result in
            guard result.isSuccess else {
                self.navigationController?.popViewController(animated: true)
                return
            }

            guard let companyInformation = result.value else { return }

            UIView.animate(withDuration: 0.35, animations: {
                self.companyDescriptionActivityIndicator.alpha = 0
                self.companyDescriptionActivityIndicator.isHidden = true
                self.companyDescriptionStackView.isHidden = false
            })

            self.companyInformation = companyInformation
            self.nameLabel.text = companyInformation.companyName
            self.descriptionLabel.text = companyInformation.description
            self.sectorLabel.text = companyInformation.sector
            self.industryLabel.text = companyInformation.industry
            self.exchangeLabel.text = companyInformation.exchange

            let ceo = companyInformation.CEO
            if !ceo.isEmpty { self.ceoNameLabel.text = ceo }

            let website = companyInformation.website
            if !website.isEmpty {
                self.websiteButton.setTitleColor(UIColor.IEX.blue, for: .normal)
                self.websiteButton.setTitle(companyInformation.website, for: .normal)
                self.websiteButton.isEnabled = !companyInformation.website.isEmpty
            }
        }
    }

    func fetchAdvancedStatistics() {
        IEXSwift.shared.fetchAdvanceStatistics(ticker: companyTicker) { result in
            guard result.isSuccess else { return }

            UIView.animate(withDuration: 0.4, animations: {
                self.advancedStatsStackView.isHidden = false
            })

            guard let advancedStatistics = result.value else { return }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currencyAccounting

            if let week52high = advancedStatistics.week52high {
                self.week52HighLabel.text = numberFormatter.string(from: NSNumber(value: week52high))
            }

            if let week52low = advancedStatistics.week52low {
                self.week52LowLabel.text = numberFormatter.string(from: NSNumber(value: week52low))
            }

            numberFormatter.numberStyle = .percent
            numberFormatter.maximumFractionDigits = 2

            if let dividendYield = advancedStatistics.dividendYield {
                self.dividendYieldLabel.text = numberFormatter.string(from: NSNumber(value: dividendYield))
            }

            if let ytdChangePercent = advancedStatistics.ytdChangePercent {
                self.YTDYieldLabel.text = numberFormatter.string(from: NSNumber(value: ytdChangePercent))
            }

            numberFormatter.numberStyle = .decimal

            if let avg10Volume = advancedStatistics.avg10Volume {
                self.averageVolumeLabel.text = numberFormatter.string(from: NSNumber(value: avg10Volume))
            }

            if var marketcap = advancedStatistics.marketcap {
                let updatedSuffix = marketcap > 999_999 ? "M" : ""
                marketcap = marketcap > 999_999 ? marketcap / 100_000 : marketcap
                let marketcapString = numberFormatter.string(from: NSNumber(value: marketcap)) ?? ""
                self.marketCapLabel.text = marketcapString + updatedSuffix
            }

            if let peRatio = advancedStatistics.peRatio {
                self.peRatioLabel.text = numberFormatter.string(from: NSNumber(value: peRatio))
            }

            if let beta = advancedStatistics.beta {
                self.betaLabel.text = numberFormatter.string(from: NSNumber(value: beta))
            }
        }
    }

    func fetchCompanyNews() {
        IEXSwift.shared.fetchNews(ticker: companyTicker) { result in
            guard result.isSuccess else { return }
            guard let articles = result.value, !articles.isEmpty else { return }

            UIView.animate(withDuration: 0.4, animations: {
                self.newsStackView.isHidden = false
            })

            for articleIndex in 0..<min(articles.count, 2) {
                let newsView = NewsArticleView()
                newsView.delegate = self
                let article = articles[articleIndex]
                newsView.configure(with: article)
                self.newsStackView.addArrangedSubview(newsView)
            }
        }
    }

    func fetchChartData() {
        self.chartView.data = nil
        self.chartView.highlightValues(nil)
        self.chartLoadingContent.isHidden = false

        IEXSwift.shared.fetchChart(ticker: companyTicker, range: chartRange) { result in
            guard result.isSuccess else {
                self.chartStackView.isHidden = false
                self.chartView.isHidden = true
                self.chartRangeSegmentedControl.isHidden = true
                self.chartInformationLabel.isHidden = false
                return
            }

            guard let dataPoints = result.value, !dataPoints.isEmpty else {
                self.chartStackView.isHidden = false
                self.chartView.isHidden = false
                self.chartLoadingContent.isHidden = true
                self.chartRangeSegmentedControl.isHidden = true
                self.chartView.noDataText = "No Price Data Available"
                return
            }

            self.chartStackView.isHidden = false
            self.chartView.isHidden = false
            self.chartLoadingContent.isHidden = true
            self.chartRangeSegmentedControl.isHidden = false
            self.companyChartDataEntries = dataPoints
            self.chartView.notifyDataSetChanged()

            var entries: [ChartDataEntry] = []
            for (index, point) in dataPoints.enumerated() {
                let entry = ChartDataEntry(x: Double(index), y: point.close)
                entries.append(entry)
            }

            let dataSet = LineChartDataSet(values: entries, label: nil)
            dataSet.setColor(UIColor.IEX.main)
            dataSet.drawCirclesEnabled = false
            dataSet.drawValuesEnabled = false
            dataSet.highlightEnabled = true
            dataSet.drawCircleHoleEnabled = false
            dataSet.drawHorizontalHighlightIndicatorEnabled = false
            dataSet.highlightColor = UIColor.IEX.blue
            dataSet.lineWidth = 1

            self.chartView.data = LineChartData(dataSet: dataSet)
            self.chartView.animate(xAxisDuration: 1.5, easingOption: .easeInOutBack)
        }
    }

    @IBAction func chartRangeSegmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartRange = .month1
        case 1:
            chartRange = .month3
        case 2:
            chartRange = .month6
        case 3:
            chartRange = .ytd
        case 4:
            chartRange = .year1
        case 5:
            chartRange = .year2
        default:
            chartRange = .year5
        }

        fetchChartData()
    }

    @IBAction func websiteButtonPressed() {
        guard IEXSwift.shared.environment != .testing, let website = companyInformation?.website, !website.isEmpty else { return }
        guard let url = URL(string: website) else { return }
        present(SFSafariViewController(url: url), animated: true)
    }
}

extension CompanyInformationViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        UIView.animate(withDuration: 0.5) { self.chartDataStackView.isHidden = false }

        chartEntryPriceLabel.text = formatter.string(from: NSNumber(value: entry.y))

        guard let index = chartView.data?.dataSets.first?.entryIndex(entry: entry) else {
            chartEntryDateLabel.alpha = 0
            return
        }
        chartEntryDateLabel.alpha = 1
        chartEntryDateLabel.text = companyChartDataEntries[index].label
    }
}

extension CompanyInformationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        chartView.highlightValues(nil)
    }
}

extension CompanyInformationViewController: NewsArticleViewDelegate {
    func tapped(with url: URL) {
        present(SFSafariViewController(url: url), animated: true)
    }
}
