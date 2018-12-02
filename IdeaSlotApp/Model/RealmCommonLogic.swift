//
//  RealmCommonLogic.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/19.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCommonLogic{
    let realm = try! Realm()
    var categoryMaxId: Int { return (realm.objects(Category.self).sorted(byKeyPath: "categoryId", ascending: true).last?.categoryId)!}
    
    func getCategoryMaxId() -> Int {
        let maxId = categoryMaxId + 1
        return maxId
    }
}
