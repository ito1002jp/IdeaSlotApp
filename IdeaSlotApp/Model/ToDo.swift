//
//  ToDo.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/04.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

class ToDo: Object {
    @objc dynamic var item:String? = ""
}

class Base: Object{
    @objc dynamic var createDate = Date()
    @objc dynamic var updateDate = Date()
}

class User: Base{
    @objc dynamic var userId: String? = ""
    @objc dynamic var userName: String? = ""
    @objc dynamic var password: String? = ""
}

class Words: Base {
    @objc dynamic var wordId: String? = ""
    @objc dynamic var word: String? = ""
    @objc dynamic var categoryId: String? = ""
    @objc dynamic var userId: String? = ""
    @objc dynamic var ideaFlag: Int = 0
}

class Category: Base {
    @objc dynamic var categoryId: String? = ""
    @objc dynamic var categoryName: String? = ""
    @objc dynamic var userId: String? = ""
}

class Idea: Base {
    @objc dynamic var ideaId: String? = ""
    @objc dynamic var ideaName: String? = ""
    @objc dynamic var categoryId: String? = ""
    @objc dynamic var userId: String? = ""
    @objc dynamic var wordId_1: String? = ""
    @objc dynamic var operator_1: String? = ""
    @objc dynamic var wordId_2: String? = ""
    @objc dynamic var operator_2: String? = ""
    @objc dynamic var wordId_3: String? = ""
    @objc dynamic var operator_3: String? = ""
    @objc dynamic var detail: String? = ""
}
