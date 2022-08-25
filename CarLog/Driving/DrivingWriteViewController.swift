//
//  DrivingWriteUIViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/07/31.
//

import UIKit

//
enum DrivingEditorMode {
    case new
    case edit(IndexPath, Driving)
}

// 델리게이트 통해서 운행일지 리스트 화면에 객체를 전달
protocol DrivingWriteViewDelegate: AnyObject {
    func didSelectReigster(driving: Driving)
}

class DrivingWriteViewController: UIViewController {

    @IBOutlet weak var startDayTextField: UITextField!
    @IBOutlet weak var arrivalDayTextField: UITextField!
    @IBOutlet weak var startAreaTextField: UITextField!
    @IBOutlet weak var arrivalAreaTextField: UITextField!
    @IBOutlet weak var startKmTextField: UITextField!
    @IBOutlet weak var arrivalKmTextField: UITextField!
    @IBOutlet weak var drivingReasonTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // 출발, 도착 날짜 TextField 클릭 시 날짜를 고르게
    private let startDayPicker = UIDatePicker()
    private var startDay: Date?
    private let arrivalDayPicker = UIDatePicker()
    private var arrivalDay: Date?
    
    // 프로퍼티 정의
    weak var delegate: DrivingWriteViewDelegate?
    
    // 드라이빙에디터 모드를 저장하는 프로퍼티 정의
    var drivingEditorMode: DrivingEditorMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNoteTextview()
        self.configureStartDayPicker()
        self.configureArrivalDayPicker()
        startareaToolbar()
        arrivalareaToolbar()
        startkmToolbar()
        arrivalkmToolbar()
        drivingreasonToolbar()
        noteToolbar()
        self.configureInputField()
        self.configureEditMode()
        self.saveButton.isEnabled = false // 처음에 진입 시 입력이 하나도 안되어있을테니 비활성화 처리
    }
    
    //
    private func configureEditMode() {
        switch self.drivingEditorMode {
        case let .edit(_, driving):
            self.startDayTextField.text = self.dateTostring(date: driving.startday)
            self.arrivalDayTextField.text = self.dateTostring(date: driving.arrivalday)
            self.startDay = driving.startday
            self.arrivalDay = driving.arrivalday
            self.startAreaTextField.text = driving.startarea
            self.arrivalAreaTextField.text = driving.arrivalarea
            self.startKmTextField.text = driving.startkm
            self.arrivalKmTextField.text = driving.arrivalkm
            self.drivingReasonTextField.text = driving.drivingreason
            self.noteTextView.text = driving.note
            self.saveButton.title = "수정"
            
        default:
            break
        }
    }
    
    private func dateTostring(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    // Textview border
    private func configureNoteTextview() {
        let borderColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1.0)
        self.noteTextView.layer.borderColor = borderColor.cgColor
        self.noteTextView.layer.borderWidth = 2
        self.noteTextView.layer.cornerRadius = 5.0
    }
    
    // 출발일시 날짜 피커뷰 꾸미기
    private func configureStartDayPicker() {
        self.startDayPicker.datePickerMode = .dateAndTime
        self.startDayPicker.preferredDatePickerStyle = .wheels
        self.startDayPicker.addTarget(self, action: #selector(startdayPickerValueDidChange(_:)), for: .valueChanged)
        self.startDayPicker.locale = Locale(identifier: "ko-KR")
        self.startDayTextField.inputView = self.startDayPicker
        
        let startdayToolbar = UIToolbar()
        startdayToolbar.barStyle = UIBarStyle.default
        startdayToolbar.isTranslucent = true
        startdayToolbar.sizeToFit()
        
        let startdaySelectBT = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.startdaytoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let startdayNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.startdaytoolbarNext))
        let startdayBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.startdaytoolbarBefore))
        
        startdayToolbar.setItems([startdayBeforeBT,startdayNextBT,flexibleSpace,startdaySelectBT], animated: false)
        startdayToolbar.isUserInteractionEnabled = true
        
        startDayTextField.inputAccessoryView = startdayToolbar
    }
    
    // 출발일시 날짜 피커뷰의 addtarget의 selector / 형식 전달하기
    @objc private func startdayPickerValueDidChange(_ startDayPicker: UIDatePicker) {
        let startdayformmater = DateFormatter()
        startdayformmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        startdayformmater.locale = Locale(identifier: "ko_KR")
        self.startDay = startDayPicker.date
        self.startDayTextField.text = startdayformmater.string(from: startDayPicker.date)
        self.startDayTextField.sendActions(for: .editingChanged)
    }
    
    // 출발일시 날짜 피커뷰 툴바 선택 버튼
    @objc func startdaytoolbarSelect(_ datePicker: UIDatePicker) {
        let startdayformmater = DateFormatter()
        startdayformmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        startdayformmater.locale = Locale(identifier: "ko_KR")
        self.startDay = startDayPicker.date
        self.startDayTextField.text = startdayformmater.string(from: startDayPicker.date)
        self.startDayTextField.sendActions(for: .editingChanged)
        self.startDayTextField.resignFirstResponder()
    }
    
    // 출발일시 날짜 피커뷰 툴바 다음 버튼
    @objc func startdaytoolbarNext() {
        self.arrivalDayTextField.becomeFirstResponder() // 해당 텍스트필드 활성화?
    }
    
    // 출발일시 날짜 피커뷰 툴바 이전 버튼
    @objc func startdaytoolbarBefore() {
        self.startDayTextField.resignFirstResponder()
    }
    
    // 도착일시 날짜 피커뷰
    private func configureArrivalDayPicker() {
        self.arrivalDayPicker.datePickerMode = .dateAndTime
        self.arrivalDayPicker.preferredDatePickerStyle = .wheels
        self.arrivalDayPicker.addTarget(self, action: #selector(arrivaldayPickerValueDidChange(_:)), for: .valueChanged)
        self.arrivalDayPicker.locale = Locale(identifier: "ko-KR")
        self.arrivalDayTextField.inputView = self.arrivalDayPicker
        
        let arrivaldayToolbar = UIToolbar()
        arrivaldayToolbar.barStyle = UIBarStyle.default
        arrivaldayToolbar.isTranslucent = true
        arrivaldayToolbar.sizeToFit()
        
        let arrivaldaySelectBT = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.arrivaldaytoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let arrivaldayNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.arrivaldaytoolbarNext))
        let arrivaldayBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.arrivaldaytoolbarBefore))
        
        arrivaldayToolbar.setItems([arrivaldayBeforeBT,arrivaldayNextBT,flexibleSpace,arrivaldaySelectBT], animated: false)
        arrivaldayToolbar.isUserInteractionEnabled = true
        
        arrivalDayTextField.inputAccessoryView = arrivaldayToolbar
    }
    
    // 도착일시 날짜 피커뷰의 addtarget의 selector / 형식 전달하기
    @objc private func arrivaldayPickerValueDidChange(_ arrivalDayPicker: UIDatePicker) {
        let arrivalformmater = DateFormatter()
        arrivalformmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        arrivalformmater.locale = Locale(identifier: "ko_KR")
        self.arrivalDay = arrivalDayPicker.date
        self.arrivalDayTextField.text = arrivalformmater.string(from: arrivalDayPicker.date)
        self.arrivalDayTextField.sendActions(for: .editingChanged)
    }
    
    // 도착일시 날짜 피커뷰 툴바 선택 버튼
    @objc private func arrivaldaytoolbarSelect(_ datePicker: UIDatePicker) {
        let arrivaldayformmater = DateFormatter()
        arrivaldayformmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        arrivaldayformmater.locale = Locale(identifier: "ko_KR")
        self.arrivalDay = arrivalDayPicker.date
        self.arrivalDayTextField.text = arrivaldayformmater.string(from: arrivalDayPicker.date)
        self.arrivalDayTextField.sendActions(for: .editingChanged)
        self.arrivalDayTextField.resignFirstResponder()
    }
    
    // 도착일시 날짜 피커뷰 툴바 다음 버튼
    @objc func arrivaldaytoolbarNext() {
        self.startAreaTextField.becomeFirstResponder() // 해당 텍스트필드 활성화?
    }
    
    // 도착일시 날짜 피커뷰 툴바 이전 버튼
    @objc func arrivaldaytoolbarBefore() {
        self.startDayTextField.becomeFirstResponder()
    }
    
    // 출발지 툴바 설정
    private func startareaToolbar() {
        let startareatoolbar = UIToolbar()
        startareatoolbar.barStyle = UIBarStyle.default
        startareatoolbar.isTranslucent = true
        startareatoolbar.sizeToFit()
        
        let startareaSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.startareatoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let startareaNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.startareatoolbarNext))
        let startareaBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.startareatoolbarBefore))
        
        startareatoolbar.setItems([startareaBeforeBT,startareaNextBT,flexibleSpace,startareaSelectBT], animated: false)
        startareatoolbar.isUserInteractionEnabled = true
        
        startAreaTextField.inputAccessoryView = startareatoolbar
    }
    
    // 출발지 툴바 선택 버튼
    @objc func startareatoolbarSelect() {
        self.startAreaTextField.resignFirstResponder()
    }
    
    // 출발지 툴바 다음 버튼
    @objc func startareatoolbarNext() {
        self.arrivalAreaTextField.becomeFirstResponder()
    }
    
    // 출발지 툴바 이전 버튼
    @objc func startareatoolbarBefore() {
        self.arrivalDayTextField.becomeFirstResponder()
    }
    
    // 도착지 툴바 설정
    private func arrivalareaToolbar() {
        let arrivalareatoolbar = UIToolbar()
        arrivalareatoolbar.barStyle = UIBarStyle.default
        arrivalareatoolbar.isTranslucent = true
        arrivalareatoolbar.sizeToFit()
        
        let arrivalareaSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.arrivalareatoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let arrivalareaNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.arrivalareatoolbarNext))
        let arrivalareaBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.arrivalareatoolbarBefore))
        
        arrivalareatoolbar.setItems([arrivalareaBeforeBT,arrivalareaNextBT,flexibleSpace,arrivalareaSelectBT], animated: false)
        arrivalareatoolbar.isUserInteractionEnabled = true
        
        arrivalAreaTextField.inputAccessoryView = arrivalareatoolbar
    }
    
    // 도착지 툴바 선택 버튼
    @objc func arrivalareatoolbarSelect() {
        self.arrivalAreaTextField.resignFirstResponder()
    }
    
    // 도착지 툴바 다음 버튼
    @objc func arrivalareatoolbarNext() {
        self.startKmTextField.becomeFirstResponder()
    }
    
    // 도착지 툴바 이전 버튼
    @objc func arrivalareatoolbarBefore() {
        self.startAreaTextField.becomeFirstResponder()
    }
    
    // 출발 키로수 툴바 설정
    private func startkmToolbar() {
        let startkmtoolbar = UIToolbar()
        startkmtoolbar.barStyle = UIBarStyle.default
        startkmtoolbar.isTranslucent = true
        startkmtoolbar.sizeToFit()
        
        let startkmSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.startkmtoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let startkmNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.startkmtoolbarNext))
        let startkmBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.startkmtoolbarBefore))
        
        startkmtoolbar.setItems([startkmBeforeBT,startkmNextBT,flexibleSpace,startkmSelectBT], animated: false)
        startkmtoolbar.isUserInteractionEnabled = true
        
        startKmTextField.inputAccessoryView = startkmtoolbar
    }
    
    // 출발 키로수 툴바 선택 버튼
    @objc func startkmtoolbarSelect() {
        self.startKmTextField.resignFirstResponder()
    }
    
    // 출발 키로수 툴바 다음 버튼
    @objc func startkmtoolbarNext() {
        self.arrivalKmTextField.becomeFirstResponder()
    }
    
    // 출발 키로수 툴바 이전 버튼
    @objc func startkmtoolbarBefore() {
        self.arrivalAreaTextField.becomeFirstResponder()
    }
    
    // 도착 키로수 툴바 설정
    private func arrivalkmToolbar() {
        let arrivalkmtoolbar = UIToolbar()
        arrivalkmtoolbar.barStyle = UIBarStyle.default
        arrivalkmtoolbar.isTranslucent = true
        arrivalkmtoolbar.sizeToFit()
        
        let arrivalkmSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.arrivalkmtoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let arrivalkmNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.arrivalkmtoolbarNext))
        let arrivalkmBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.arrivalkmtoolbarBefore))
        
        arrivalkmtoolbar.setItems([arrivalkmBeforeBT,arrivalkmNextBT,flexibleSpace,arrivalkmSelectBT], animated: false)
        arrivalkmtoolbar.isUserInteractionEnabled = true
        
        arrivalKmTextField.inputAccessoryView = arrivalkmtoolbar
    }
    
    // 도착 키로수 툴바 선택 버튼
    @objc func arrivalkmtoolbarSelect() {
        self.arrivalKmTextField.resignFirstResponder()
    }
    
    // 도착 키로수 툴바 다음 버튼
    @objc func arrivalkmtoolbarNext() {
        self.drivingReasonTextField.becomeFirstResponder()
    }
    
    // 도착 키로수 툴바 이전 버튼
    @objc func arrivalkmtoolbarBefore() {
        self.startKmTextField.becomeFirstResponder()
    }
    
    // 운행목적 툴바 설정
    private func drivingreasonToolbar() {
        let drivingreasontoolbar = UIToolbar()
        drivingreasontoolbar.barStyle = UIBarStyle.default
        drivingreasontoolbar.isTranslucent = true
        drivingreasontoolbar.sizeToFit()
        
        let drivingreasonSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.drivingreasontoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let drivingreasonNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.drivingreasontoolbarNext))
        let drivingreasonBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.drivingreasontoolbarBefore))
        
        drivingreasontoolbar.setItems([drivingreasonBeforeBT,drivingreasonNextBT,flexibleSpace,drivingreasonSelectBT], animated: false)
        drivingreasontoolbar.isUserInteractionEnabled = true
        
        drivingReasonTextField.inputAccessoryView = drivingreasontoolbar
    }
    
    // 운행목적 툴바 선택 버튼
    @objc func drivingreasontoolbarSelect() {
        self.drivingReasonTextField.resignFirstResponder()
    }
    
    // 운행목적 툴바 다음 버튼
    @objc func drivingreasontoolbarNext() {
        self.noteTextView.becomeFirstResponder()
    }
    
    // 운행목적 툴바 이전 버튼
    @objc func drivingreasontoolbarBefore() {
        self.arrivalKmTextField.becomeFirstResponder()
    }
    
    // 비고 툴바 설정
    private func noteToolbar() {
        let notetoolbar = UIToolbar()
        notetoolbar.barStyle = UIBarStyle.default
        notetoolbar.isTranslucent = true
        notetoolbar.sizeToFit()
        
        let noteSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.notetoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let noteNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.notetoolbarNext))
        let noteBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.notetoolbarBefore))
        
        notetoolbar.setItems([noteBeforeBT,noteNextBT,flexibleSpace,noteSelectBT], animated: false)
        notetoolbar.isUserInteractionEnabled = true
        
        noteTextView.inputAccessoryView = notetoolbar
    }
    
    // 비고 툴바 선택 버튼
    @objc func notetoolbarSelect() {
        self.noteTextView.resignFirstResponder()
    }
    
    // 비고 툴바 다음 버튼
    @objc func notetoolbarNext() {
        self.noteTextView.resignFirstResponder()
    }
    
    // 비고 툴바 이전 버튼
    @objc func notetoolbarBefore() {
        self.drivingReasonTextField.becomeFirstResponder()
    }
    
    //
    private func configureInputField() {
        self.startDayTextField.addTarget(self, action: #selector(startDayTextfieldDidChange(_:)), for: .editingChanged)
        self.arrivalDayTextField.addTarget(self, action: #selector(arrivalDayTextfieldDidChange(_:)), for: .editingChanged)
        self.startAreaTextField.addTarget(self, action: #selector(startAreaTextfieldDidChange(_:)), for: .editingChanged)
        self.arrivalAreaTextField.addTarget(self, action: #selector(arrivalAreaTextfieldDidChange(_:)), for: .editingChanged)
        self.startKmTextField.addTarget(self, action: #selector(startKmTextfieldDidChange(_:)), for: .editingChanged)
        self.arrivalKmTextField.addTarget(self, action: #selector(arrivalKmTextfieldDidChange(_:)), for: .editingChanged)
        self.drivingReasonTextField.addTarget(self, action: #selector(drivingReasonTextfieldDidChange(_:)), for: .editingChanged)
        self.noteTextView.delegate = self
    }
    
    // save버튼 클릭 시 driving 객체를 생성해서 넘김
    @IBAction func tabSaveButton(_ sender: UIBarButtonItem) {
        guard let startday = self.startDay else { return }
        guard let arrivalday = self.arrivalDay else { return }
        guard let startarea = self.startAreaTextField.text else { return }
        guard let arrivalarea = self.arrivalAreaTextField.text else { return }
        guard let startkm = self.startKmTextField.text else { return }
        guard let arrivalkm = self.arrivalKmTextField.text else { return }
        guard let drivingreason = self.drivingReasonTextField.text else { return }
        guard let note = noteTextView.text else { return }
        let driving = Driving(startday: startday, arrivalday: arrivalday, startarea: startarea, arrivalarea: arrivalarea, startkm: startkm, arrivalkm: arrivalkm, drivingreason: drivingreason, note: note)
        
        //
        switch self.drivingEditorMode {
        case .new:
            self.delegate?.didSelectReigster(driving: driving)
        
        case let .edit(indexPath, _):
            NotificationCenter.default.post(
                name: NSNotification.Name("editDriving"),
                object: driving,
                userInfo: [
                    "indexPath.row": indexPath.row
                ]
            )
        }
        self.navigationController?.popViewController(animated: true) // 화면을 전환한다
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
    
    // 빈 화면 클릭 시 키보드 닫힘처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 등록버튼에 활성화 여부를 판단하는 메서드
    private func validateInputField() {
        self.saveButton.isEnabled = !(self.startDayTextField.text?.isEmpty ?? true) && !(self.arrivalDayTextField.text?.isEmpty ?? true) && !(self.startAreaTextField.text?.isEmpty ?? true) && !(self.arrivalAreaTextField.text?.isEmpty ?? true) && !(startKmTextField.text?.isEmpty ?? true) && !(self.arrivalKmTextField.text?.isEmpty ?? true) && !(self.drivingReasonTextField.text?.isEmpty ?? true) && !self.noteTextView.text.isEmpty
    }
}

// textview에 text가 입력될 때 마다 호출되는 메서드
extension DrivingWriteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
