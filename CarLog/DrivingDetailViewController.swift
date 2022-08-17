//
//  DrivingDetailViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/07/31.
//

import UIKit

class DrivingDetailViewController: UIViewController {

    @IBOutlet weak var startdayLable: UILabel!
    @IBOutlet weak var arrivaldayLable: UILabel!
    @IBOutlet weak var drivingtimeLable: UILabel!
    @IBOutlet weak var startareaLable: UILabel!
    @IBOutlet weak var arrivalareaLable: UILabel!
    @IBOutlet weak var startkmLable: UILabel!
    @IBOutlet weak var arrivalkmLable: UILabel!
    @IBOutlet weak var drivingkmLable: UILabel!
    @IBOutlet weak var drivingreasonLable: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    // 전달받을 프로퍼티
    var driving: Driving?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        configureNoteTextview()
    }
    
    private func configureNoteTextview() {
        let borderColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1.0)
        self.noteTextView.layer.borderColor = borderColor.cgColor
        self.noteTextView.layer.borderWidth = 2
        self.noteTextView.layer.cornerRadius = 5.0
    }
    
    // 프로퍼티를 통해 전달받은 driving 객체를 View에 초기화
    private func configureView() {
        guard let driving = self.driving else { return }
        self.startdayLable.text = self.dateTostring(date: driving.startday)
        self.arrivaldayLable.text = self.dateTostring(date: driving.arrivalday)
        self.startareaLable.text = driving.startarea
        self.arrivalareaLable.text = driving.arrivalarea
        self.startkmLable.text = driving.startkm
        self.arrivalkmLable.text = driving.arrivalkm
        self.drivingreasonLable.text = driving.drivingreason
        self.noteTextView.text = driving.note
    }
    
    private func dateTostring(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @IBAction func tabEditButton(_ sender: Any) {
    }
    
    @IBAction func tabDeleteButton(_ sender: Any) {
    }
    
}
