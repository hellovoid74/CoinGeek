//
//  SearchViewController.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 01/02/2022.
//

import UIKit
import RealmSwift

class SearchViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currencies: Results<CoinObjects>?
    var logos: Results<LogoObjects>?
    
    let realm = try! Realm()
    let manager = CryptoManager()
    var array = [CoinData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        view.backgroundColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        searchBar.barTintColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        searchBar.searchTextField.backgroundColor = .white
        
        loadData()
        setNavBar()
        
        let cellNib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
    }
    
    func loadData() {
        
        currencies = realm.objects(CoinObjects.self)
        logos = realm.objects(LogoObjects.self)
        
        print(currencies?.count)
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currencies?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell else {
            fatalError()
        }
        
        cell.isUserInteractionEnabled = false
        
        let crypto = currencies?[indexPath.row]
        
        DispatchQueue.main.async {
            
            cell.shortName.text = crypto?.id
            cell.valueLabel.text = String(String(format: "%.4f", crypto?.price ?? 0))
            cell.fullName.text = crypto?.name
            cell.currencyLabel.text = "$"
            cell.logoLabel.image = UIImage(named: crypto?.id ?? "")
            if cell.logoLabel.image == nil {
                cell.logoLabel.image = UIImage(named: "UNI")
            }
        }
        return cell
    }
    
    
    
    //MARK: - SetNavBar
    
    func setNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        // navigationController?.navigationBar.barTintColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // With a red background, make the title more readable.
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
    }
    
    
    
    //MARK: - Set up SearchBar
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        currencies = currencies?.filter("name CONTAINS[cd] %a", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

extension String {
    func shorten() -> String {
        guard let value = Float(self) else {return ""}
        
        return String(format: "%.5f", value)
    }
}



