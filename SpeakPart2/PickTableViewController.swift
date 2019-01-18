//
//  PickTableViewController.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/18.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class PickTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    
    let kCell_Height = 44
    private var stateArray = [String]()
    private var expandTable: UITableView?
    
    var questionList = [[String: Any]]()
    private var question = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDataSource()
        initTable()
    }
    
    func initDataSource() {
        stateArray.removeAll()
        for _ in 0..<questionList.count {
            // 預設為0 - 當0時 表示所有 section 關起來
            stateArray.append("0")
        }
        
        let image = UIImage(named: "back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(PickTableViewController.navigationBackBtnTap))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func initTable() {
        expandTable = UITableView(frame: CGRect(x: 0, y: 60, width: view.frame.size.width, height: view.frame.size.height - 110), style: .plain)
        expandTable?.dataSource = self
        expandTable?.delegate = self
        expandTable?.tableFooterView = UIView()
        expandTable?.register(UINib(nibName: "ExpandCell", bundle: nil), forCellReuseIdentifier: "cell")
        if let expandTable = expandTable {
            view.addSubview(expandTable)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (stateArray[section] == "1") {
            //如果是展開狀態 則回報有多少 row
            let array = questionList[section]
            return array.count
        } else {
            //如果是關起來 0個row
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ExpandCell
//        cell?.listLabel.textAlignment = .left
//        cell?.listLabel.sizeToFit()
//        cell?.listLabel.text = questionDic(indexPath)?["Question"]
//        cell?.backgroundColor = UIColor.white
//        cell?.selectionStyle = UITableViewCell.SelectionStyle.gray
//        cell?.contentView.backgroundColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testVC = Utl.getViewControllerWithStoryboard("Main", identifier: "TestVC") as? TestVC
        if let quesDic = questionDic(indexPath) as? [String:String]{
            testVC?.quesDic = quesDic
        }
        testVC?.hidesBottomBarWhenPushed = true
        if let testVC = testVC {
            navigationController?.pushViewController(testVC, animated: true)
        }
    }
    
    func questionDic(_ indexPath: IndexPath?) -> [String : Any]? {
        // 從 plist 的 dictionary 解析出來
        let randomTopic = questionList[indexPath?.section ?? 0]
        let str = String(format: ("Question_%ld"), (indexPath?.row ?? 0) + 1)
        if let qiz = randomTopic[str] as? [String : String] {
//            question = str
        }
        
        return question
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 把section 的位置裝進一個按鈕來控制
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
        button.tag = section
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        button.addTarget(self, action: #selector(PickTableViewController.buttonPress(_:)), for: .touchUpInside)
        
        // 底線裝飾
        let line = UIImageView(frame: CGRect(x: 0, y: button.frame.size.height - 1, width: button.frame.size.width, height: 1))
        line.image = UIImage(named: "line_real")
        button.addSubview(line)
        
        // 前面圖案裝飾
        let imgView = UIImageView(frame: CGRect(x: 10, y: CGFloat((kCell_Height - 18) / 2), width: 18, height: 18))
        imgView.image = UIImage(named: "ico_faq_d")
        button.addSubview(imgView)
        
        let _imgView = UIImageView(frame: CGRect(x: view.frame.size.width - 30, y: CGFloat((kCell_Height - 6) / 2), width: 10, height: 6))
        
        // 箭頭狀態
        if (stateArray[section] == "0") {
            _imgView.image = UIImage(named: "ico_listdown")
        } else if (stateArray[section] == "1") {
            _imgView.image = UIImage(named: "ico_listup")
        }
        button.addSubview(_imgView)
        
        let tlabel = UILabel(frame: CGRect(x: 45, y: CGFloat((kCell_Height - 20) / 2), width: 200, height: 20))
        
        tlabel.backgroundColor = UIColor.clear
        tlabel.font = UIFont.systemFont(ofSize: 14)
        tlabel.text = sectionTitle(section)
        button.addSubview(tlabel)
        return button
    }
    
    @objc func buttonPress(_ sender: UIButton?) {
        // 1 展開 0 收合
        if (stateArray[sender?.tag ?? 0] == "1") {
            
            stateArray[sender?.tag ?? 0] = "0"
        } else {
            stateArray[sender?.tag ?? 0] = "1"
        }
        expandTable?.reloadSections(NSIndexSet(index: sender?.tag ?? 0) as IndexSet, with: .automatic)
        
    }
    
    // MARK: - height for rows
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(kCell_Height)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func sectionTitle(_ section: Int) -> String? {
        let topic = questionList[section]
        var str = String()
        for i in 1...topic.count {
            str = "Question_\(i)"
        }
        let qiz = topic[str] as? [AnyHashable : Any]
        
        switch section {
        case 0:
            return qiz?["QusTopic"] as? String
        case 1:
            return qiz?["QusTopic"] as? String
        case 2:
            return qiz?["QusTopic"] as? String
        case 3:
            return qiz?["QusTopic"] as? String
        case 4:
            return qiz?["QusTopic"] as? String
        case 5:
            return qiz?["QusTopic"] as? String
        case 6:
            return qiz?["QusTopic"] as? String
        case 7:
            return qiz?["QusTopic"] as? String
        case 8:
            return qiz?["QusTopic"] as? String
        default:
            return ""
        }
    }
    
    @objc func navigationBackBtnTap() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Question List"
    }
}
