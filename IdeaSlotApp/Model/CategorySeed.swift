//
//  CategorySeed.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/19.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

protocol Seed {
    associatedtype SeedType: Category
    static var values: [[Any]] { get }
    static func items() -> [SeedType]
}

extension Seed {
    static func items() -> [SeedType] {
        return values.map { val in
            let t = SeedType()
            t.categoryId = val[0] as! String
            t.categoryName = val[1] as! String
//            t.createDate = (val[2] as? Date)!
//            t.updateDate = (val[3] as? Date)!
            return t
        }
    }
}

struct CategorySeed: Seed {
    typealias SeedType = Category
    static var values: [[Any]] {
        return CategoryData.data
    }
}

struct CategoryData {
    static let data: [[Any]] = [
        ["1", "Food"],
        ["2", "Sports"],
        ["3", "Business"],
        ["4", "Fashion"],
        ["5", "Life-Style"],
        ["6", "Music"]
    ]
}
