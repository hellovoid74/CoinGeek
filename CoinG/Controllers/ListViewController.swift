//
//  SearchTableViewController.swift
//  CoinG
//
//  Created by Gleb Lanin on 12/03/2022.
//
//
//  SearchViewController.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 01/02/2022.
//
import UIKit
import RealmSwift

class ListViewController: UITableViewController {
    
    private let searchBar = UISearchBar()
    
    private var currencies: Results<CoinObject>?
    private var temp: Results<CoinObject>?
    private let manager = CryptoManager()
    private let dataRepository = DataRepository()
    private let imageService = ImageService()
    
    override func viewWillDisappear(_ animated: Bool) {
        search(shouldShow: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        loadData()
        setSearchBar()
        setNavBar()
        setRefreshControl()
        search(shouldShow: false)
    }
    
    func loadData() {
        currencies = dataRepository.loadObjects()
        temp = currencies
        tableView.reloadData()
    }
    
    //MARK: - Configure tableView
    
    func configureTable(){
        let cellNib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? CustomCell else { return }
        guard let object = currencies?[indexPath.row] else {return}
        guard let url = URL(string: object.imageUrl) else {return}
        
        ImageService.getImage(withURL: url) { image in
            cell.logoLabel.image = image
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let destinationVC = segue.destination as! DetailViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedDetail = currencies?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currencies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell else {
            fatalError()
        }
        cell.isUserInteractionEnabled = true
        cell.selectionStyle = .none
        
        let crypto = currencies?[indexPath.row]
        
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
            guard let symbol = Constants.currencyDict[selectedCurrency ?? "usd"] else {return}
            
            cell.shortName.text = crypto?.symbol.uppercased()
            cell.valueLabel.text = String(format: "%.2f", crypto?.price ?? "") + " \(symbol)"
            cell.fullName.text = crypto?.name
            cell.changeLabel.text = String(format: "%.2f", crypto?.change24h ?? "") + " %"
            
        }
        return cell
    }
    
    
    //MARK: - SetNavBar
    func setNavBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = .white
        navigationController?.navigationItem.leftBarButtonItem = .none
        self.navigationItem.title = Constants.markets
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Colors.main
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
    }
    //MARK: - Set up SearchBar
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.frame.size.height = 40
        searchBar.sizeToFit()
        searchBar.searchTextField.backgroundColor = .white
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                target: self,
                                                                action: #selector(handleShowSearchBar))
            navigationItem.setHidesBackButton(false, animated: false)
        } else {
            navigationItem.rightBarButtonItem = nil
            navigationItem.setHidesBackButton(true, animated: false)
        }
    }
    
    func search(shouldShow: Bool){
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
    @objc func handleShowSearchBar(){
        searchBar.becomeFirstResponder()
        search(shouldShow: true)
    }
    
    //MARK: - Handle refresh control
    func setRefreshControl(){
        view.backgroundColor = Colors.main
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl(){
        tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        currencies = currencies?.filter("name CONTAINS[cd] %a", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
        } else {
            currencies = temp?.filter("name CONTAINS[cd] %a", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
        currencies = temp
        searchBar.searchTextField.text = ""
        tableView.reloadData()
    }
}

//extension UIImageView {
//    public func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//            else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
//}
