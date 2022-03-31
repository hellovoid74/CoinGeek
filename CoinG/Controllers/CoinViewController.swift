//
//  ViewController.swift
//  CoinG
//
//  Created by Gleb Lanin on 12/03/2022.
//
//  CoinViewController.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 01/02/2022.
//
import UIKit
import SnapKit
import RealmSwift
import Combine

class CoinViewController: UIViewController{
    
    private var currenciesToDisplay: Results<CoinObject>?
    private var favCurrenices: Results<CoinObject>?
    private let manager = CryptoManager()
    private let dataRepository = DataRepository()
    private var tableView = UITableView()
    private var segmentedControl = UISegmentedControl()
    
    private var picker = PickerView()
    private var currencyToken: NotificationToken?
    
    @Published private var isSegmentEnabled: Bool = false
    private var subscriptions: AnyCancellable?
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currencyToken?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSegmentEnabled = dataRepository.loadFavouriteObjects().first == nil ? false : true
        currenciesToDisplay = segmentedControl.selectedSegmentIndex == 1 ? dataRepository.loadFavouriteObjects() : dataRepository.loadTopobjects()
        observeChanges()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        dataRepository.printLocation()
        //dataRepository.removeOldData()
        fetchAPIData()
        configureSegmentedControl()
        configureTable()
        configureUI()
        setNavBar()
        setBinding()
    }
    
    //MARK: - Receive new data from API
    
    func fetchAPIData(){
        manager.performRequests()
        currenciesToDisplay = dataRepository.loadTopobjects()
    }
    
    //MARK: - Observe changes
    
    func observeChanges() {
        currencyToken = currenciesToDisplay?.observe { [unowned self] changes in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .none)
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .none)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .none)
                self.tableView.endUpdates()
            case .error(let err):
                fatalError("\(err)")
            }
        }
    }
    
    //MARK: - Set TableView
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Colors.main
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    //MARK: - Set segmented control
    
    func configureSegmentedControl() {
        segmentedControl = UISegmentedControl(items: Constants.segmentedValues)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.selectedSegmentTintColor = Colors.side
        segmentedControl.addTarget(self, action: #selector(handleSegmentChanged), for: .valueChanged)
    }
    
    @objc fileprivate func handleSegmentChanged() {
        currencyToken?.invalidate()
        
        switch segmentedControl.selectedSegmentIndex{
        case 1:
            currenciesToDisplay = dataRepository.loadFavouriteObjects()
        default:
            currenciesToDisplay = dataRepository.loadTopobjects()
        }
        observeChanges()
        self.tableView.reloadData()
        
    }
    
    //MARK: - Enable/disable segmentedElement if there are favourites
    
    private func setBinding() {
        subscriptions = $isSegmentEnabled
            .sink(receiveValue: {[unowned self] value in
                self.segmentedControl.setEnabled(value, forSegmentAt: 1)
                if value == false {
                    self.segmentedControl.selectedSegmentIndex = 0
                }
            })
    }
    
    //MARK: - Set Up Navigation Bar
    
    func setNavBar() {
        
        let rightBarButton = UIBarButtonItem(image: Constants.Images.list, style: .plain, target: self, action: #selector(searchTapped))
        let switchBarButton = UIBarButtonItem(image: Constants.Images.globe, style: .plain, target: self, action: #selector(changeCurrencypressed))
        let calcBarButton = UIBarButtonItem(image: Constants.Images.calc, style: .plain, target: self, action: #selector(openCalc))
        
        self.navigationItem.rightBarButtonItems = [rightBarButton, switchBarButton]
        self.navigationItem.leftBarButtonItem = calcBarButton
        self.navigationItem.title = "CoinGeek"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.main
        appearance.titleTextAttributes = [.foregroundColor: Colors.side]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    //MARK: - Handle pressed List button
    
    @objc fileprivate func searchTapped(){
        
        performSegue(withIdentifier: Constants.toListId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.toCoinVC {
            let destinationVC = segue.destination as! DetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedDetail = currenciesToDisplay?[indexPath.row]
            }
        }
    }
    
    //MARK: - Handle change currency
    
    @objc fileprivate func changeCurrencypressed(){
        picker.addAlert(on: self)
    }
    
    @objc fileprivate func openCalc() {
        let calc = CalculatorViewController()
        if let sheet = calc.presentationController as? UISheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(calc, animated: true)
    }
    
    //MARK: - Set up UI elements
    
    func configureUI(){
        
        view.backgroundColor = Colors.main
        
        let infoLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.font = Fonts.mainFont
            label.text = Constants.welcomeText
            
            return label
        }()
        
        let logoImage = Constants.Images.logo ?? .none
        
        let logoImageView: UIImageView = {
            let imgView = UIImageView()
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            imgView.layer.cornerRadius = 75
            imgView.image = logoImage
            imgView.center = view.center
            
            return imgView
        }()
        
        [infoLabel, logoImageView, tableView, segmentedControl].forEach {view.addSubview($0)}
        
        infoLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(logoImageView.snp.bottom)
            $0.height.equalTo(40)
            $0.width.equalTo(300)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.centerX.equalTo(self.view)
            make.top.equalTo(view.safeArea.top).offset(3)
            make.width.equalTo(150)
        }
        
        tableView.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(300)
            $0.bottom.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints {
            $0.bottom.equalTo(tableView.snp.top)
            $0.width.equalTo(view.snp.width).multipliedBy(0.9)
            $0.height.equalTo(40)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
}

//MARK: - Tableview Datasource and Delegate methods
extension CoinViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell else {
            fatalError()
        }
        cell.isUserInteractionEnabled = true
        cell.selectionStyle = .none
        
        let crypto = currenciesToDisplay?[indexPath.row]
        
        DispatchQueue.main.async {
            
            let value: Bool? = crypto?.change24h ?? 0 > 0 ? true : false
            
            switch value{
            case true:
                cell.changeLabel.textColor = .green
                cell.arrowImage.tintColor = .green
                cell.arrowImage.image = Constants.Images.triangleUp
            case false:
                cell.changeLabel.textColor = .red
                cell.arrowImage.tintColor = .red
                cell.arrowImage.image = Constants.Images.triangleDown
            default:
                cell.changeLabel.textColor = .lightGray
            }
            
            let selectedCurrency = UserDefaults.standard.string(forKey: Constants.currencyKey)
            let symbol = Constants.currencyDict[selectedCurrency ?? "usd"]!
            
            cell.shortName.text = crypto?.symbol.uppercased()
            cell.valueLabel.text = String(format: "%.2f", crypto?.price ?? "") + " \(symbol)"
            cell.fullName.text = String(describing: crypto?.name ?? "")
            cell.changeLabel.text = String(format: "%.2f", crypto?.change24h ?? "") + " %"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = currenciesToDisplay?.count else {return 0}
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            return dataRepository.loadFavouriteObjects().count
        default:
            return dataRepository.loadTopobjects().count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.toCoinVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? CustomCell else { return }
        guard let object = currenciesToDisplay?[indexPath.row] else {return}
        guard let url = URL(string: object.imageUrl) else {return}
        
        cell.logoLabel.image = nil
        ImageService.getImage(withURL: url) { image in
            cell.logoLabel.image = image
        }
    }
}

extension UIView {
    var safeArea : ConstraintLayoutGuideDSL {
        return safeAreaLayoutGuide.snp
    }
}


