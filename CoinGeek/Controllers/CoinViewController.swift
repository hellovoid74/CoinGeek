//
//  CoinViewController.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 01/02/2022.
//

import UIKit
import SnapKit
import RealmSwift

class CoinViewController: UIViewController {
    
    let realm = try! Realm()
    let helper = Helper()
    
    let manager = CryptoManager()
    var logos: Results<LogoObjects>?
    var coins: Results<CoinObjects>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        //realm database location
    
        setUp()
        setNavBar()
        getData()
        
    }
    
    
    func getData() {

        manager.removeOldData()
        manager.fetchData()

    }
    

    
    //MARK: - Set up elements
    
    func setUp() {
        
        view.backgroundColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        
        let infoLabel: UILabel = {
            let label = UILabel()
            label.frame.size.width = 300
            label.frame.size.height = 40
            label.numberOfLines = 0
            //label.backgroundColor = .none
            label.textColor = .white
            label.font = UIFont(name: "ChalkboardSE-Regular", size: 30)
            label.text = "Welcome to CoinGeek"
            
            return label
        }()
        
        let lowerLabel: UILabel = {
            let label = UILabel()
            label.frame.size.width = 300
            label.frame.size.height = 20
            label.numberOfLines = 0
            //label.backgroundColor = .none
            label.textColor = .white
            label.font = UIFont(name: "ChalkboardSE-Light", size: 20)
            label.text = "Your ultimate crypto helper"
            
            return label
        }()
        
        
        let logoImage = UIImage(named: "wallet")
        
        let logoImageView: UIImageView = {
            let imgView = UIImageView()
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            imgView.layer.cornerRadius = 75
            imgView.image = logoImage
            imgView.center = view.center
            
            return imgView
        }()
        
        [infoLabel, logoImageView, lowerLabel].forEach {view.addSubview($0)}
        
        infoLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(logoImageView.snp.bottom)
        }
        
        lowerLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(infoLabel.snp.bottom)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.centerX.equalTo(self.view)
            make.top.equalToSuperview().inset(50)
            make.width.equalTo(150)
        }
    }
    
    
    //MARK: Navigation Bar Settings
    
    func setNavBar() {
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(searchTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.isTranslucent = false
        // navigationController?.navigationBar.barTintColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // With a red background, make the title more readable.
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
    }
    
    @objc func searchTapped() {
        performSegue(withIdentifier: "toSearch", sender: self)
    }

}


extension UIViewController {
    func navBar() {
        navigationController?.navigationBar.tintColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
    }
}

extension UIView {
    var safeArea : ConstraintLayoutGuideDSL {
        return safeAreaLayoutGuide.snp
    }
}

