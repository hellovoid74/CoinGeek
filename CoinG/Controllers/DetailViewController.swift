//
//  DetailViewController.swift
//  CoinG
//
//  Created by Gleb Lanin on 12/03/2022.
//
import UIKit
import Charts
import SnapKit

class DetailViewController: UIViewController {
    
    var selectedDetail: CoinObject?
    private var dataRepository = DataRepository()
    private var manager = CryptoManager()
    private var graphManager = GraphManager()
    private var logoView = UIImageView()
    private var infoView = UITextView()
    private var priceLabel = UILabel()
    private var changeLabel = UILabel()
    private var arrowLabel = UIImageView()
    private var segmentedControl = UISegmentedControl()
    private var marketLabel = UILabel()
    private var marketCap = UILabel()
    private var dislikedButton: UIBarButtonItem?
    private var likedButton: UIBarButtonItem?
    private var loadingView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    lazy var chartView: LineChartView = {
        let chart = LineChartView()
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        chart.xAxis.enabled = false
        return chart
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        manager.delegate = self
        graphManager.drawDelegate = self
        chartView.delegate = self
        configureSegmentedControl()
        configureUI()
        setLoadingView()
        setNavBar()
        setLoadingView()
        loadData()
        setLikeButton()
    }
    
    func configureUI(){
        view.backgroundColor = Colors.main
        
        infoView.frame = CGRect.zero
        infoView.backgroundColor = Colors.main
        infoView.textColor = .white
        infoView.font = Fonts.cellFont
        
        chartView.backgroundColor = Colors.main
        chartView.borderLineWidth = 2
        chartView.tintColor = .white
        loadingView.frame = CGRect.zero
        
        let price: UILabel = {
            let label = UILabel()
            label.frame = CGRect.zero
            label.backgroundColor = Colors.main
            label.textColor = .white
            label.font = Fonts.bigNum
            label.numberOfLines = 1
            return label
        }()
        
        let change: UILabel = {
            let label = UILabel()
            label.frame = CGRect.zero
            label.backgroundColor = Colors.main
            label.font = Fonts.midNum
            label.numberOfLines = 1
            return label
        }()
        
        let marketText: UILabel = {
            let label = UILabel()
            label.frame = CGRect.zero
            label.backgroundColor = Colors.main
            label.textColor = .white
            label.font = Fonts.smallNum
            label.numberOfLines = 1
            return label
        }()
        
        let marketValue: UILabel = {
            let label = UILabel()
            label.frame = CGRect.zero
            label.backgroundColor = Colors.main
            label.textColor = .white
            label.font = Fonts.smallNum
            label.numberOfLines = 1
            return label
        }()
        
        priceLabel = price
        changeLabel = change
        marketLabel = marketText
        marketLabel.text = Constants.marketCap
        marketCap = marketValue
        
        [logoView, infoView, priceLabel, chartView, segmentedControl, changeLabel, arrowLabel, loadingView,marketLabel, marketCap].forEach {
            view.addSubview($0)
        }
        
        loadingView.addSubview(activityIndicator)
        
        logoView.snp.makeConstraints{
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(view.safeArea.top).offset(25)
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
        
        chartView.snp.makeConstraints{
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(logoView.snp.bottom).offset(5)
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(125)
        }
        
        loadingView.snp.makeConstraints{
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(logoView.snp.bottom).offset(5)
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(125)
        }
        
        segmentedControl.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.75)
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(chartView.snp.bottom)
            $0.height.equalTo(20)
        }
        
