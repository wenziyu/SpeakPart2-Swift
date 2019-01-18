//
//  ViewController.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/18.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var questionList = [[String: Any]]()
    @IBOutlet private weak var randomBtn: UIButton!
    @IBOutlet private weak var pickUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "IELTS Speaking Part 2"
        if let fileUrl = Bundle.main.url(forResource: "SpeakingTopic", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String: Any]] { //
                questionList = result!
            }
        }
    }
    
    @IBAction func pressedRandomButton(_ sender: Any) {
        let random = Int(arc4random()) % questionList.count
        let randomTopic = questionList[random]
        let randomques = Int(arc4random()) % randomTopic.count
        let str = "Question_\(randomques + 1)"
        let qiz = randomTopic[str] as? [AnyHashable : Any]

        let testVC = Utl.getViewControllerWithStoryboard("Main", identifier: "TestVC") as? TestVC
//        testVC?.quesDic = qiz
        testVC?.hidesBottomBarWhenPushed = true
        if let testVC = testVC {
            navigationController?.pushViewController(testVC, animated: true)
        }
    }

    @IBAction func pressedPickUPButton(_ sender: Any) {
        let add = Utl.getViewControllerWithStoryboard("Main", identifier: "PickTableViewController") as? PickTableViewController
        if let add = add {
            navigationController?.pushViewController(add, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.tintColor = UIColor.black
        //    [[self tabBarController]tabBar].backgroundColor = [UIColor blackColor];
        
        
    }


}

