//
//  OilDetailViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/08/23.
//

import UIKit

class OilDetailViewController: UIViewController {

    @IBOutlet weak var oilDayLabel: UILabel!
    @IBOutlet weak var oilZonLabel: UILabel!
    @IBOutlet weak var oilKmLabel: UILabel!
    @IBOutlet weak var oilTypeLabel: UILabel!
    @IBOutlet weak var oilUnitLabel: UILabel!
    @IBOutlet weak var oilNumLabel: UILabel!
    @IBOutlet weak var oilDcLabel: UILabel!
    @IBOutlet weak var oilPriceLabel: UILabel!
    @IBOutlet weak var oilNoteTextView: UITextView!
    
    // 리스트 화면에서 전달받을 프로터티
    var oil: Oil?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()

    }
    
    // 프로퍼티를 통해 전달받을 객체를 뷰에 초기화
    private func configureView() {
        guard let oil = self.oil else { return }
        self.oilDayLabel.text = self.dateTostring(date: oil.oilday)
        self.oilZonLabel.text = oil.oilzon
        self.oilKmLabel.text = oil.oilkm
        self.oilTypeLabel.text = oil.oiltype
        self.oilUnitLabel.text = oil.oilunit
        self.oilNumLabel.text = oil.oilnum
        self.oilDcLabel.text = oil.oildc
        
        // 수량 소수점 입력은 되는데 계산이 안됨... + 최종금액 반올림, 버림 처리해야함 근데 흠... 둘다 될라나..? = 애초에 전부다 float 값을 만드는건?
        let oilunitint = Int(oil.oilunit)
        let oilnumdouble = Float(oil.oilnum)
        let oildcint = Int(oil.oildc)
        self.oilPriceLabel.text = String((oilunitint! * Int(oilnumdouble!)) - oildcint!)
    }
    
    // 문자열로 변환
    private func dateTostring(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy. MM. dd (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    
    @IBAction func tabEditButton(_ sender: Any) {
    }
    
    @IBAction func tabDeleteButton(_ sender: Any) {
    }
}