        infoView.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.95)
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(segmentedControl.snp.bottom).offset(5)
            $0.bottom.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints{
            $0.width.equalTo(view.snp.width).multipliedBy(0.4)
            $0.top.equalTo(logoView.snp.top)
            $0.left.equalTo(logoView.snp.right).offset(10)
        }
        
        changeLabel.snp.makeConstraints{
            $0.top.equalTo(priceLabel.snp.bottom).offset(1)
            $0.left.equalTo(priceLabel)
            $0.height.equalTo(30)
        }
        
        arrowLabel.snp.makeConstraints{
            $0.centerY.equalTo(changeLabel.snp.centerY)
            $0.left.equalTo(changeLabel.snp.right).offset(5)
            $0.width.equalTo(15)
            $0.height.equalTo(18)
        }
    
        marketLabel.snp.makeConstraints{
            $0.left.equalTo(priceLabel)
            $0.top.equalTo(changeLabel.snp.bottom).offset(1)
            $0.height.equalTo(20)
        }
        
        marketCap.snp.makeConstraints{
            $0.left.equalTo(marketLabel.snp.right).offset(3)
            $0.centerY.equalTo(marketLabel.snp.centerY)
            $0.height.equalTo(20)
        }
        
        activityIndicator.snp.makeConstraints{
            $0.center.equalTo(loadingView.snp.center)
        }
    }
    
    func loadData(){
        guard let object = selectedDetail else {return}
        manager.fetchDetails(object.id)
        graphManager.getHistoricalData(id: object.id)
        print("Selected coin is \(object.id)")
    }
    
    //MARK: - SetNavBar
    
    func setNavBar(){
        guard let object = selectedDetail else {return}
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = Colors.main
        navigationController?.navigationItem.leftBarButtonItem = .none
        self.navigationItem.title = object.name
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    //MARK: - Set segmented control
    
    func configureSegmentedControl(){
        let sc = UISegmentedControl(items: Constants.segmentedIntervals)
        sc.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = Colors.main
        segmentedControl.tintColor = .white
        sc.addTarget(self, action: #selector(handleSegmentChanged), for: .valueChanged)
        segmentedControl = sc
    }
    
    @objc fileprivate func handleSegmentChanged(){
        guard let object = selectedDetail else {return}
        
        switch segmentedControl.selectedSegmentIndex{
        case 1:
            graphManager.getHistoricalData(id: object.id, for: 1)
            manager.fetchDetails(object.id, 1)
        case 2:
            graphManager.getHistoricalData(id: object.id, for: 2)
            manager.fetchDetails(object.id, 2)
        case 3:
            graphManager.getHistoricalData(id: object.id, for: 3)
            manager.fetchDetails(object.id, 3)
        default:
            graphManager.getHistoricalData(id: object.id)
            manager.fetchDetails(object.id)
        }
    }
    
    //MARK: - Set loading view
    
    private func setLoadingView() {
        view.addSubview(loadingView)
        loadingView.backgroundColor = Colors.main
        activityIndicator.color = .lightGray
        activityIndicator.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        activityIndicator.hidesWhenStopped = true
                    loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    //MARK: - Handle bookmark button
    
    private func setLikeButton(){
        guard let object = selectedDetail else {return}
        
        self.likedButton = UIBarButtonItem(image: Constants.Images.heartFill, style: .plain, target: self, action: #selector(handleLikeButton))
        self.dislikedButton = UIBarButtonItem(image: Constants.Images.heart, style: .plain, target: self, action: #selector(handleDislikeButton))
        
        self.navigationItem.rightBarButtonItem = object.bookmarked ? self.likedButton : self.dislikedButton
    }
    
    @objc func handleLikeButton(_ sender: UIBarButtonItem){
        updateObject()
        self.navigationItem.setRightBarButton(self.dislikedButton, animated: false)
    }
    
    @objc func handleDislikeButton(_ sender: UIBarButtonItem){
        updateObject()
        self.navigationItem.setRightBarButton(likedButton, animated: false)
    }
    
    //MARK: - Update object in Realm
    
    private func updateObject(){
        let date = Date()
        guard let object = selectedDetail else {return}
        var switcher = object.bookmarked
        switcher = !switcher
        dataRepository.updateObject(object, with: ["bookmarked": switcher, "timeCreated": date])
        print("Updated item with \(switcher)")
    }
}

extension DetailViewController: DetailDelegate{
    func didUpdateData(_ manager: CryptoManager, detail: DetailModel, for periodIndex: Int) {
        
        let selectedCurrency = UserDefaults.standard.value(forKey: Constants.currencyKey) as? String
        guard let symbol = Constants.currencyDict[selectedCurrency ?? "usd"] else {return}
        
        DispatchQueue.main.async {
            do {
                let markedText = detail.info.convertHref()
                let text = try NSMutableAttributedString(markdown: markedText)
                let range = NSRange(location: 0, length: text.length)
                text.addAttributes([NSMutableAttributedString.Key.foregroundColor: UIColor.white, NSMutableAttributedString.Key.font: Fonts.smallNum], range: range)
                self.infoView.attributedText = text
            } catch {
                print(String(describing: error))
            }
            self.priceLabel.text = String(detail.price) + " \(symbol)"
            
            let value: Bool? = detail.percentage > 0 ? true : false
            
            switch value{
            case true:
                self.changeLabel.textColor = .green
                self.arrowLabel.tintColor = .green
                self.arrowLabel.image = Constants.Images.triangleUp
            case false:
                self.changeLabel.textColor = .red
                self.arrowLabel.tintColor = .red
                self.arrowLabel.image = Constants.Images.triangleDown
            default:
                self.changeLabel.textColor = .lightGray
            }
            self.changeLabel.text = String(format: "%.3f", detail.percentage) + " %"
            self.marketCap.text = detail.marketCap.formatUsingAbbrevation()
            
            guard let url = URL(string: self.selectedDetail?.imageUrl ?? "")  else {return}
            ImageService.getImage(withURL: url) { image in
                self.logoView.image = image
            }
        }
    }
}

extension DetailViewController: ChartDelegate, ChartViewDelegate{
    func drawChart(_ manager: GraphManager, model: HistoryModel) {
        DispatchQueue.main.async {
            let chartArray = model.coords
            let marker = ChartMarker()
            let set = LineChartDataSet(entries: chartArray)
            set.drawCirclesEnabled = false
            set.lineWidth = 1.5
            set.mode = .cubicBezier
            set.setColor(.yellow)
            
            let data = LineChartData(dataSet: set)
            data.setDrawValues(false)
            data.highlightEnabled = true
            self.chartView.data = data
            self.chartView.animate(xAxisDuration: 0.5)
            self.chartView.marker = marker
            self.activityIndicator.stopAnimating()
            self.loadingView.isHidden = true
        }
    }
}

//MARK: - Convert String fro markdown NSAttrStr
extension String {
    func convertHref() -> String{
        var str = self.trimmingCharacters(in: .whitespacesAndNewlines).filter {$0 != "\r"}
        let counter = str.components(separatedBy: " ").filter {$0.hasPrefix("href")}.count
        guard counter > 0 else {return str}
        for _ in 1...counter {
            cut()
        }
        
        func cut() {
            if let k = str.firstIndex(of: "<"), let j = str.firstIndex(of: ">") {
                let range =  k...j
                let link = "(" + str[range].filter {$0 != #"""#}.dropFirst(8).dropLast() + ")"
                str.replaceSubrange(range, with: String(repeating: "L", count: str[range].count))
                if let l = str.firstIndex(of: ">") {
                    let deleteRange = str.index(after: j)...l
                    let text = "[" + str[deleteRange].dropLast(4) + "]"
                    str.replaceSubrange(deleteRange, with: link)
                    str.replaceSubrange(range, with: text)
                }
            }
        }
        return str
    }
}
//MARK: - Format large Ints to String with abb.
extension Int {
    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()
        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, " K"),
                                           (100_000.0, 1_000_000.0, " M"),
                                           (100_000_000.0, 1_000_000_000.0, " B")]
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        
        guard let result = numFormatter.string(from: NSNumber (value:value)) else {
            return ""
        }
        return result
    }
}
