//
//  MenuVC.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/2/13.
//  Copyright © 2019 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

class MenuVC: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let sectionList = [("SYSTEM",#imageLiteral(resourceName: "settings-2")),("FEEDBACK",#imageLiteral(resourceName: "feedback")),("CARD DIARY",#imageLiteral(resourceName: "problem"))]
    var rowList = [[(String, String)]]()
    var switchValue: String {
        let bool = UserDefaults.standard.bool(forKey: "NOTIFICATION")
        return bool == true ? "ON":"OFF"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rowList = [[("Display",""),("Reminder",switchValue)],[("App Store review",""),("Send feedback","zoedevelopertw@")],[("Open Source Libraries","")]]
        setTableView()
        self.navigationItem.title = "Setting"
        
        
    }
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.allowsSelection = true
        tableView.sectionHeaderHeight = 100
        tableView.rowHeight = 50
        tableView.estimatedRowHeight = 50
        
        let headerNib = UINib.init(nibName: "MenuHeaderCell", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "MenuHeaderCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        
        rowList = [[("Display",""),("Reminder",switchValue)],[("App Store review",""),("Send feedback","zoedevelopertw@")],[("Open Source Libraries","")]]
        tableView.reloadData()
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            print("OS Version: \(getOSInfo())")
            print("App version: \(getAppInfo())")
            print("App Name: \(getAppName())")
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["zoedevelopertw@gmail.com"])
            let message = "OS Version: \(getOSInfo())\nApp version: \(getAppInfo())\nApp Name: \(getAppName())\nMsssage:\n"
            
            mail.setMessageBody(message, isHTML: false)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    func getAppInfo()->String {
        guard let dictionary = Bundle.main.infoDictionary else{return "N/V"}
        let version = dictionary["CFBundleShortVersionString"] as? String ?? ""
        let build = dictionary["CFBundleVersion"] as? String ?? ""
        return version + "(" + build + ")"
    }
    func getAppName()->String {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
        return appName
    }
    func getOSInfo()->String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
}
extension MenuVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let menuDetailVC = Utl.getViewControllerWithStoryboard("Main", identifier: "MenuDetailVC") as? MenuDetailVC
                if let menuDetailVC = menuDetailVC {
                    menuDetailVC.currentPage = "Display"
                    navigationController?.pushViewController(menuDetailVC, animated: true)
                }
                
            }else if indexPath.row == 1 {
                let menuDetailVC = Utl.getViewControllerWithStoryboard("Main", identifier: "MenuDetailVC") as? MenuDetailVC
                if let menuDetailVC = menuDetailVC {
                    menuDetailVC.currentPage = "Reminder"
                    navigationController?.pushViewController(menuDetailVC, animated: true)
                }
            }
            break
        case 1:
            if indexPath.row == 0 {
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    let str = "itms-apps://itunes.apple.com/app/id1279615823?action=write-review"
                    UIApplication.shared.open(URL(string: str)!, options: [:], completionHandler: nil)
                }
            }else if indexPath.row == 1 {
                sendEmail()
            }
            break
        default:
            break
        }
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuHeaderCell") as! MenuHeaderCell
        headerView.title.text = sectionList[section].0
        headerView.iconImgView.image = sectionList[section].1
        
        return headerView
    }
 
}
extension MenuVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowList[section].count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "MenuCell"
        var cell: MenuCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MenuCell
        if cell == nil {
            cell = MenuCell(style:UITableViewCell.CellStyle.default, reuseIdentifier:identifier)
        }
        cell.selectionStyle = .none
        if let rowInfo = rowList[safe: indexPath.section] {
            cell.title.text = rowInfo[indexPath.row].0
            cell.info.text = rowInfo[indexPath.row].1
        }
        
        
        return cell
    }
}
