//
//  UIViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/08.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

extension UIViewController{
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
//        self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
//        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
    }
    
    func setNavigationBarTitle(title: String){
        let navigationTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        navigationTitle.font = UIFont.systemFont(ofSize: 21)
        navigationTitle.text = title
        navigationTitle.textAlignment = .center
        self.navigationItem.titleView = navigationTitle
    }
    
    //return category name list
    func arrayCategoryList() -> Array<String> {
        let realm = try!Realm()
        var CategoryNameList: [String] = []
        let CategoryList = realm.objects(Category.self)
        
        //create ArrayList only categoryName
        for Category in CategoryList{
            CategoryNameList.append(Category.categoryName)
        }
        return CategoryNameList
    }
    
    //return one item Category filter by categoryName
    func findCategoryItem(categoryName: String) -> Results<Category> {
        let realm = try!Realm()
        let categoryItem = realm.objects(Category.self).filter("categoryName = %@",categoryName)
        return categoryItem
    }
    
    func setCateoryDropDown(button:UIButton, dropdown:DropDown){
        dropdown.anchorView = button
        dropdown.dataSource = arrayCategoryList()
        dropdown.selectionAction = {(index, item) in
            button.setTitle(item, for: .normal)
        }
    }
}
