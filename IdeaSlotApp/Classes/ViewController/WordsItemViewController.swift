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
    var oldCategoryItem:Results<Category>? = nil

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
    @IBAction func cancel() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    // action save button
    @IBAction func save() {
        if word != nil{
            edit()
        }else{
            create()
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTitle(title: "Input Word")
        createNavigationBarButtonItem()
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
        
        let wordItem: [String: Any] = ["word": wordField.text!,
                                       "userId": "test-user",
                                       "createDate": Date(),
                                       "categoryId": categoryItem!.first!.categoryId,
                                       "categoryName": categoryName!]
        let newWord = Words(value: wordItem)
        let category = Category(value: [
            "categoryId": categoryItem!.first!.categoryId,
            "categoryName": categoryItem!.first!.categoryName])
        //insert
        try! realm.write(){
            realm.add(newWord)
            category.words.append(newWord)
            realm.create(Category.self, value: category, update: true)
        }
    }
    
    //edit word
    func edit() {
        self.categoryName = self.categoryButton.currentTitle
        self.categoryItem = findCategoryItem(categoryName: categoryName!)
        self.oldCategoryItem = findCategoryItem(categoryName: word!.categoryName!)

        if word != nil{
            let category = Category(value: [
                "categoryId": categoryItem!.first!.categoryId,
                "categoryName": categoryItem!.first!.categoryName])
            let removeWordItem = Array(oldCategoryItem!).first!
            let removeWordItemIndex = removeWordItem.words.index(matching: "wordId == %@", word!.wordId!)
            let oldCategory = Category(value: removeWordItem)
            let wordItem: [String: Any] = ["wordId": word!.wordId!,
                                           "word": wordField.text!,
                                           "userId": "test-user",
                                           "updateDate": Date(),
                                           "categoryId": categoryItem!.first!.categoryId,
                                           "categoryName": categoryName!]
            let editWord = Words(value: wordItem)
            //update
            try! realm.write(){
                realm.add(editWord, update: true)
                oldCategory.words.remove(at: removeWordItemIndex!)
                realm.create(Category.self, value: oldCategory, update: true)
                category.words.append(editWord)
                realm.create(Category.self, value: category, update: true)
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
    
    func createNavigationBarButtonItem(){
        // cancel button
        let leftBarbuttonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(WordsItemViewController.cancel))
        self.navigationItem.leftBarButtonItem = leftBarbuttonItem
        
        //save button
        let rightBarbuttonItem = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(WordsItemViewController.save))
        self.navigationItem.rightBarButtonItem = rightBarbuttonItem
    }
}
