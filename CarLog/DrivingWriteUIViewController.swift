//
//  DrivingWriteUIViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/07/31.
//

import UIKit

// 델리게이트 통해서 운행일지 리스트 화면에 객체를 전달
protocol DrivingWriteViewDelegate: AnyObject {
    func didSelectReigster(driving: Driving)
}

class DrivingWriteUIViewController: UIViewController {

    @IBOutlet weak var startDayTextfield: UITextField!
    @IBOutlet weak var arrivalDayTextfield: UITextField!
    @IBOutlet weak var drivingTimeLabel: UILabel!
    @IBOutlet weak var startAreaTextfield: UITextField!
    @IBOutlet weak var arrivalAreaTextfield: UITextField!
    @IBOutlet weak var startKmTextfield: UITextField!
    @IBOutlet weak var arrivalKmTextfield: UITextField!
    @IBOutlet weak var drivingKmLabel: UILabel!
    @IBOutlet weak var drivingReasonTextfield: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // 출발, 도착 날짜 TextField 클릭 시 날짜를 고르게
    private let startDayPicker = UIDatePicker()
    private var startDay: Date?
    private let arrivalDayPicker = UIDatePicker()
    private var arrivalDay: Date?
    
    // 프로포티 정의
    weak var delegate: DrivingWriteViewDelegate?
    
    // 처음에 노출되는 주행 시간
    var drivingtime: String = "0분"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNoteTextview()
        self.configureStartDayPicker()
        self.configureArrivalDayPicker()
        self.configureInputField()
        self.saveButton.isEnabled = false // 처음에 진입 시 입력이 하나도 안되어있을테니 비활성화 처리
    }
    
    // Textview border
    private func configureNoteTextview() {
        let borderColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1.0)
        self.noteTextView.layer.borderColor = borderColor.cgColor
        self.noteTextView.layer.borderWidth = 2
        self.noteTextView.layer.cornerRadius = 5.0
    }
    
    // startDayPicker
    private func configureStartDayPicker() {
        self.startDayPicker.datePickerMode = .dateAndTime
        self.startDayPicker.preferredDatePickerStyle = .wheels
        self.startDayPicker.addTarget(self, action: #selector(startdayPickerValueDidChange(_:)), for: .valueChanged)
        self.startDayPicker.locale = Locale(identifier: "ko-KR")
        self.startDayTextfield.inputView = self.startDayPicker
    }
    
    // arrivalDayPicker
    private func configureArrivalDayPicker() {
        self.arrivalDayPicker.datePickerMode = .dateAndTime
        self.arrivalDayPicker.preferredDatePickerStyle = .wheels
        self.arrivalDayPicker.addTarget(self, action: #selector(arrivaldayPickerValueDidChange(_:)), for: .valueChanged)
        self.arrivalDayPicker.locale = Locale(identifier: "ko-KR")
        self.arrivalDayTextfield.inputView = self.arrivalDayPicker
    }
    
    //
    private func configureInputField() {
        self.startDayTextfield.addTarget(self, action: #selector(startDayTextfieldDidChange(_:)), for: .editingChanged)
        self.arrivalDayTextfield.addTarget(self, action: #selector(arrivalDayTextfieldDidChange(_:)), for: .editingChanged)
        self.startAreaTextfield.addTarget(self, action: #selector(startAreaTextfieldDidChange(_:)), for: .editingChanged)
        self.arrivalAreaTextfield.addTarget(self, action: #selector(arrivalAreaTextfieldDidChange(_:)), for: .editingChanged)
        self.startKmTextfield.addTarget(self, action: #selector(startKmTextfieldDidChange(_:)), for: .editingChanged)
        self.arrivalKmTextfield.addTarget(self, action: #selector(arrivalKmTextfieldDidChange(_:)), for: .editingChanged)
        self.drivingReasonTextfield.addTarget(self, action: #selector(drivingReasonTextfieldDidChange(_:)), for: .editingChanged)
        self.noteTextView.delegate = self
    }
    
    // save버튼 클릭 시 driving 객체를 생성해서 넘김
    @IBAction func tabSaveButton(_ sender: UIBarButtonItem) {
        guard let startday = self.startDay else { return }
        guard let arrivalday = self.arrivalDay else { return }
        guard let startarea = self.startAreaTextfield.text else { return }
        guard let arrivalarea = self.arrivalAreaTextfield.text else { return }
        guard let startkm = self.startKmTextfield.text else { return }
        guard let arrivalkm = self.arrivalKmTextfield.text else { return }
        guard let drivingreason = self.drivingReasonTextfield.text else { return }
        guard let note = noteTextView.text else { return }
        let driving = Driving(startday: startday, arrivalday: arrivalday, startarea: startarea, arrivalarea: arrivalarea, startkm: startkm, arrivalkm: arrivalkm, drivingreason: drivingreason, note: note)
        self.delegate?.didSelectReigster(driving: driving)
        self.navigationController?.popViewController(animated: true) // 화면을 전환한다
    }
    
    // startDayPicker
    @objc private func startdayPickerValueDidChange(_ startDayPicker: UIDatePicker) {
        let startformmater = DateFormatter()
        startformmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        startformmater.locale = Locale(identifier: "ko_KR")
        self.startDay = startDayPicker.date
        self.startDayTextfield.text = startformmater.string(from: startDayPicker.date)
        self.startDayTextfield.sendActions(for: .editingChanged)
    }
    
    // arrivalDayPicker
    @objc private func arrivaldayPickerValueDidChange(_ arrivalDayPicker: UIDatePicker) {
        let arrivalformmater = DateFormatter()
        arrivalformmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        arrivalformmater.locale = Locale(identifier: "ko_KR")
        self.arrivalDay = arrivalDayPicker.date
        self.arrivalDayTextfield.text = arrivalformmater.string(from: arrivalDayPicker.date)
        self.arrivalDayTextfield.sendActions(for: .editingChanged)
    }
    
    // 모든 항목의 텍스트가 입력될때마다 호출되는 메소드
    @objc private func startDayTextfieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func arrivalDayTextfieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func startAreaTextfieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func arrivalAreaTextfieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func startKmTextfieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func arrivalKmTextfieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func drivingReasonTextfieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    // 빈 화면 클릭 시 닫힘처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 등록버튼에 활성화 여부를 판단하는 메서드
    private func validateInputField() {
        self.saveButton.isEnabled = !(self.startDayTextfield.text?.isEmpty ?? true) && !(self.arrivalDayTextfield.text?.isEmpty ?? true) && !(self.startAreaTextfield.text?.isEmpty ?? true) && !(self.arrivalAreaTextfield.text?.isEmpty ?? true) && !(startKmTextfield.text?.isEmpty ?? true) && !(self.arrivalKmTextfield.text?.isEmpty ?? true) && !(self.drivingReasonTextfield.text?.isEmpty ?? true) && !self.noteTextView.text.isEmpty
    }
}

// textview에 text가 입력될 때 마다 호출되는 메서드
extension DrivingWriteUIViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
