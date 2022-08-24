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
        oilzonToolbar()
        oilkmToolbar()
        configureOilTypePicker()
        oilunitToolbar()
        oilnumToolbar()
        oildcToolbar()
    }
    
    // Textview 테두리
    private func configureNoteTextview() {
        let borderColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1.0)
        self.oilNoteTextView.layer.borderColor = borderColor.cgColor
        self.oilNoteTextView.layer.borderWidth = 2
        self.oilNoteTextView.layer.cornerRadius = 5.0
    }
    
    // 주유일시 날짜 피커뷰 꾸미기
    private func configureOilDayPicker() {
        self.oilDayPicker.datePickerMode = .dateAndTime
        self.oilDayPicker.preferredDatePickerStyle = .wheels
        self.oilDayPicker.addTarget(self, action: #selector(oildayPickerValueDidChange(_:)), for: .valueChanged)
        // addTarget = ?? 유아이컨트롤러 객체가 이벤트에 응답하는 방식을 설정하는 메서드 / target = 해당 뷰컨트롤러에서 처리 self / action = 이벤트가 발생하였을때 그에 응답하여 호출될 메서드를 selector로 넘겨주면 되는데 넣어서 넘겨줄 메서드 생성
        self.oilDayPicker.locale = Locale(identifier: "ko_KR")
        self.oilDayTextField.inputView = self.oilDayPicker
        
        let oildayToolbar = UIToolbar()
        oildayToolbar.barStyle = UIBarStyle.default
        oildayToolbar.isTranslucent = true
        oildayToolbar.sizeToFit()
        
        let oildaySelectBT = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.oildaytoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let oildayNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.oildaytoolbarNext))
        let oildayBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.oildaytoolbarBefore))
        
        oildayToolbar.setItems([oildayBeforeBT,oildayNextBT,flexibleSpace,oildaySelectBT], animated: false)
        oildayToolbar.isUserInteractionEnabled = true
        
        oilDayTextField.inputAccessoryView = oildayToolbar
    }
    
    // 주유일시 날짜 피커뷰의 addtarget의 selector / 형식 전달하기
    @objc private func oildayPickerValueDidChange(_ datePicker: UIDatePicker) {
        let oildayformmater = DateFormatter()
        oildayformmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        oildayformmater.locale = Locale(identifier: "ko_KR")
        self.oilDay = oilDayPicker.date
        self.oilDayTextField.text = oildayformmater.string(from: oilDayPicker.date)
        self.oilDayTextField.sendActions(for: .editingChanged)
    }
    
    // 주유일시 날짜 피커뷰 툴바 선택 버튼
    @objc func oildaytoolbarSelect(_ datePicker: UIDatePicker) {
        let oildayformmater = DateFormatter()
        oildayformmater.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        oildayformmater.locale = Locale(identifier: "ko_KR")
        self.oilDay = oilDayPicker.date
        self.oilDayTextField.text = oildayformmater.string(from: oilDayPicker.date)
        self.oilDayTextField.sendActions(for: .editingChanged)
        self.oilDayTextField.resignFirstResponder()
    }
    
    // 주유일시 날짜 피커뷰 툴바 다음 버튼
    @objc func oildaytoolbarNext() {
        self.oilZonTextField.becomeFirstResponder() // 해당 텍스트필드 활성화?
    }
    
    // 주유일시 날짜 피커뷰 툴바 이전 버튼
    @objc func oildaytoolbarBefore() {
        self.oilDayTextField.resignFirstResponder()
    }
    
    // 주유소 툴바 설정
    private func oilzonToolbar() {
        let oilzontoolbar = UIToolbar()
        oilzontoolbar.barStyle = UIBarStyle.default
        oilzontoolbar.isTranslucent = true
        oilzontoolbar.sizeToFit()
        
        let oilzonSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.oilzontoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let oilzonNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.oilzontoolbarNext))
        let oilzonBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.oilzontoolbarBefore))
        
        oilzontoolbar.setItems([oilzonBeforeBT,oilzonNextBT,flexibleSpace,oilzonSelectBT], animated: false)
        oilzontoolbar.isUserInteractionEnabled = true
        
        oilZonTextField.inputAccessoryView = oilzontoolbar
    }
    
    // 주유소 툴바 선택 버튼
    @objc func oilzontoolbarSelect() {
        self.oilZonTextField.resignFirstResponder()
    }
    
    // 주유소 툴바 다음 버튼
    @objc func oilzontoolbarNext() {
        self.oilKmTextField.becomeFirstResponder()
    }
    
    // 주유소 툴바 이전 버튼
    @objc func oilzontoolbarBefore() {
        self.oilDayTextField.becomeFirstResponder()
    }
    
    // 주유 시 키로수 툴바 설정
    private func oilkmToolbar() {
        let oilkmtoolbar = UIToolbar()
        oilkmtoolbar.barStyle = UIBarStyle.default
        oilkmtoolbar.isTranslucent = true
        oilkmtoolbar.sizeToFit()
        
        let oilkmSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.oilkmtoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let oilkmNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.oilkmtoolbarNext))
        let oilkmBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.oilkmtoolbarBefore))
        
        oilkmtoolbar.setItems([oilkmBeforeBT,oilkmNextBT,flexibleSpace,oilkmSelectBT], animated: false)
        oilkmtoolbar.isUserInteractionEnabled = true
        
        oilKmTextField.inputAccessoryView = oilkmtoolbar
    }
    
    // 주유 시 키로수 툴바 선택 버튼
    @objc func oilkmtoolbarSelect() {
        self.oilKmTextField.resignFirstResponder()
    }
    
    // 주유 시 키로수 툴바 다음 버튼
    @objc func oilkmtoolbarNext() {
        self.oilTypeTextField.becomeFirstResponder()
    }
    
    // 주유 시 키로수 툴바 이전 버튼
    @objc func oilkmtoolbarBefore() {
        self.oilZonTextField.becomeFirstResponder()
    }
    
    // 주유 종류 항목 드롭다운메뉴 피커뷰 꾸미기 / 와 일단 드롭다운 나와서 선택하는거 된다 성공했다 진짜 미쳤다 별거아닌거 아는데 감격스럽다 증말
    private func configureOilTypePicker() {
        self.oilTypePicker.delegate = self
        self.oilTypePicker.dataSource = self
        self.oilTypeTextField.inputView = self.oilTypePicker
        configureOilTypePickerToolbar()
    }
    
    // 주유 종류 항목 드롭다운메뉴 피커뷰 위에 툴바 설정
    private func configureOilTypePickerToolbar() {
        let oiltypeToolbar = UIToolbar()
        oiltypeToolbar.barStyle = UIBarStyle.default
        oiltypeToolbar.isTranslucent = true
        oiltypeToolbar.sizeToFit()
        
        let oiltypeSelectBT = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.oiltypetoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let oiltypeNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.oiltypetoolbarNext))
        let oiltypeBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.oiltypetoolbarBefore))
        
        oiltypeToolbar.setItems([oiltypeBeforeBT,oiltypeNextBT,flexibleSpace,oiltypeSelectBT], animated: false)
        oiltypeToolbar.isUserInteractionEnabled = true
        
        oilTypeTextField.inputAccessoryView = oiltypeToolbar
    }
    
    // 주유 종류 항목 드롭다운메뉴 피커뷰 툴바 선택 버튼
    @objc func oiltypetoolbarSelect() {
        let row = self.oilTypePicker.selectedRow(inComponent: 0)
        self.oilTypePicker.selectRow(row, inComponent: 0, animated: false)
        self.oilTypeTextField.text = self.oiltype[row]
        self.oilTypeTextField.resignFirstResponder()
    }
    
    // 주유 종류 항목 드롭다운메뉴 피커뷰 툴바 다음 버튼
    @objc func oiltypetoolbarNext() {
        self.oilUnitTextField.becomeFirstResponder()
    }
    
    // 주유 종류 항목 드롭다운메뉴 피커뷰 툴바 이전 버튼
    @objc func oiltypetoolbarBefore() {
        self.oilKmTextField.becomeFirstResponder()
    }
    
    // 단가 툴바 설정
    private func oilunitToolbar() {
        let oilunittoolbar = UIToolbar()
        oilunittoolbar.barStyle = UIBarStyle.default
        oilunittoolbar.isTranslucent = true
        oilunittoolbar.sizeToFit()
        
        let oilunitSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.oilunittoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let oilunitNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.oilunittoolbarNext))
        let oilunitBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.oilunittoolbarBefore))
        
        oilunittoolbar.setItems([oilunitBeforeBT,oilunitNextBT,flexibleSpace,oilunitSelectBT], animated: false)
        oilunittoolbar.isUserInteractionEnabled = true
        
        oilUnitTextField.inputAccessoryView = oilunittoolbar
    }
    
    // 단가 툴바 선택 버튼
    @objc func oilunittoolbarSelect() {
        self.oilUnitTextField.resignFirstResponder()
    }
    
    // 단가 툴바 다음 버튼
    @objc func oilunittoolbarNext() {
        self.oilNumTextField.becomeFirstResponder()
    }
    
    // 단가 툴바 이전 버튼
    @objc func oilunittoolbarBefore() {
        self.oilTypeTextField.becomeFirstResponder()
    }
    
    // 수량 툴바 설정
    private func oilnumToolbar() {
        let oilnumtoolbar = UIToolbar()
        oilnumtoolbar.barStyle = UIBarStyle.default
        oilnumtoolbar.isTranslucent = true
        oilnumtoolbar.sizeToFit()
        
        let oilnumSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.oilnumtoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let oilnumNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.oilnumtoolbarNext))
        let oilnumBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.oilnumtoolbarBefore))
        
        oilnumtoolbar.setItems([oilnumBeforeBT,oilnumNextBT,flexibleSpace,oilnumSelectBT], animated: false)
        oilnumtoolbar.isUserInteractionEnabled = true
        
        oilNumTextField.inputAccessoryView = oilnumtoolbar
    }
    
    // 수량 툴바 선택 버튼
    @objc func oilnumtoolbarSelect() {
        self.oilNumTextField.resignFirstResponder()
    }
    
    // 수량 툴바 다음 버튼
    @objc func oilnumtoolbarNext() {
        self.oilDcTextField.becomeFirstResponder()
    }
    
    // 수량 툴바 이전 버튼
    @objc func oilnumtoolbarBefore() {
        self.oilUnitTextField.becomeFirstResponder()
    }
    
    // 할인 툴바 설정
    private func oildcToolbar() {
        let oildctoolbar = UIToolbar()
        oildctoolbar.barStyle = UIBarStyle.default
        oildctoolbar.isTranslucent = true
        oildctoolbar.sizeToFit()
        
        let oildcSelectBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.oildctoolbarSelect))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let oildcNextBT = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(self.oildctoolbarNext))
        let oildcBeforeBT = UIBarButtonItem(title: "이전", style: .plain, target: .none, action: #selector(self.oildctoolbarBefore))
        
        oildctoolbar.setItems([oildcBeforeBT,oildcNextBT,flexibleSpace,oildcSelectBT], animated: false)
        oildctoolbar.isUserInteractionEnabled = true
        
        oilDcTextField.inputAccessoryView = oildctoolbar
    }
    
    // 할인 툴바 선택 버튼
    @objc func oildctoolbarSelect() {
        self.oilDcTextField.resignFirstResponder()
    }
    
    // 할인 툴바 다음 버튼
    @objc func oildctoolbarNext() {
        self.oilNoteTextView.becomeFirstResponder()
    }
    
    // 할인 툴바 이전 버튼
    @objc func oildctoolbarBefore() {
        self.oilNumTextField.becomeFirstResponder()
    }
    
    // 비고는 어쩔래? 한번 생각해봐 
    
    // Done 버튼 클릭
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

   
