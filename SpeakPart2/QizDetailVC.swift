//
//  QizDetailVC.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/22.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class QizDetailVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var topicLabel: UILabel!
    
    var qustopic = String()
    var topicIndex = Int()
    var quesDic = [Question]()
    var questionList = [QuestionList]()
    /// (question,count)
    var qizCountList = [(String,Int)]()
    /// (topic,count)
    var topicCountList = [(String,Int)]()
    
    weak var questionVC: QuestionVC?
    var isRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Question"
        setQizCountList()
        setCollectionView()
        setTableView()
        setTopicLabel()
        
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: topicIndex, section: 0), at: .centeredHorizontally, animated: true)
        
        let image = #imageLiteral(resourceName: "back-1")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(QizDetailVC.navigationBackBtnTap))
        navigationItem.leftBarButtonItem = backButton
    }
    // MARK: - navigation Back Btn Tap
    @objc func navigationBackBtnTap() {
        if isRefresh {
            questionVC?.refresh()
        }
        
        navigationController?.popViewController(animated: true)
    }
    func setQizCountList(){
        qizCountList.removeAll()
        topicCountList.removeAll()
        let examList = ExamDB.getExamList()
        var qizMap = examList.map { $0["question"] as? String ?? "" }
        qizMap = qizMap.filter({$0 != ""})
        
        for item in qizMap {
            if qizCountList.filter({$0.0 == item}).isEmpty {
                qizCountList.append((item,1))
            }else {
                if let index = qizCountList.firstIndex(where: {$0.0 == item}){
                    let count = qizCountList[index].1
                    qizCountList[index] = (item,count + 1)
                }
            }
        }
        
        var topicMap = examList.map { $0["qustopic"] as? String ?? "" }
        topicMap = topicMap.filter({$0 != ""})
        
        for item in topicMap {
            if topicCountList.filter({$0.0 == item}).isEmpty {
                topicCountList.append((item,1))
            }else {
                if let index = topicCountList.firstIndex(where: {$0.0 == item}){
                    let count = topicCountList[index].1
                    topicCountList[index] = (item,count + 1)
                }
            }
        }
    }
    func setTopicLabel(){
        topicLabel.text = qustopic
        topicLabel.font = UIFont.lightFont(15)
        topicLabel.textColor = UIColor.app155Gray
    }
    func setCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:100, height:100)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
       
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: "TopicCell", bundle: nil), forCellWithReuseIdentifier:"TopicCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
    
    }
   
    func setTableView(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.bounces = true
        tableview.allowsSelection = true
        tableview.rowHeight = UITableView.automaticDimension
        
        let footerView = UIView()
        footerView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableview.bounds.width, height: CGFloat(10))
        tableview.tableFooterView = footerView
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    func refresh(){
        setQizCountList()
        collectionView.reloadData()
        tableview.reloadData()
        isRefresh = true
    }
}
extension QizDetailVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testVC = Utl.getViewControllerWithStoryboard("Main", identifier: "TestVC") as? TestVC
        if let testVC = testVC {
            testVC.quesDic = quesDic[indexPath.row]
            testVC.qizDetailVC = self
            testVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(testVC, animated: true)
        }
    }
}
extension QizDetailVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quesDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "QizDetailCell"
        var cell: QizDetailCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? QizDetailCell
        if cell == nil {
            cell = QizDetailCell(style:UITableViewCell.CellStyle.default, reuseIdentifier:identifier)
        }
        cell.selectionStyle = .none
        let question = quesDic[safe: indexPath.row]?.question
        cell.qizLabel.text = question
        
        let count = qizCountList.filter({$0.0 == question}).first?.1 ?? 0
        cell.countLabel.text = count == 0 ? "":"\(count)"
        cell.countLabel.backgroundColor =  count == 0 ? UIColor.clear:UIColor.appYellow
        
        return cell
    }
}
extension QizDetailVC:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = questionList[safe: indexPath.row]?.qustopic
        qustopic = topic!
        topicIndex = indexPath.row
        if let question = questionList[safe: indexPath.row]?.question {
            quesDic = question
        }
        topicLabel.text = qustopic
        tableview.reloadData()
        tableview.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: topicIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
  
}
extension QizDetailVC:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicCell
        
        let qustopic = questionList[safe: indexPath.item]?.qustopic
        cell.topicLabel.text = qustopic
        
        let count = topicCountList.filter({$0.0 == qustopic}).first?.1 ?? 0
        cell.countLabel.text = count == 0 ? "":"\(count)"
        
        if qustopic == self.qustopic {
            cell.bgView.backgroundColor = UIColor.appYellow
            cell.topicLabel.textColor = UIColor.black
            cell.countLabel.textColor = UIColor.appYellow
            cell.countLabel.backgroundColor =  count == 0 ? UIColor.clear:UIColor.black
            
        }else {
            cell.bgView.backgroundColor = UIColor.black
            cell.topicLabel.textColor = UIColor.appYellow
            cell.countLabel.textColor = UIColor.appYellow
            cell.countLabel.backgroundColor =  UIColor.clear
        }
        
        return cell
    }
    
}
