//
//  ViewController.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/18.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import Foundation
import UIKit

class Utl {
    
    /// 取得指定的ViewController
    /// - Parameter storyboard : 該ViewController所屬的Storyboard的名稱
    /// - Parameter identifier : 該ViewController的identifier
    /// - Author : Albert
    /// - Date : 20160527
    /// - Returns: 指定的ViewController
    static func getViewControllerWithStoryboard(_ storyboard: String, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }
    
    
    /// 取得螢幕大小
    ///
    /// (get SCREEN SIZE)
    /// - Returns :     3.5     iphone4,4s;
    ///                 4       iphone5,5s;
    ///                 4.7     iphone6,6s;
    ///                 5.5     iphone6 plus,6s plus;
    /// - Author : 施舜傑(SHUN)
    /// - Date : 20160406
    static func getScreenSize() -> Double {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHieght = UIScreen.main.bounds.size.height
        let screenMaxLength = max(screenWidth, screenHieght)
        //let screenMinLength = min(screenWidth, screenHieght)
        
        ///Get current device is iphone or ipad
        //var device : UIUserInterfaceIdiom = UIDevice.currentDevice().userInterfaceIdiom
        var deviceScreenSize : Double = 0
        
        if (screenMaxLength < 568.0){
            deviceScreenSize = 3.5
        }else if (screenMaxLength == 568.0){
            deviceScreenSize = 4
        }else if (screenMaxLength == 667){
            deviceScreenSize = 4.7
        }else if (screenMaxLength == 736){
            deviceScreenSize = 5.5
        }else if (screenMaxLength == 812){
            deviceScreenSize = 5.8
        }
        return deviceScreenSize
    }
    static func setCircleSize(baseSize:CGFloat) -> CGFloat {
        var fontSize : CGFloat = baseSize
        let screenSize =  Utl.getScreenSize()
        switch screenSize {
        case 3.5:
            fontSize = (320 / 375) * baseSize
        case 4:
            fontSize = (320 / 375) * baseSize
        case 4.7:
            fontSize = baseSize
        case 5.5:
            fontSize = (414 / 375) * baseSize
        case 5.8:
            fontSize = baseSize
        default:
            break
        }
        
        return fontSize
    }
    static func setLabelFontSize() -> CGFloat {
        var fontSize : CGFloat = 15
        let screenSize =  getScreenSize()
        
        switch screenSize {
        case 3.5:
            fontSize = 14
        case 4:
            fontSize = 14
        case 4.7:
            fontSize = 15
        case 5.5:
            fontSize = 15
        case 5.8:
            fontSize = 15
        default:
            break
        }
        return fontSize
    }
    static func fontSize(size:CGFloat) -> CGFloat {
        var fontSize : CGFloat = size
        let screenSize =  getScreenSize()
        
        switch screenSize {
        case 3.5:
            fontSize = size - 1
        case 4:
            fontSize = size - 1
        case 4.7:
            fontSize = size
        case 5.5:
            fontSize = size
        case 5.8:
            fontSize = size
        default:
            break
        }
        return fontSize
    }
    
    /// 傳回手機目前的語言
    ///
    /// (get iPhone language now)
    /// - Returns : zh-Hant 繁體中文; zh-Hans 簡體中文; zh-TW 台灣; zh-HK 香港
    /// - Author : 陳世斌(bsc)
    /// - Date : 20160331
    static func getLanguage()->String {
        let defs : UserDefaults = UserDefaults.standard
        let languages : NSArray? = defs.object(forKey: "AppleLanguages") as? NSArray
        if languages != nil {
            return  languages!.object(at: 0) as! String
        }
        return ""
    }
    
    /// 取得IOS版本
    ///
    /// (get IOS System Version)
    /// - Author : 陳世斌(bsc)
    /// - Date : 20160331
    static func getIosVersion()->String {
        return UIDevice.current.systemVersion
    }
    
