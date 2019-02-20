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
        tableView.bounces = false
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
//        datePicker.timeZone = TimeZone.init(secondsFromGMT: 0)
        datePicker.locale = Locale(identifier: "en_GB")

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
//                formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
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
                
                setButtons(cell.mon)
                setButtons(cell.tue)
                setButtons(cell.wed)
                setButtons(cell.thu)
                setButtons(cell.fri)
                setButtons(cell.sat)
                setButtons(cell.sun)
                
                return cell
            }
            
        }
    }
    func setButtons(_ sender:UIButton){
        if rotationValue.contains(sender.tag) {
            sender.layer.borderColor = UIColor.white.cgColor
            sender.titleLabel?.textColor = UIColor.white
            sender.backgroundColor = UIColor.black
            sender.tintColor = UIColor.white
        }else {
            sender.layer.borderColor = UIColor.black.cgColor
            sender.titleLabel?.textColor = UIColor.black
            sender.backgroundColor = UIColor.white
            sender.tintColor = UIColor.black
        }
        sender.addTarget(self, action: #selector(weekBtnArrActions), for: .touchUpInside)
    }
    
    @objc func weekBtnArrActions(sender:UIButton){
        if rotationValue.contains(sender.tag) { // remove
            let value = rotationValue.filter({$0 != sender.tag})
            userDefaults.set(value, forKey: "NOTIFICATION_DAY")
        }else { // add
            var value = rotationValue
            value.append(sender.tag)
            userDefaults.set(value, forKey: "NOTIFICATION_DAY")
        }
        addNotifications()
        tableView.reloadData()
    }
    
    @objc func cellSwitchBtnActoins(sender:UISwitch){
        if sender.isOn == true {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
                if granted {
                    print("允許")
                    self.userDefaults.set(true, forKey: "NOTIFICATION")
                } else {
                    self.userDefaults.set(false, forKey: "NOTIFICATION")
                    
                    let alert = UIAlertController(title: "Settings -> \nIELTS Speaking Part 2 -> \nNotifications -> \nAllow Notifications", message: "", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    
                    // change to desired number of seconds (in this case 5 seconds)
                    let when = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        sender.isOn = false
                        alert.dismiss(animated: true, completion: nil)
                    }
                }

            })
            
        }else {
            userDefaults.set(false, forKey: "NOTIFICATION")
        }
        setNoitfications()
    }
    func addNotifications(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["timeNotifations"])

        let date = timeValue
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        for i in rotationValue {
            let date = createDate(weekday: i, hour: hour, minute: minutes)
            scheduleNotification(date: date, body: "Time to hava test!")
        }
    }
    func createDate(weekday: Int, hour: Int, minute: Int)->Date{
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.weekday = weekday
        components.weekdayOrdinal = 10
        components.timeZone = .current
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)!
    }
    //Schedule Notification with weekly bases.
    func scheduleNotification(date: Date, body: String) {
        
        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.body = body
        content.categoryIdentifier = "todoList"
        
        let request = UNNotificationRequest(identifier: "timeNotifations", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
    func setNoitfications(){
        if switchValue {
            addNotifications()
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
