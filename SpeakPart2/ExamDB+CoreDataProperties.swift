//
//  ExamDB+CoreDataProperties.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/19.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//
//

import Foundation
import CoreData


extension ExamDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExamDB> {
        return NSFetchRequest<ExamDB>(entityName: "ExamDB")
    }

    @NSManaged public var createtime: NSDate?
    @NSManaged public var qustopic: String?
    @NSManaged public var question: String?
    @NSManaged public var voiceAudio: String?

}