    /// 修正NSLocalizedString某些情況無法正確顯示該國語言字串, 參數跟傳回值同NSLocalizedString
    ///
    /// fix NSLocalizedString(key, comment:comment) issue
    /// - Author : 陳世斌(bsc)
    /// - Date : 20160331
    static func fixNSLocalizedString(_ key:String, comment:String)->String {
        // IOS 9的多國語言有issue, 當找不到對應的語言時, 會用上一個語言所對應的檔
        // IOS 8.4則會正確
        let language = self.getLanguage()
        //print(language)
        let ver = self.getIosVersion()
        //let version = Double(ver)!
        let string = NSString(string: ver)
        let version = string.doubleValue
        //print(version)
        
        if version >= 9.0 &&
            language.caseInsensitiveCompare("zh-TW") != .orderedSame &&
            language.caseInsensitiveCompare("zh-HK") != .orderedSame &&
            language.hasPrefix("zh-Han") != true {
            let path = Bundle.main.path(forResource: "Base", ofType:"lproj")
            
            let ret : String? = Bundle(path: path!)!.localizedString(forKey: key, value:comment, table:nil)
            if ret! == key {
                // 沒找到path裡對應檔裡的資料
                return NSLocalizedString(key, comment:comment)
            }
            return ret!
        }
        else {
            return NSLocalizedString(key, comment:comment)
        }
    }
    
    /// 修正NSLocalizedString某些情況無法正確顯示該國語言字串, 將參數轉成英文語系文字
    ///
    /// fix NSLocalizedString(key, comment:comment) issue
    /// - Author :
    /// - Date : 20161220
    static func fixToEnglishString(_ key:String, comment:String)->String {
        // IOS 9的多國語言有issue, 當找不到對應的語言時, 會用上一個語言所對應的檔
        // IOS 8.4則會正確
        let language = "en-US"
        //print(language)
        let ver = self.getIosVersion()
        //let version = Double(ver)!
        let string = NSString(string: ver)
        let version = string.doubleValue
        //print(version)
        
        if version >= 9.0 &&
            language.caseInsensitiveCompare("zh-TW") != .orderedSame &&
            language.caseInsensitiveCompare("zh-HK") != .orderedSame &&
            language.hasPrefix("zh-Han") != true {
            let path = Bundle.main.path(forResource: "Base", ofType:"lproj")
            
            let ret : String? = Bundle(path: path!)!.localizedString(forKey: key, value:comment, table:nil)
            if ret! == key {
                // 沒找到path裡對應檔裡的資料
                return NSLocalizedString(key, comment:comment)
            }
            return ret!
        }
        else {
            return NSLocalizedString(key, comment:comment)
        }
    }
    
