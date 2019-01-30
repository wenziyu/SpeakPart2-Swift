//
//  QuestionVC.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/19.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var questionList = [QuestionList]()
    /// (qustopic,count)
    var qizCountList = [(String,Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Topic"
        
        setCollectionView()
        
        let image = #imageLiteral(resourceName: "back-1")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(QuestionVC.navigationBackBtnTap))
        navigationItem.leftBarButtonItem = backButton
        setExamList()
        
    }
    func setExamList(){
        qizCountList.removeAll()
        let examList = ExamDB.getExamList()
        var map = examList.map { $0["qustopic"] as? String ?? "" }
        map = map.filter({$0 != ""})
        
        for item in map {
            if qizCountList.filter({$0.0 == item}).isEmpty {
                qizCountList.append((item,1))
            }else {
                if let index = qizCountList.firstIndex(where: {$0.0 == item}){
                    let count = qizCountList[index].1
                    qizCountList[index] = (item,count + 1)
                }
            }
        }
    }
    // MARK: - navigation Back Btn Tap
    @objc func navigationBackBtnTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setCollectionView(){
        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10);
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let size = CGFloat(width - 30)/2
        layout.itemSize = CGSize(width:size , height: size)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: "QizCell", bundle: nil), forCellWithReuseIdentifier:"QizCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func refresh(){
        setExamList()
        collectionView.reloadData()
    }
    
}
extension QuestionVC:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let qizDetailVC = Utl.getViewControllerWithStoryboard("Main", identifier: "QizDetailVC") as? QizDetailVC
        if let qizDetailVC = qizDetailVC {
            if let question = questionList[safe: indexPath.item]?.question {
                qizDetailVC.topicIndex = indexPath.item
                qizDetailVC.questionList = questionList
                qizDetailVC.quesDic = question
                qizDetailVC.qustopic = questionList[safe: indexPath.item]?.qustopic ?? ""
            }
            qizDetailVC.questionVC = self
            navigationController?.pushViewController(qizDetailVC, animated: true)
        }
    }
}
extension QuestionVC:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return questionList.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "QizCell", for: indexPath) as! QizCell
        let qustopic = questionList[safe: indexPath.item]?.qustopic ?? ""
        cell.qizLabel.text = qustopic
        let count = qizCountList.filter({$0.0 == qustopic}).first?.1 ?? 0
        cell.countLabel.text = count == 0 ? "":"\(count)"

        if indexPath.item == 0 || indexPath.item == 3 || indexPath.item == 4 || indexPath.item == 7 || indexPath.item == 8 {
            cell.bgView.backgroundColor = UIColor.appYellow
            cell.qizLabel.textColor = UIColor.black
            cell.countLabel.textColor = UIColor.appYellow
            cell.countLabel.backgroundColor =  count == 0 ? UIColor.clear:UIColor.black
        }else {
            cell.bgView.backgroundColor = UIColor.black
            cell.qizLabel.textColor = UIColor.appYellow
            cell.countLabel.textColor = UIColor.black
            cell.countLabel.backgroundColor = count == 0 ? UIColor.clear:UIColor.appYellow
        }
        return cell
    }
}
