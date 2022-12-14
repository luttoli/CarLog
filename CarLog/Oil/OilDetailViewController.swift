//
//  OilDetailViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/08/23.
//

import UIKit

// 델리게이트를 통해서 상세화면에서 삭제가 될때 메서드를 통해 리스트 화면에 인덱스페치를 전달해서 리스트배열과 컬렉션뷰에 삭제되게
protocol OilDetailViewDelegate: AnyObject {
    func didSelectDelete(indexPath: IndexPath)
}

class OilDetailViewController: UIViewController {

    @IBOutlet weak var oilDayLabel: UILabel!
    @IBOutlet weak var oilZonLabel: UILabel!
    @IBOutlet weak var oilKmLabel: UILabel!
    @IBOutlet weak var oilTypeLabel: UILabel!
    @IBOutlet weak var oilUnitLabel: UILabel!
    @IBOutlet weak var oilNumLabel: UILabel!
    @IBOutlet weak var oilPriceLabel: UILabel!
    @IBOutlet weak var oilNoteTextView: UITextView!
    
    // 프로퍼티 선언
    weak var delegate: OilDetailViewDelegate?
    
    // 리스트 화면에서 전달받을 프로터티
    var oil: Oil?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        configureNoteTextview()

    }
    
    // 비고
    private func configureNoteTextview() {
        let borderColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1.0)
        self.oilNoteTextView.layer.borderColor = borderColor.cgColor
        self.oilNoteTextView.layer.borderWidth = 2
        self.oilNoteTextView.layer.cornerRadius = 5.0
    }
    
    // 숫자 세자리마다 콤마 찍기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // 프로퍼티를 통해 전달받을 객체를 뷰에 초기화
    private func configureView() {
        guard let oil = self.oil else { return }
        self.oilDayLabel.text = self.dateTostring(date: oil.oilday)
        self.oilZonLabel.text = oil.oilzon
        let oilkmint = Int(oil.oilkm)
        self.oilKmLabel.text = numberFormatter(number: oilkmint!)
        self.oilTypeLabel.text = oil.oiltype
        let oilunitint = Int(oil.oilunit)
        self.oilUnitLabel.text = numberFormatter(number: oilunitint!)
        self.oilNumLabel.text = oil.oilnum
        let oilpriceint = Int(oil.oilprice)
        self.oilPriceLabel.text = numberFormatter(number: oilpriceint!)
        self.oilNoteTextView.text = oil.oilnote
    }
    
    // 문자열로 변환
    private func dateTostring(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy. MM. dd (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func editOilNOtification(_ notification: Notification) {
        guard let oil = notification.object as? Oil else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.oil = oil
        self.configureView()
    }
    
    // 수정
    @IBAction func tabEditButton(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "OilWriteViewController") as? OilWriteViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let oil = self.oil else { return }
        viewController.oilEditorMode = .edit(indexPath, oil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editOilNOtification(_:)),
            name: NSNotification.Name("editOil"),
            object: nil
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // 삭제
    @IBAction func tabDeleteButton(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
