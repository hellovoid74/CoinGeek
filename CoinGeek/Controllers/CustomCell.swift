//
//  CustomCell.swift
//  CoinGeek
//
//  Created by Gleb Lanin on 01/02/2022.
//

import UIKit
import SnapKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var logoLabel: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // self.frame.size.height = 180
        self.backgroundColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        self.tintColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        //shortName.text = "LOL"
        [shortName, fullName, valueLabel, currencyLabel].forEach {$0?.textColor = .white
            $0?.font = UIFont(name: "ChalkboardSE-Light", size: 15)}
        
        // Initialization code
        setLabels()
    }
    
    
    func setLabels() {
       shortName.text = "chisto lol"
        currencyLabel.text = "$"
        valueLabel.text = "50"
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

