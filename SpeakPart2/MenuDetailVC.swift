//
//  MenuDetailVC.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/2/13.
//  Copyright © 2019 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit
import UserNotifications

class MenuDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = String()
    
    let userDefaults = UserDefaults.standard
    
    let WIDTH = UIScreen.main.bounds.size.width
    let HEIGHT = UIScreen.main.bounds.size.height
    
    // sort
    var sortPickerView = UIView()
    var pickview = UIPickerView()
    let pickerData = ["New -> Old","Old -> New","Topic","Question"]
    var sortValueTamp = String()
    var sortValue: String {
        return userDefaults.string(forKey: "SORT") ?? "New -> Old"
    }
    
    // notifications
    var timePickerView = UIView()
    var datePicker = UIDatePicker()
    var switchValue: Bool {
        return userDefaults.bool(forKey: "NOTIFICATION")
    }
    var timeValueTamp = Date()
    var timeValue: Date {
        return userDefaults.value(forKey: "NOTIFICATION_TIME") as? Date ?? Date()
    }
    
   
    var rotationValue: [Int] {
        return userDefaults.array(forKey: "NOTIFICATION_DAY") as? [Int] ?? [1,2,3,4,5,6,7]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = currentPage
        setTableView()
        if currentPage == "Display"{
            setSortPickerView()
        }else {
            setTimePickerView()
        }
        
        
            
        let image = #imageLiteral(resourceName: "back-1")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(TestVC.navigationBackBtnTap))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func navigationBackBtnTap() {
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.bounces = true
        tableView.allowsSelection = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    func setSortPickerView(){
        sortPickerView = UIView(frame: CGRect(x: 0,y: HEIGHT,width: WIDTH,height: 250))
        view.addSubview(sortPickerView)
        
        pickview.frame = CGRect(x: 0,y: 44 ,width: WIDTH,height: 206)
        pickview.delegate = self
        pickview.dataSource = self
        pickview.backgroundColor = .white
        sortPickerView.addSubview(pickview)
        
        if let index = pickerData.index(where: {$0 == sortValue}) {
            pickview.selectRow(index, inComponent: 0, animated: false)
        }
        
        // Toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: pickview.frame.width, height: 44))
        toolBar.barStyle = .default
        toolBar.barTintColor = UIColor.appYellow
        toolBar.isTranslucent = true
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MenuDetailVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        sortPickerView.addSubview(toolBar)
    }
    func setTimePickerView(){
        timePickerView = UIView(frame: CGRect(x: 0,y: HEIGHT,width: WIDTH,height: 250))
        view.addSubview(timePickerView)
        
        datePicker.frame = CGRect(x: 0,y: 44 ,width: WIDTH,height: 206)
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .time

        // 設置預設時間為上次編輯時間
        datePicker.date = timeValue
        datePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        // 設置 Date 的格式
        let formatter = DateFormatter()
        // 設置時間顯示的格式
        formatter.dateFormat = "HH:mm"
        datePicker.addTarget(self, action:#selector(datePickerChanged), for: .valueChanged)
        
        timePickerView.addSubview(datePicker)
        
        // Toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: datePicker.frame.width, height: 44))
        toolBar.barStyle = .default
        toolBar.barTintColor = UIColor.appYellow
        toolBar.isTranslucent = true
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MenuDetailVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        timePickerView.addSubview(toolBar)
    }
    @objc func datePickerChanged(_ datePicker:UIDatePicker) {
        // 設置要顯示在 UILabel 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeValueTamp = datePicker.date
    }
    @objc func doneClick() {
        if currentPage == "Display"{
            userDefaults.set(sortValueTamp, forKey: "SORT")
            sortPickerView.frame.origin.y == self.HEIGHT ? viewslide(false) : viewslide(true)
        } else {
            userDefaults.set(timeValueTamp, forKey: "NOTIFICATION_TIME")
            timePickerView.frame.origin.y == self.HEIGHT ? viewslide(false) : viewslide(true)
            setNoitfications()
        }
        tableView.reloadData()
    }

    func viewslide(_ BOOL: Bool, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: { () -> Void in
                        if self.currentPage == "Display"{
                            self.sortPickerView.frame.origin.y = BOOL ? self.HEIGHT : self.HEIGHT - 250
                        }else {
                            self.timePickerView.frame.origin.y = BOOL ? self.HEIGHT : self.HEIGHT - 250
                        }
        },completion: nil)
    }
}
extension MenuDetailVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentPage == "Display"{
            viewslide(false)
        }else { // Reminder
            if indexPath.row == 1 {
                viewslide(false)
            }
        }
        
    }
    
}
extension MenuDetailVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPage == "Display" ? 1:3
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentPage == "Display"{
            let identifier: String = "MenuCell"
            var cell: MenuCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MenuCell
            if cell == nil {
                cell = MenuCell(style:UITableViewCell.CellStyle.default, reuseIdentifier:identifier)
            }
            cell.selectionStyle = .none
            cell.title.text = "Order on Record List"
            
            let sort = sortValue
            cell.info.text = sort
            
            return cell
        }else { // Reminder
            if indexPath.row == 0 {
                let identifier: String = "SwitchCell"
                var cell: SwitchCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SwitchCell
                if cell == nil {
                    cell = SwitchCell(style:UITableViewCell.CellStyle.default, reuseIdentifier:identifier)
                }
                cell.selectionStyle = .none
                cell.title.text = "Notifications"
                cell.switchBtn.addTarget(self, action: #selector(cellSwitchBtnActoins), for: .allTouchEvents)
                cell.switchBtn.isOn = switchValue
                
                return cell
            }else if indexPath.row == 1{
                let identifier: String = "MenuCell"
                var cell: MenuCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MenuCell
                if cell == nil {
                    cell = MenuCell(style:UITableViewCell.CellStyle.default, reuseIdentifier:identifier)
                }
                cell.selectionStyle = .none
                cell.title.text = "Time"
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                cell.info.text = formatter.string(from: timeValue)
                cell.line.isHidden = true
                
                return cell
            }else {
                let identifier: String = "WeekCell"
                var cell: WeekCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? WeekCell
                if cell == nil {
                    cell = WeekCell(style:UITableViewCell.CellStyle.default, reuseIdentifier:identifier)
                }
                cell.selectionStyle = .none
               
                return cell
            }
            
        }
    }
    
    @objc func cellSwitchBtnActoins(sender:UISwitch){
        if sender.isOn == true {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
                if granted {
                    print("允許")
                } else {
                    print("不允許，請至設定開啟通知")
                }
            })
            userDefaults.set(true, forKey: "NOTIFICATION")
        }else {
            userDefaults.set(false, forKey: "NOTIFICATION")
        }
        setNoitfications()
    }
    func addNotifications(){
        let center = UNMutableNotificationContent()
        center.body = "Time to hava test!"
        
        for i in rotationValue {
            
            let calendar = Calendar.current
            var components = calendar.dateComponents([ .hour, .minute], from: timeValue)
            components.weekday = i
            components.timeZone = .current
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: "timeNotifations", content: center, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }
    }
    
    func setNoitfications(){
        if switchValue {
            addNotifications()
//            let calendar = Calendar.current
//            let components = calendar.dateComponents([ .hour, .minute], from: timeValue)
//            let trigger = UNCalendarNotificationTrigger(dateMatching:
//                components, repeats: true)
//            let content = UNMutableNotificationContent()
//            content.body = "Time to hava test!"
//            let request = UNNotificationRequest(identifier:
//                "timeNotifations", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["timeNotifations"])
        }
    }
}
extension MenuDetailVC:UIPickerViewDelegate {
    // 內容文字
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    // 選擇時觸發
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sort = pickerData[pickerView.selectedRow(inComponent: 0)]
        sortValueTamp = sort
    }
}
extension MenuDetailVC:UIPickerViewDataSource {
    // 列數
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // 內容數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
}