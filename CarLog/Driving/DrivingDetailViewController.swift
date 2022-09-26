//
//  DrivingDetailViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/07/31.
//

import UIKit

// 델리게이트 : 통해서 상세화면에서 삭제가 일어날때 메서드를 통해 리스트를 인덱스패치를 전달해서
protocol DrivingDetailViewDelegate: AnyObject {
    func didSelectDelete(indexPath: IndexPath)
}

class DrivingDetailViewController: UIViewController {

    @IBOutlet weak var startDayLabel: UILabel!
    @IBOutlet weak var arrivalDayLabel: UILabel!
    @IBOutlet weak var drivingTimeLabel: UILabel!
    @IBOutlet weak var startAreaLabel: UILabel!
    @IBOutlet weak var arrivalAreaLabel: UILabel!
    @IBOutlet weak var startKmLabel: UILabel!
    @IBOutlet weak var arrivalKmLabel: UILabel!
    @IBOutlet weak var drivingKmLabel: UILabel!
    @IBOutlet weak var drivingReasonLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    weak var delegate: DrivingDetailViewDelegate?
    
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
    
    // 숫자 세자리마다 콤마 찍기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // 프로퍼티를 통해 전달받은 driving 객체를 View에 초기화
    private func configureView() {
        guard let driving = self.driving else { return }
        self.startDayLabel.text = self.dateTostring(date: driving.startday)
        self.arrivalDayLabel.text = self.dateTostring(date: driving.arrivalday)
        self.startAreaLabel.text = driving.startarea
        self.arrivalAreaLabel.text = driving.arrivalarea
        let startkmint = Int(driving.startkm)
        self.startKmLabel.text = numberFormatter(number: startkmint!)
        let arrivalkmint = Int(driving.arrivalkm)
        self.arrivalKmLabel.text = numberFormatter(number: arrivalkmint!)
        self.drivingReasonLabel.text = driving.drivingreason
        self.noteTextView.text = driving.note
        
        let drivingtime = Int(driving.arrivalday.timeIntervalSince(driving.startday))
        self.drivingTimeLabel.text = String(drivingtime / 60)
        
        let drivingkm = arrivalkmint! - startkmint!
        self.drivingKmLabel.text = numberFormatter(number: drivingkm)
    }
    
    // 문자열로 변환
    private func dateTostring(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    // selector 함수 정의
    @objc func editDrivingNotification(_ notification: Notification) {
        guard let driving = notification.object as? Driving else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.driving = driving
        self.configureView()
    }
    
    // 수정 버튼 클릭 시
    @IBAction func tabEditButton(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DrivingWriteUIViewController") as? DrivingWriteViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let driving = self.driving else { return }
        viewController.drivingEditorMode = .edit(indexPath, driving)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDrivingNotification(_:)),
            name: NSNotification.Name("editDriving"),
            object: nil
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // 삭제 버튼 클릭 시
    @IBAction func tabDeleteButton(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