    /// Alert message. 顯示一個訊息提示的對話盒(只有確認鍵)
    ///
    /// Alert Message
    /// - Parameter view : target UIViewController to show
    /// - Parameter title : totle string
    /// - Parameter message : message string
    /// - Author : 陳世斌(bsc)
    /// - Date : 20160407
    static func alertMessage(_ view:UIViewController, title:String, message:String,closure: @escaping ((String)->())) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesButton = UIAlertAction(title: Utl.fixNSLocalizedString("ok", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            closure(title)
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(yesButton)
        DispatchQueue.main.async {
            view.present(alert, animated: false, completion: nil)
        }
    }
    
    /// Alert message. 顯示一個訊息提示的對話盒(只有確認鍵)
    ///
    /// Alert Message
    /// - Parameter view : target UIViewController to show
    /// - Parameter title : totle string
    /// - Parameter message : message string
    /// - Author : 陳世斌(bsc)
    /// - Date : 20160407
    static func alertMessage(_ view:UIViewController, title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesButton = UIAlertAction(title: Utl.fixNSLocalizedString("ok", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(yesButton)
        DispatchQueue.main.async {
            view.present(alert, animated: false, completion: nil)
        }
    }
    
    
    /// Alert message. 顯示一個訊息提示的對話盒(只有確認鍵，可選字對齊位置)
    ///
    /// Alert Message
    /// - Parameter view : target UIViewController to show
    /// - Parameter title : totle string
    /// - Parameter message : message string
    /// - Author : 陳世斌(bsc)
    /// - Date : 20160407
    static func alertMessage(_ view:UIViewController, title:String, message:String,messageAligment:NSTextAlignment) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesButton = UIAlertAction(title: Utl.fixNSLocalizedString("ok", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(yesButton)
        
        // message text alignment left
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = messageAligment
        
        let messageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
            ]
        )
        
        alert.setValue(messageText, forKey: "attributedMessage")
        
        DispatchQueue.main.async {
            view.present(alert, animated: false, completion: nil)
        }
    }
    
    /// Alert message. 顯示一個訊息提示的對話盒(只有確認鍵，可調fontSize)
    ///
    /// Alert Message
    /// - Parameter view : target UIViewController to show
    /// - Parameter title : totle string
    /// - Parameter message : message string
    /// - Author : 陳世斌(bsc)
    /// - Date : 20160407
    static func alertMessage(_ view:UIViewController, title:String, message:String,fontAdjust:Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesButton = UIAlertAction(title: Utl.fixNSLocalizedString("ok", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(yesButton)
        
        
        if fontAdjust{
            // ------------  set font  size -------------
            var fontSize : CGFloat = 14
            let screenSize =  Utl.getScreenSize()
            
            switch screenSize {
            case 3.5:
                fontSize = 12
            case 4:
                fontSize = 12
            case 4.7:
                fontSize = 14
            case 5.5:
                fontSize = 14
            default:
                break
            }
            let messageText = NSMutableAttributedString(
                string: message,
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            )
            
            alert.setValue(messageText, forKey: "attributedMessage")
        }
        
        DispatchQueue.main.async {
            view.present(alert, animated: false, completion: nil)
        }
    }
    
    /// Alert message. 顯示一個訊息提示的對話盒(最多三個鍵, 最少要一個右鍵)
    /// - Parameter viewController    : target UIViewController to show
    /// - Parameter title             : totle string
    /// - Parameter message           : message string
    /// - Parameter leftButtonTitle   : 通常是cancel鍵
    /// - Parameter centerButtonTitle : 通常是no鍵
    /// - Parameter rightButtonTitle  : 通常是yes鍵
    /// - Parameter messageAligment   : message對齊方式
    static func alertMessage(_ viewController:UIViewController, title:String?, message:String?,leftButtonTitle:String?,centerButtonTitle:String?,rightButtonTitle:String,messageAligment:NSTextAlignment,closure: ((String)->())?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if leftButtonTitle != nil {
            let leftButton = UIAlertAction(title: leftButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
                closure?(leftButtonTitle!)
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(leftButton)
        }
        
        if centerButtonTitle != nil {
            let centerButton = UIAlertAction(title: centerButtonTitle, style: .default , handler: { (action: UIAlertAction!) in
                closure?(centerButtonTitle!)
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(centerButton)
        }
        
        let rightButton = UIAlertAction(title: rightButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
            closure?(rightButtonTitle)
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(rightButton)
        
        // message text alignment left
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = messageAligment
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: false, completion: nil)
        }
    }
    static func autoDismissAlert(_ viewController:UIViewController,title:String){
        let alert = UIAlertController(title: title,message: nil, preferredStyle: .alert)
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            viewController.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    static func autoDismissAlert(_ viewController:UIViewController,title:String,message:String,closure: ((String)->())?){
        let alert = UIAlertController(title: title,message: message, preferredStyle: .alert)
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            viewController.presentedViewController?.dismiss(animated: false, completion: {
                closure?("finish")
            })
        }
    }
    
    /// 將16進制的數值轉成UICOlor
    /// - Parameter regHex : 16進制reg值, ex:0x2891FF
    /// - Parameter alpha : alpha值, ex:0xff
    /// - Author : 陳世斌(bsc)
    /// - Date : 20160712
    static func rgbHexColor(_ rgbHex:Int, alpha : Int)->UIColor {
        let r : CGFloat = CGFloat(((rgbHex >> 16) & 0x000000FF)) / 0xff
        let g : CGFloat = CGFloat(((rgbHex >> 8) & 0x000000FF)) / 0xff
        let b : CGFloat = CGFloat((rgbHex & 0x000000FF)) / 0xff
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha)/0xff)
    }
    
    /// 將 Hex String數值轉成UICOlor
    /// - Parameter hex : ex: CCCCCC
    static func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = String(describing: [cString.utf16.index(cString.startIndex, offsetBy: 1)...])

        }
        
        if ((cString.utf16.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    /// 設為圓形View
    ///
    /// (set round UIView)
    /// - Parameter view : 來源UIView
    /// - Author : 陳世斌(bsc)
    /// - Date : 20160407
    static func setRoundView(_ view:UIView, borderWidth:Float, borderColor:UIColor?) {
        view.clipsToBounds = true
        view.layer.cornerRadius = view.bounds.size.height/2
        if borderColor != nil {
            view.layer.borderColor = borderColor!.cgColor
            view.layer.borderWidth = CGFloat(borderWidth)
            view.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    /// 檢查APP 是否有最新版本 , 以及回傳Store 最新版本
    /// - returns:
    ///     - isAppNeedsUpdate
    ///
    ///             True    :   版本不一致,需要更新
    ///             False   :   版本一致,不需要更新
    ///             Nil     :   例外錯誤
    ///
    ///     - currentAppStroeVersion
    ///
    ///             Store 最新版本
    static func isAppNeedsUpdate() -> ( isAppNeedsUpdate : Bool? , currentAppStroeVersion : String? ) {
        var infoDictionary = Bundle.main.infoDictionary!
        
        /// Check Network
        if !Reachability.isConnectedToNetwork() {
            print("No Network")
            return ( nil , nil )
        }
        
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=1401854438") ,
            let data = try? Data(contentsOf: url) else{
                print("isAppNeedsUpdate Something Error")
                return ( nil , nil )
        }
        
        var lookup: [String:Any]?
        
        do{
            lookup = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        }catch let error {
            print("isAppNeedsUpdate error: \(error)")
        }
        
        
        guard let
            /// 取得目前手機版本
            currentVersion = infoDictionary["CFBundleShortVersionString"] as? String ,
            let resultCount = lookup?["resultCount"] as? Int ,
            let appStoreVersion = (lookup?["results"] as? [[String : Any]])?[0]["version"] as? String else{
                print("isAppNeedsUpdate Something Error")
                return ( nil , nil )
        }
        
        //print("Need to update [\(appStoreVersion) != \(currentVersion)]")
        
        if resultCount == 1 {
            
            if appStoreVersion.compare(currentVersion, options: NSString.CompareOptions.numeric ) == .orderedDescending {
                /// 版本小於現在版本,需要更新
                print("Need to update [\(appStoreVersion) != \(currentVersion)]")
                return ( true , appStoreVersion )
            }else{
                /// 版本大於等於,不需要更新
                return ( false , appStoreVersion )
            }
        }
        
        return ( nil , nil )
    }
    
    /// 將queryString轉為Dictionary結構
    /// - Parameter query : key1=value1&key2=value2
    /// - Returns : dic[key1] = value1; dic[key2]  = value2
    static func transformQueryStringToDictionary(_ query: String) -> [String : String] {
        var dic: [String : String] = [:]
        
        let parameterList = query.components(separatedBy: "&")
        for parameter in parameterList {
            let keyAndValue = parameter.components(separatedBy: "=")
            dic[keyAndValue[0]] = keyAndValue[1]
        }
        
        return dic
    }
    
    static func local(_ str:String) -> String{
        return Utl.fixNSLocalizedString(str, comment: "")
    }
   
//    static func retCodeToString(retCode:CloudReturnCodeEnum) ->String{
//        let retCd = retCode
//        let retString = Utl.local("\(retCd)")
//        return retString
//    }
}
