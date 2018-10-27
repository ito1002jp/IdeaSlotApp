//
//  WordsListViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/22.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import SlideMenuControllerSwift

class WordsListViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var wordEntities:Results<Words>? = nil
    var category:Category? = nil

    let realm = try! Realm()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if category != nil {
            wordEntities = realm.objects(Words.self).filter("categoryId == %@", category!.categoryId)
        }else{
            wordEntities = realm.objects(Words.self)
        }
        
        if wordEntities != nil{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setNavigationBarItem()
        setNavigationBarTitle(title: "Words")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WordsListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            try! realm.write {
                if let wordEntities = wordEntities{
                    realm.delete(wordEntities[indexPath.row])
                }
            }
            tableView.reloadData()
        }
    }
    
    func saveWord(Id: String, text: String, category: String){
        let wordItem = wordEntities?.filter("wordId == %@", Id)
        if wordItem == nil{
            //insert
            insertWrd(text: text, categoryName: category)
        }else{
            //update
            let item = wordItem?.first
            updateWord(text: text, categoryName: category, wordItem: item!)
        }
    }
    
    //insert new word
    func insertWrd(text: String, categoryName: String){
        let categoryItem = findCategoryItem(categoryName: categoryName)
        let item: [String: Any] = ["word": text,
//                                       "userId": "test-user",
            "categoryId": categoryItem.first!.categoryId,
                                       "categoryName": categoryName]
        let newWord = Words(value: item)
        let category = Category(value: [
            "categoryId": categoryItem.first!.categoryId,
            "categoryName": categoryItem.first!.categoryName])

        try! realm.write(){
            realm.add(newWord)
            category.words.append(newWord)
            realm.create(Category.self, value: category, update: true)
        }
    }
    
    //update word
    func updateWord(text: String, categoryName: String, wordItem: Words){
        let categoryItem = findCategoryItem(categoryName: categoryName)
        let oldCategoryItem = findCategoryItem(categoryName: wordItem.categoryName!)
        let category = Category(value: [
            "categoryId": categoryItem.first!.categoryId,
            "categoryName": categoryItem.first!.categoryName])
        
        let removeWordItem = Array(oldCategoryItem).first!
        let removeWordItemIndex = removeWordItem.words.index(matching: "wordId == %@", wordItem.wordId!)
        let oldCategory = Category(value: removeWordItem)
        let item: [String: Any] = ["wordId": wordItem.wordId!,
                                       "word": text,
//                                       "userId": "test-user",
                                       "updateDate": Date(),
                                       "categoryId": categoryItem.first!.categoryId,
                                       "categoryName": categoryItem.first!.categoryName]
        let editWord = Words(value: item)

        try! realm.write(){
            realm.add(editWord, update: true)
            category.words.append(editWord)
            realm.create(Category.self, value: category, update: true)
            if removeWordItemIndex != nil{
                oldCategory.words.remove(at: removeWordItemIndex!)
                realm.create(Category.self, value: oldCategory, update: true)
            }
        }
    }
}

extension WordsListViewController: UITableViewDataSource{
    //display cell count
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let wordEntities = wordEntities{
            return wordEntities.count
        }
        return 1
    }
    
    //display cell details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"WordItemCell") as! WordTableViewCell
        cell.delegate = self
        cell.dropdown.dataSource = arrayCategoryList()

        if let wordEntities = wordEntities{
            cell.textfield.text = wordEntities[indexPath.row].word
            cell.wordId = wordEntities[indexPath.row].wordId
            cell.beforeWord = wordEntities[indexPath.row].word

            if wordEntities[indexPath.row].categoryName != nil{
                cell.categorybutton.setTitle(wordEntities[indexPath.row].categoryName, for: .normal)
                cell.categoryName = wordEntities[indexPath.row].categoryName
                cell.beforecategoryName = wordEntities[indexPath.row].categoryName
            }
        }
        return cell
    }
}

extension WordsListViewController: InputTextTableCellDelegate{
    //textfield has finished to edit
    func textFieldDidEndEditing(cell: WordTableViewCell, value: String) -> () {
        print("finished edit")
        
        if value != cell.beforeWord || cell.categoryName != cell.beforecategoryName {
            saveWord(Id: cell.wordId!, text: value, category: cell.categoryName!)
        }
    }
}
