//
//  RecordVC.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/25.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class RecordVC: UIViewController {
    
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var randomBtn: UIButton!
    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var examList = [ExamList]()
    var questionList = [QuestionList]()
    var dbExamList =  [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectBtn.addTarget(self, action: #selector(selectBtnTouchUpInside), for: .touchUpInside)
        randomBtn.addTarget(self, action: #selector(randomBtnTouchUpInside), for: .touchUpInside)

    }
    func refresh(){
        self.navigationItem.title = "Record"
        noticeView.isHidden = true
        dbExamList.removeAll()
        examList.removeAll()
        dbExamList = ExamDB.getExamList()
        for item in dbExamList {
            var exam = ExamList()
            exam.createtime = item["createtime"] as? NSDate ?? NSDate()
            exam.question = item["question"] as? String ?? ""
            exam.qustopic = item["qustopic"] as? String ?? ""
            exam.voiceAudio = item["voiceAudio"] as? String ?? ""
            
            self.examList.append(exam)
        }
        sortExamList()
        setTableView()
        
        if dbExamList.count < 1 {
            openPlist()
            noticeView.isHidden = false
            tableView.isHidden = true
        }
        tableView.reloadData()
    }
    func sortExamList(){
        let sort = UserDefaults.standard.string(forKey: "SORT") ?? "New -> Old"
        switch sort {
        case "New -> Old":
            examList.sort { $0.voiceAudio > $1.voiceAudio }
            break
        case "Old -> New":
            examList.sort { $0.voiceAudio < $1.voiceAudio }
            break
        case "Topic":
            examList.sort { $0.qustopic < $1.qustopic }
            break
        case "Question":
            examList.sort { $0.question < $1.question }
            break
        default:
            examList.sort { $0.voiceAudio > $1.voiceAudio }
            break
        }
        
    }
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.bounces = true
        tableView.allowsSelection = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 102

    }
    func openPlist(){
        if let fileUrl = Bundle.main.url(forResource: "SpeakingTopic", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String: Any]] {
                for item in result {
                    var qizTopic = ""
                    var quesList = QuestionList()
                    var moreQues = [Question]()
                    for (key,value) in item{
                        var ques = Question()
                        ques.quesNo = key
                        if let values = value as? [String:String]{
                            ques.Hint = values["Hint"]
                            ques.question = values["Question"]
                            ques.qustopic = values["QusTopic"]
                            qizTopic =  ques.qustopic
                        }
                        moreQues.append(ques)
                    }
                    
                    moreQues.sort { $0.quesNo > $1.quesNo }
                    quesList.question = moreQues
                    quesList.qustopic = qizTopic
                    quesList.qustCd = qustCd(qizTopic)
                    
                    questionList.append(quesList)
                }
            }
        }
        questionList.sort { $0.qustCd < $1.qustCd }
    }
    func qustCd(_ qizTopic:String)-> String {
        var qustCd = ""
        
        switch qizTopic {
        case "Language learning":
            qustCd = "LL01"
            break
        case "Future plans":
            qustCd = "FP02"
            break
        case "Holidays and travel ":
            qustCd = "HAT03"
            break
        case "Festivals and celebrations ":
            qustCd = "FAC04"
            break
        case "About Your Hometown ":
            qustCd = "AYH05"
            break
        case "Home and accommodation":
            qustCd = "HAA06"
            break
        case "Work and Studies":
            qustCd = "WAS07"
            break
        case "Sports, hobbies and free time":
            qustCd = "SHAFT08"
            break
        case "Family, friends and pets":
            qustCd = "FFAP09"
            break
        default:
            break
        }
        
        return qustCd
    }
    @objc func selectBtnTouchUpInside(_ sender:UIButton) {
        let questionVC = Utl.getViewControllerWithStoryboard("Main", identifier: "QuestionVC") as? QuestionVC
        if let questionVC = questionVC {
            questionVC.questionList = questionList
            navigationController?.pushViewController(questionVC, animated: true)
        }
    }
    
    @objc func randomBtnTouchUpInside(_ sender:UIButton) {
        let random = Int(arc4random()) % questionList.count
        let randomTopic = questionList[random].question!
        let randomques = Int(arc4random()) % randomTopic.count
        
        
        let testVC = Utl.getViewControllerWithStoryboard("Main", identifier: "TestVC") as? TestVC
        if let testVC = testVC {
            testVC.quesDic = randomTopic[randomques]
            testVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(testVC, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        refresh()
    }
}
extension RecordVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordDetailVC = Utl.getViewControllerWithStoryboard("Main", identifier: "RecordDetailVC") as? RecordDetailVC
        if let recordDetailVC = recordDetailVC {
            recordDetailVC.exam = examList[indexPath.row]
            recordDetailVC.examList = examList
            recordDetailVC.index = indexPath.row
            recordDetailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(recordDetailVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 生成刪除按鈕
        let deleteAction: UITableViewRowAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(action, indexPath) -> Void in

            // 將資料從陣列移除
            let recordFilePath = self.examList[indexPath.row].voiceAudio ?? ""
            self.examList.remove(at: indexPath.row)

            // 將畫面上的cell移除
            tableView.deleteRows(at: [indexPath], with: .fade)
            if ExamDB.delete(recordFilePath) {
                print("ExamDB---刪了----- ")
            }
            
        })

        deleteAction.backgroundColor = UIColor.black

        return [deleteAction]
    }
   
}
extension RecordVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "RecordCell"
        var cell: RecordCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RecordCell
        if cell == nil {
            cell = RecordCell(style:UITableViewCell.CellStyle.default, reuseIdentifier:identifier)
        }
        cell.selectionStyle = .none
        if let exam = examList[safe: indexPath.row] {
            cell.questionLabel.text = exam.question
            cell.timeLabel.text = exam.createtime.toString("yyyy-MM-dd HH:mm")
        }
        
        return cell
    }
    
    
}
