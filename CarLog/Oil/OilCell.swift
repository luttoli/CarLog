//
//  OilCell.swift
//  CarLog
//
//  Created by 김지훈 on 2022/08/23.
//

import UIKit

class OilCell: UICollectionViewCell {
    
    @IBOutlet weak var oilDayLabel: UILabel!
    @IBOutlet weak var oliZonLabel: UILabel!
    @IBOutlet weak var oilKmLabel: UILabel!
    @IBOutlet weak var oilTypeLabel: UILabel!
    @IBOutlet weak var oilUnitLabel: UILabel!
    @IBOutlet weak var oilNumLabel: UILabel!
    @IBOutlet weak var oilPriceLabel: UILabel!
    @IBOutlet weak var oilMileageLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
