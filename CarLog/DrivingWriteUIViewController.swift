//
//  DrivingWriteUIViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/07/31.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNoteTextview()
        self.configureStartDayPicker()
        self.configureArrivalDayPicker()
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
    
    @IBAction func tabSaveButton(_ sender: Any) {
    }
    
    // startDayPicker
    @objc private func startdayPickerValueDidChange(_ startDayPicker: UIDatePicker) {
        let formmater = DateFormatter()
        formmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        formmater.locale = Locale(identifier: "ko_KR")
        self.startDay = startDayPicker.date
        self.startDayTextfield.text = formmater.string(from: startDayPicker.date)
    }
    
    // arrivalDayPicker
    @objc private func arrivaldayPickerValueDidChange(_ arrivalDayPicker: UIDatePicker) {
        let formmater = DateFormatter()
        formmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        formmater.locale = Locale(identifier: "ko_KR")
        self.arrivalDay = arrivalDayPicker.date
        self.arrivalDayTextfield.text = formmater.string(from: arrivalDayPicker.date)
    }
}
