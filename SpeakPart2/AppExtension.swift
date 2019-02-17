//
//  AppExtension.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/19.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    static let appYellow = UIColor(red:246/255, green:221/255 ,blue:85/255 , alpha:1.0)
    static let appGreen = UIColor(red:104/255, green:120/255 ,blue:48/255 , alpha:1.0)
    static let app155Gray = UIColor(red:155/255, green:155/255 ,blue:155/255 , alpha:1.0)
    
}
extension Array {
    /// 安全的 array index，防止 index out of range
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
   
}
extension UIFont {
    
    class func regularFont(_ size: CGFloat) -> UIFont{
        return UIFont(name: "PingFangSC-Regular", size: size)!
    }
    
    class func lightFont(_ size: CGFloat) -> UIFont{
        return UIFont(name: "PingFangSC-Light", size: size)!
    }
    
    class func semiboldFont(_ size: CGFloat) -> UIFont{
        return UIFont(name: "PingFangSC-Semibold", size: size)!
    }
}
extension NSDate
{
    func toString(_ format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
    
}
