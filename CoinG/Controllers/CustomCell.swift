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
    @IBOutlet weak var logoLabel: UIImageView!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        self.tintColor = UIColor(cgColor: CGColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1))
        
        changeLabel.textAlignment = .right
        valueLabel.textAlignment = .right
        
        [shortName, fullName].forEach {$0?.textColor = .white
            $0?.font = Fonts.cellFont}
        [valueLabel, changeLabel].forEach {$0?.font = Fonts.num
            $0?.textColor = .white
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.logoLabel.image = nil
    }
}

