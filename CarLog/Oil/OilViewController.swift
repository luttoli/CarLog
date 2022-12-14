//
//  OilViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/08/24.
//

import UIKit

import Foundation

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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editOilNotification(_:)),
            name: NSNotification.Name("editOil"),
            object: nil
        )
    }
    
    // 운행일지 리스트 배열에 추가된 일지를 콜랙션뷰에 추가
    private func configureCollectionView() {
        // 코드로 콜렉션뷰 레이아웃 구성하기
        self.oilcollectionview.collectionViewLayout = UICollectionViewFlowLayout()
        self.oilcollectionview.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.oilcollectionview.delegate = self
        self.oilcollectionview.dataSource = self
    }
    
    //
    @objc func editOilNotification(_ notification: Notification) {
        guard let oil = notification.object as? Oil else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.oilList[row] = oil
        self.oilList = self.oilList.sorted(by: {
            $0.oilday.compare($1.oilday) == .orderedDescending
        })
        self.oilcollectionview.reloadData()
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
                "oilprice": $0.oilprice,
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
            guard let oilday = $0["oilday"] as? Date else { return nil }
            guard let oilzon = $0["oilzon"] as? String else { return nil }
            guard let oilkm = $0["oilkm"] as? String else { return nil }
            guard let oiltype = $0["oiltype"] as? String else { return nil }
            guard let oilunit = $0["oilunit"] as? String else { return nil }
            guard let oilnum = $0["oilnum"] as? String else { return nil }
            guard let oilprice = $0["oilprice"] as? String else { return nil }
            guard let oilnote = $0["oilnote"] as? String else { return nil }
            return Oil(oilday: oilday, oilzon: oilzon, oilkm: oilkm, oiltype: oiltype, oilunit: oilunit, oilnum: oilnum, oilprice: oilprice, oilnote: oilnote)
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
        formatter.dateFormat = "yy. MM. dd (EEEEE)"
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
    
    // 숫자 세자리마다 콤마 찍기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // 필수 메서드 : cellForItemAt 컬렉션뷰에 지정된 위치에 표시할 셀을 요청하는 메서드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OilCell", for: indexPath) as? OilCell else { return UICollectionViewCell() }
        let oil = self.oilList[indexPath.row]
        
        cell.oilDayLabel.text = self.dateTostring(date: oil.oilday)
        cell.oilZonLabel.text = oil.oilzon
        let oilkmint = Int(oil.oilkm)
        cell.oilKmLabel.text = numberFormatter(number: oilkmint!)
        cell.oilTypeLabel.text = oil.oiltype
        let oilunitint = Int(oil.oilunit)
        cell.oilUnitLabel.text = numberFormatter(number: oilunitint!)
        cell.oilNumLabel.text = oil.oilnum
        let oilpriceint = Int(oil.oilprice)
        cell.oilPriceLabel.text = numberFormatter(number: oilpriceint!)
        
        return cell
    }
}

extension OilViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) - 20, height: 72)
    }
}

// didSelectItemAt = 특정셀이 선택되었음을 알리는 메서드
extension OilViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "OilDetailViewController") as? OilDetailViewController else { return }
        let oil = self.oilList[indexPath.row]
        viewController.oil = oil
        viewController.indexPath = indexPath
        viewController.delegate = self // ??? 이게 선택된 델리게이트 받는 건가
        self.navigationController?.pushViewController(viewController, animated: true)
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

// 상세화면에서 삭제한 인덱스페치 로우 값을 리스트에서도 삭제
extension OilViewController: OilDetailViewDelegate {
    func didSelectDelete(indexPath: IndexPath) {
        self.oilList.remove(at: indexPath.row)
        self.oilcollectionview.deleteItems(at: [indexPath])
    }
}


