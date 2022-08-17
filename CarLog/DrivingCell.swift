//
//  DrivingCell.swift
//  CarLog
//
//  Created by 김지훈 on 2022/07/31.
//

import UIKit

class DrivingCell: UICollectionViewCell {
    
    @IBOutlet weak var startDayLabel: UILabel!
    @IBOutlet weak var arrivalDayLabel: UILabel!
    @IBOutlet weak var drivingTimeLabel: UILabel!
    @IBOutlet weak var startAreaLabel: UILabel!
    @IBOutlet weak var arrivalAreaLabel: UILabel!
    @IBOutlet weak var drivingReason: UILabel!
    @IBOutlet weak var startKmLabel: UILabel!
    @IBOutlet weak var arrivalKmLabel: UILabel!
    @IBOutlet weak var drivingKmLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
