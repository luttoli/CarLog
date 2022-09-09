//
//  DrivingViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2022/07/31.
//

import UIKit

// 작성된 운행일지 리스트 화면
class DrivingViewController: UIViewController {

    @IBOutlet weak var drivingcollectionview: UICollectionView!
    
    private var drivingList = [Driving]() { // drivingList를 프로퍼티 옵저버로 만듦
        didSet {
            self.saveDrivingList() // 추가되거나 변경되면 유저디퍼스에 저장
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDrivingList()
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(editDrivingNotification(_:)),
        name: NSNotification.Name("editDriving"),
        object: nil
        )
    }
    
    // 운행일지 리스트 배열에 추가된 일지를 콜랙션뷰에 추가
    private func configureCollectionView() {
        // 코드로 콜렉션뷰 레이아웃 구성하기
        self.drivingcollectionview.collectionViewLayout = UICollectionViewFlowLayout()
        self.drivingcollectionview.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.drivingcollectionview.delegate = self
        self.drivingcollectionview.dataSource = self
    }
    
    //
    @objc func editDrivingNotification(_ notification: Notification) {
        guard let driving = notification.object as? Driving else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.drivingList[row] = driving
        self.drivingList = self.drivingList.sorted(by: {
            $0.startday.compare($1.startday) == .orderedDescending
        })
        self.drivingcollectionview.reloadData()
    }
    
    // 작성화면의 이동은 세그웨이를 통해서 이동하기 때문에 prepare이용
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let drivingWriteUIViewContoller = segue.destination as? DrivingWriteViewController {
            drivingWriteUIViewContoller.delegate = self
        }
    }
    
    // 기기 저장 / userDefaults 딕셔너리 배열 형태로 저장
    private func saveDrivingList() {
        let date = self.drivingList.map {
            [
                "startday": $0.startday,
                "arrivalday": $0.arrivalday,
                "startarea": $0.startarea,
                "arrivalarea": $0.arrivalarea,
                "startkm": $0.startkm,
                "arrivalkm": $0.arrivalkm,
                "drivingreason": $0.drivingreason,
                "note": $0.note
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "drivingList")
    }
    
    // 저장된 값을 불러오는 메서드
    private func loadDrivingList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "drivingList") as? [[String: Any]] else {
            return }
        self.drivingList = data.compactMap {
            guard let startday = $0["startday"] as? Date else { return nil }
            guard let arrivalday = $0["arrivalday"] as? Date else { return nil }
            guard let startarea = $0["startarea"] as? String else { return nil }
            guard let arrivalarea = $0["arrivalarea"] as? String else { return nil }
            guard let startkm = $0["startkm"] as? String else { return nil }
            guard let arrivalkm = $0["arrivalkm"] as? String else { return nil }
            guard let drivingreason = $0["drivingreason"] as? String else { return nil }
            guard let note = $0["note"] as? String else { return nil }
            return Driving(startday: startday, arrivalday: arrivalday, startarea: startarea, arrivalarea: arrivalarea, startkm: startkm, arrivalkm: arrivalkm, drivingreason: drivingreason, note: note)
        }
        // 출발날짜 비교해서 최근일이 맨 위로 올라가게 로드하는 방법
        self.drivingList = self.drivingList.sorted(by: {
            $0.startday.compare($1.startday) == .orderedDescending
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
extension DrivingViewController: UICollectionViewDataSource {
    // 필수 메서드 : numberOfSections 셀의 개수를 물음, 리스트 개수만큼
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.drivingList.count
    }
    
    // 필수 메서드 : cellForItemAt 컬렉션뷰에 지정된 위치에 표시할 셀을 요청하는 메서드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrivingCell", for: indexPath) as? DrivingCell else { return UICollectionViewCell() }
        let driving = self.drivingList[indexPath.row]
        cell.startDayLabel.text = self.dateTostring(date: driving.startday)
        cell.arrivalDayLabel.text = self.dateTostring(date: driving.arrivalday)
        cell.startAreaLabel.text = driving.startarea
        cell.arrivalAreaLabel.text = driving.arrivalarea
        cell.drivingReasonLabel.text = driving.drivingreason
        cell.startKmLabel.text = driving.startkm
        cell.arrivalKmLabel.text = driving.arrivalkm
        
        let drivingtime = Int(driving.arrivalday.timeIntervalSince(driving.startday))
        cell.drivingTimeLabel.text = String(drivingtime / 60)
        
        let arrivalkmint = Int(cell.arrivalKmLabel.text!)
        let startkmint = Int(cell.startKmLabel.text!)
        cell.drivingKmLabel.text = String(arrivalkmint! - startkmint!)
        
        return cell
    }
}

// 유아이콜랙션뷰델리게이터 플로우레이아웃 콜렉션뷰의 레이아웃 구성
extension DrivingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width) - 20, height: 132)
    }
}

// didSelectItemAt = 특정셀이 선택되었음을 알리는 메서드
extension DrivingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewContoller = self.storyboard?.instantiateViewController(identifier: "DrivingDetailViewController") as? DrivingDetailViewController else { return }
        let driving = self.drivingList[indexPath.row]
        viewContoller.driving = driving
        viewContoller.indexPath = indexPath
        viewContoller.delegate = self
        self.navigationController?.pushViewController(viewContoller, animated: true)
    }
}

// drivingWriteUIViewContoller 채택하라
extension DrivingViewController: DrivingWriteViewDelegate {
    // 일지가 작성되면 내용이 담겨져있는 객체가 전달됨
    func didSelectReigster(driving: Driving) {
        self.drivingList.append(driving) // 작성될때마다 추가
        // 출발날짜 비교해서 최근일이 맨 위로 올라가게 저장하는 방법
        self.drivingList = self.drivingList.sorted(by: {
            $0.startday.compare($1.startday) == .orderedDescending
        })
        self.drivingcollectionview.reloadData()
    }
}

// 삭제
extension DrivingViewController: DrivingDetailViewDelegate {
    func didSelectDelete(indexPath: IndexPath) {
        self.drivingList.remove(at: indexPath.row)
        self.drivingcollectionview.deleteItems(at: [indexPath])
    }
}
