//
//  RealmInitializer.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/19.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmInitializer {
    
    static func setUp() {
        // Seed Data
        insertSeedData(CategorySeed())
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    private static func delete<T: Seed>(_ seed: T) where T.SeedType: Category {
        // realm
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(T.SeedType.self))
        }
    }
    
    // Realmファイルを作成する
    private static func insertSeedData<T: Seed>(_ seed: T) where T.SeedType: Category {
        // realm
        let realm = try! Realm()
        try! realm.write {
            T.items().forEach { val in
                realm.add(val, update: true)
            }
        }
    }
}
