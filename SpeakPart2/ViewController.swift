//
//  ViewController.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/18.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var questionList = [QuestionList]()
    @IBOutlet private weak var randomBtn: UIButton!
    @IBOutlet private weak var pickUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "IELTS Speaking Part 2"
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
    
    @IBAction func pressedRandomButton(_ sender: UIButton) {
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

    @IBAction func pressedPickUPButton(_ sender: Any) {
        let questionVC = Utl.getViewControllerWithStoryboard("Main", identifier: "QuestionVC") as? QuestionVC
        if let questionVC = questionVC {
            questionVC.questionList = questionList
            navigationController?.pushViewController(questionVC, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.tintColor = UIColor.black
        tabBarController?.tabBar.isHidden = false
    }
  
}

