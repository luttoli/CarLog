//
//  OilViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/08/24.
//

import UIKit

class OilViewController: UIViewController {

    @IBOutlet weak var oilcollectionview: UICollectionView!
    
    private var oilList = [Oil]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
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
        
        let oilunitint = Int(cell.oilUnitLabel.text!)
        let oilnumint = Int(cell.oilNumLabel.text!)
        let oildcint = Int(oil.oildc)
        cell.oilPriceLabel.text = String((oilunitint! * oilnumint!) - oildcint!)
        
        cell.oilMileageLabel.text = oil.oilkm
        
        return cell
    }
}

extension OilViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) - 20, height: 102)
    }
}

// drivingWriteUIViewContoller 채택하라
extension OilViewController: OilWriteViewDelegate {
    // 일지가 작성되면 내용이 담겨져있는 객체가 전달됨
    func didSelectReigster(oil: Oil) { // 작성될때마나다 추가
        self.oilList.append(oil)
        self.oilcollectionview.reloadData()
    }
}
