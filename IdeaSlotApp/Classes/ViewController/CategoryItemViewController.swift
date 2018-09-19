//
//  CategoryItemViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/19.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryItemViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle(title: "New Category")
        createNavigationBarButtonItem()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //action cancel button
    @IBAction func cancel() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // action save button
    @IBAction func save() {
        createNewCategory()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func createNewCategory(){
        let realmCommonLogic = RealmCommonLogic()
        let category: [String:Any] = [
            "categoryId": realmCommonLogic.getCategoryMaxId(),
            "categoryName": textField.text!]
        let newCategory = Category(value: category)
        //insert
        try! realm.write(){
            realm.add(newCategory)
        }
    }

    func createNavigationBarButtonItem(){
        // cancel button
        let leftBarbuttonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(CategoryItemViewController.cancel))
        self.navigationItem.leftBarButtonItem = leftBarbuttonItem
        
        //save button
        let rightBarbuttonItem = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(CategoryItemViewController.save))
        self.navigationItem.rightBarButtonItem = rightBarbuttonItem
    }

}
