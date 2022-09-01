//
//  OilViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/08/24.
//

import UIKit

class OilViewController: UIViewController {

    @IBOutlet weak var oilCollectionView: UICollectionView!
    
    private var oilList = [Oil]()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    
    private func configureCollectionView() {
        self.oilCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.oilCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.oilCollectionView.delegate = self
        self.oilCollectionView.dataSource = self
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

extension OilViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.oilList.count
    }
    
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
        
        return cell
    }
}

extension OilViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) - 20, height: 102)
    }
}

extension OilViewController: OilWriteViewDelegate {
    func didSelectReigster(oil: Oil) {
        self.oilList.append(oil)
        self.oilCollectionView.reloadData()
    }
}
