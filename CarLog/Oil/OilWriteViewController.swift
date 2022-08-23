//
//  OilWriteViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/08/23.
//

import UIKit

class OilWriteViewController: UIViewController {

    @IBOutlet weak var oilDayTextField: UITextField!
    @IBOutlet weak var oilZonTextField: UITextField!
    @IBOutlet weak var oilKmTextField: UITextField!
    @IBOutlet weak var oilTypeTextField: UITextField!
    @IBOutlet weak var oilUnitTextField: UITextField!
    @IBOutlet weak var oilNumTextField: UITextField!
    @IBOutlet weak var oilDcTextField: UITextField!
    @IBOutlet weak var oilNoteTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private let oilDayPicker = UIDatePicker()
    private var oilDay: Date?
    
    private let oilTypePicker = UIPickerView()
    let oiltype = ["휘발유", "고급 휘발유", "경유", "LPG", "전기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNoteTextview()
        configureOilDayPicker()
        configureOilTypePicker()
    }
    
    // Textview border
    private func configureNoteTextview() {
        let borderColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1.0)
        self.oilNoteTextView.layer.borderColor = borderColor.cgColor
        self.oilNoteTextView.layer.borderWidth = 2
        self.oilNoteTextView.layer.cornerRadius = 5.0
    }
    
    // 날짜 피커뷰 꾸미기
    private func configureOilDayPicker() {
        self.oilDayPicker.datePickerMode = .dateAndTime
        self.oilDayPicker.preferredDatePickerStyle = .wheels
        self.oilDayPicker.addTarget(self, action: #selector(oildayPickerValueDidChange(_:)), for: .valueChanged)
        // addTarget = ?? 유아이컨트롤러 객체가 이벤트에 응답하는 방식을 설정하는 메서드 / target = 해당 뷰컨트롤러에서 처리 self / action = 이벤트가 발생하였을때 그에 응답하여 호출될 메서드를 selector로 넘겨주면 되는데 넣어서 넘겨줄 메서드 생성
        self.oilDayPicker.locale = Locale(identifier: "ko_KR")
        self.oilDayTextField.inputView = self.oilDayPicker
    }
    
    // 날짜 피커뷰의 addtarget의 selector / 형식 전달하기
    @objc private func oildayPickerValueDidChange(_ datePicker: UIDatePicker) {
        let oildayformmater = DateFormatter()
        oildayformmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        oildayformmater.locale = Locale(identifier: "ko_KR")
        self.oilDay = oilDayPicker.date
        self.oilDayTextField.text = oildayformmater.string(from: oilDayPicker.date)
        self.oilDayTextField.sendActions(for: .editingChanged)
    }
    
    // 항목 피커뷰 꾸미기 / 와 일단 드롭다운 나와서 선택하는거 된다 성공했다 진짜 미쳤다 별거아닌거 아는데 감격스럽다 증말
    private func configureOilTypePicker() {
        self.oilTypePicker.delegate = self
        self.oilTypePicker.dataSource = self
        self.oilTypeTextField.inputView = self.oilTypePicker
        configureToolbar()
    }
    
    // 항목 피커뷰 위에 툴바 설정
    private func configureToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelBT,flexibleSpace,doneBT], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        oilTypeTextField.inputAccessoryView = toolBar
    }
    
    // 항목 피커뷰 툴바 선택 버튼
    @objc func donePicker() {
        let row = self.oilTypePicker.selectedRow(inComponent: 0)
        self.oilTypePicker.selectRow(row, inComponent: 0, animated: false)
        self.oilTypeTextField.text = self.oiltype[row]
        self.oilTypeTextField.resignFirstResponder()
    }
    
    // 항목 피커뷰 툴바 취소 버튼
    @objc func cancelPicker() {
        self.oilTypeTextField.text = nil
        self.oilTypeTextField.resignFirstResponder()
    }
    
    // done 버튼 클릭
    @IBAction func tapSaveButton(_ sender: Any) {
    }
    
    // 빈 화면을 터치하면 키보드를 내려주는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// 항목 피커뷰 설정
extension OilWriteViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // 몇개의 피커뷰를 보여줄것인가
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 피커뷰 항목
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.oiltype.count
    }
    
    // 피커뷰 선택 시
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.oiltype[row]
    }
    
    // 피커뷰에서 선택된 항목을 텍스트 필드의 문자열로 변경하기
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        oilTypeTextField.text = self.oiltype[row]
    }
}

   
