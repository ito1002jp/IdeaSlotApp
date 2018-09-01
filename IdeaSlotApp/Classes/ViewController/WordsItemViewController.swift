//
//  WordsItemViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/29.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

class WordsItemViewController: UIViewController {
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var wordField: UITextField!
    var word:Words? = nil
    var categoryName:String? = nil
    var categoryItem:Results<Category>? = nil

    let realm = try! Realm()
    let categoryDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.categoryDropDown
        ]
    }()
    
    //action CategoryDronDownButton
    @IBAction func showCategoryButton(_ sender: Any) {
        categoryDropDown.show()
    }
    
    //action cancel button
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // action save button
    @IBAction func save(_ sender: UIButton) {
        if word != nil{
            edit()
        }else{
            create()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCategoryDropDown()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        //from 'edit'
        if let taskToDo = word{
            wordField.text = taskToDo.word
            if taskToDo.categoryName != nil{
                categoryButton.setTitle(taskToDo.categoryName, for: .normal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //save new word
    func create() {
        self.categoryName = self.categoryButton.currentTitle
        self.categoryItem = findCategoryItem(categoryName: categoryName!)
        
        let category = Category(value: [
            "categoryId": categoryItem?.first?.categoryId,
                                            "categoryName": categoryItem?.first?.categoryName])
        let wordItem: [String: Any] = ["word": wordField.text!,
                                       "userId": "test-user",
                                       "createDate": Date(),
                                       "categoryName": categoryName!]
        let newWord = Words(value: wordItem)
        //insert
        try! realm.write(){
            realm.add(newWord)
            category.words.append(newWord)
        }
    }
    
    //edit word
    func edit() {
        self.categoryName = self.categoryButton.currentTitle
        self.categoryItem = findCategoryItem(categoryName: categoryName!)

        if word != nil{
            let category = Category(value: [
                "categoryId": categoryItem?.first?.categoryId,
                "categoryName": categoryItem?.first?.categoryName])
            let wordItem: [String: Any] = ["wordId": word!.wordId!,
                                           "word": wordField.text!,
                                           "userId": "test-user",
                                           "createDate": Date(),
                                           "categoryName": categoryName!]
            let editWord = Words(value: wordItem)
            //update
            try! realm.write(){
                realm.add(editWord, update: true)
                category.words.append(editWord)
            }
        }
    }
    
    //setting DropDown(Category)
    func setupCategoryDropDown(){
        categoryDropDown.anchorView = categoryButton
        categoryDropDown.dataSource = arrayCategoryList()
        categoryDropDown.selectionAction = { [weak self] (index, item) in
            self?.categoryButton.setTitle(item, for: .normal)
        }
    }
    
    //return category name list
    func arrayCategoryList() -> Array<String> {
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
        let categoryItem = realm.objects(Category.self).filter("categoryName = %@",categoryName)
        return categoryItem
    }
}
