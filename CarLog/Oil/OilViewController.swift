//
//  OilViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/08/24.
//

import UIKit

// 작성된 주유일지 리스트 화면
class OilViewController: UIViewController {

    @IBOutlet weak var oilcollectionview: UICollectionView!
    
    private var oilList = [Oil]() { // oilList를 프로퍼티 옵저버로 만듦
        didSet {
            self.saveOilList() // 추가되거나 변경되면 유저디퍼스에 저장
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadOilList()
    }
    
    // 운행일지 리스트 배열에 추가된 일지를 콜랙션뷰에 추가
    private func configureCollectionView() {
        // 코드로 콜렉션뷰 레이아웃 구성하기
        self.oilcollectionview.collectionViewLayout = UICollectionViewFlowLayout()
        self.oilcollectionview.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.oilcollectionview.delegate = self
        self.oilcollectionview.dataSource = self
    }
    
    // 작성화면의 이동은 세그웨이를 통해서 이동하기 떄문에 prepare 이용
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeOilViewContoller = segue.destination as? OilWriteViewController {
            writeOilViewContoller.delegate = self
        }
    }
    
    // 기기 저장 / userDefaults 딕셔너리 배열 형태로 저장
    private func saveOilList() {
        let date = self.oilList.map {
            [
                "oilday": $0.oilday,
                "oilzon": $0.oilzon,
                "oilkm": $0.oilkm,
                "oiltype": $0.oiltype,
                "oilunit": $0.oilunit,
                "oilnum": $0.oilnum,
                "oildc": $0.oildc,
                "oilnote": $0.oilnote
            ]
        }
        let userDefaults = UserDefaults.standard // 접근가능
        userDefaults.set(date, forKey: "oilList")
    }
    
    // 저장된 값을 불러오는 메서드
    private func loadOilList() {
        let userDefaults = UserDefaults.standard // 접근
        guard let data = userDefaults.object(forKey: "oilList") as? [[String: Any]] else { return }// 키값을 넘겨줘서 리스트를 가져옴 / 오브젝트는 any타입이기 때문에 딕셔너리 배열 형태로 타입케스팅 / 타입케스팅 실패하면 nil이 될수도 있으니까 guard문으로 옵셔널 바인딩
        self.oilList = data.compactMap { // 고차함수로 리스트 타입 배열이 되게 맵핑
            guard let oilday = $0["oilday"] as? Date else {
                return nil }
            guard let oilzon = $0["oilzon"] as? String else {
                return nil }
            guard let oilkm = $0["oilkm"] as? String else {
                return nil }
            guard let oiltype = $0["oiltype"] as? String else {
                return nil }
            guard let oilunit = $0["oilunit"] as? String else {
                return nil }
            guard let oilnum = $0["oilnum"] as? String else { return nil }
            guard let oildc = $0["oildc"] as? String else { return nil }
            guard let oilnote = $0["oilnote"] as? String else { return nil }
            return Oil(oilday: oilday, oilzon: oilzon, oilkm: oilkm, oiltype: oiltype, oilunit: oilunit, oilnum: oilnum, oildc: oildc, oilnote: oilnote)
        }
        // 설명 더 있는데 정리할것
        // 주유날짜 비교해서 최근날이 맨 위로 올라가게
        self.oilList = self.oilList.sorted(by: {
            $0.oilday.compare($1.oilday) == .orderedDescending
        })
    }
    
    // date타입 전달받으면 문자열로 전환하는 메서드
    private func dateTostring(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy. MM. dd (EEEEE) HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

// UICollectionViewDataSource 채택하기 + 필수 메서드
extension OilViewController: UICollectionViewDataSource {
    // 필수 메서드 : numberOfSections 셀의 개수를 물음, 리스트 개수만큼
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.oilList.count
    }
    
    // 필수 메서드 : cellForItemAt 컬렉션뷰에 지정된 위치에 표시할 셀을 요청하는 메서드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OilCell", for: indexPath) as? OilCell else { return UICollectionViewCell() }
        let oil = self.oilList[indexPath.row]
        cell.oilDayLabel.text = self.dateTostring(date: oil.oilday)
        cell.oilZonLabel.text = oil.oilzon
        cell.oilKmLabel.text = oil.oilkm
        cell.oilTypeLabel.text = oil.oiltype
        cell.oilUnitLabel.text = oil.oilunit
        cell.oilNumLabel.text = oil.oilnum
        
        // 수량 소수점 입력은 되는데 계산이 안됨... + 최종금액 반올림, 버림 처리해야함 근데 흠... 둘다 될라나..?
        let oilunitint = Int(cell.oilUnitLabel.text!)
        let oilnumdouble = Double(cell.oilNumLabel.text!)
        let oildcint = Int(oil.oildc)
        cell.oilPriceLabel.text = String((oilunitint! * Int(oilnumdouble!)) - oildcint!)
        
        return cell
    }
}

extension OilViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) - 20, height: 110)
    }
}

// drivingWriteUIViewContoller 채택하라
extension OilViewController: OilWriteViewDelegate {
    // 일지가 작성되면 내용이 담겨져있는 객체가 전달됨
    func didSelectReigster(oil: Oil) { // 작성될때마나다 추가
        self.oilList.append(oil)
        self.oilList = self.oilList.sorted(by: {
            $0.oilday.compare($1.oilday) == .orderedDescending
        })
        self.oilcollectionview.reloadData()
    }
}

// 주유 리스트 소트 바로 안됨
// 금액 계산될때 수량 정수로 계산됨
