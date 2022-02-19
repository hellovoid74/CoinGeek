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

    private let manager = CryptoManager()
    private let dataRepository = DataRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataRepository.removeOldData()
        configureUI()
        setNavBar()
        fetchAPIData()
    }
    
    //MARK: - Set up UI elements
    
    func configureUI() {
        
        view.backgroundColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        
        let infoLabel: UILabel = {
            let label = UILabel()
            label.frame.size.width = 300
            label.frame.size.height = 40
            label.numberOfLines = 0
            label.textColor = .white
            label.font = Fonts.mainFont
            label.text = Constants.welcomeText
            
            return label
        }()
        
        let lowerLabel: UILabel = {
            let label = UILabel()
            label.frame.size.width = 300
            label.frame.size.height = 20
            label.numberOfLines = 0
            label.textColor = .white
            label.font = Fonts.lightFont
            label.text = Constants.descriptionText
            
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
    
    
    //MARK: - Set Up Navigation Bar
    
    func setNavBar() {
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(searchTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.isTranslucent = false

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // With a red background, make the title more readable.
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
    }
    
    //MARK: - Remove old data and receive new one from API
    
    func fetchAPIData() {
    
        manager.fetchData()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)  //realm database location
    }
    
    //MARK: - Method for pressed search button
    
    @objc func searchTapped() {
        performSegue(withIdentifier: Constants.toSearchIdentifier, sender: self)
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

