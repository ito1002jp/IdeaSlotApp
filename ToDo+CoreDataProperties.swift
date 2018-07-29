//
//  ToDo+CoreDataProperties.swift
//  
//
//  Created by yuta akazawa on 2018/07/29.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var item: String?

}
