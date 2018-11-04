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
    var searchController = UISearchController()
    var filteredWords = [Words]()
    var wordList = [Words]()

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setNavigationBarItem()
        setNavigationBarTitle(title: "Words")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "WordTableViewCell", bundle: nil), forCellReuseIdentifier: "WordItemCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.dismiss(animated: false, completion: nil)
        
        if category != nil {
            wordEntities = realm.objects(Words.self).filter("categoryId == %@", category!.categoryId).sorted(byKeyPath: "updateDate", ascending: false)
        }else{
            wordEntities = realm.objects(Words.self).sorted(byKeyPath: "updateDate", ascending: false)
        }
        
        if wordEntities != nil{
            let wordArray = Array(wordEntities!)
            wordList = wordArray.map({$0 as Words})
            
            wordList = Array(wordEntities!)
            tableView.reloadData()
            tableView.reloadSections(NSIndexSet(index: tableView.sectionIndexMinimumDisplayRowCount) as IndexSet, with: .none)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveWord(Id: String, text: String, category: String){
        var wordItem:Results<Words>? = nil
        var item:Words? = nil
        
        //No Category
        if !category.isEmpty{
            wordItem = wordEntities?.filter("wordId == %@", Id)
            item = wordItem?.first
        }
        
        //add Category
        if item == nil{
            //insert
            insertWord(text: text, categoryName: category)
        }else{
            //update
            updateWord(text: text, categoryName: category, wordItem: item!)
        }
        tableView.reloadData()
    }
    
    //insert new word
    func insertWord(text: String, categoryName: String){
        var categoryItem:Results<Category>? = nil
        var category:Category? = nil
        let item: [String: Any]

        if !categoryName.isEmpty{
            categoryItem = findCategoryItem(categoryName: categoryName)
            category = Category(value: [
                "categoryId": categoryItem!.first!.categoryId,
                "categoryName": categoryItem!.first!.categoryName])
            item = ["word": text,
                    //                                       "userId": "test-user",
                "categoryId": categoryItem!.first!.categoryId,
                "categoryName": categoryName]
        }else{
            item = ["word": text,
                    "categoryId": 0,
                    "categoryName": "No Category"]
        }
        
        let newWord = Words(value: item)
        
        try! realm.write(){
            realm.add(newWord)
            if category != nil{
                category?.words.append(newWord)
                realm.create(Category.self, value: category!, update: true)
            }
        }
    }
    
    //update word
    func updateWord(text: String, categoryName: String, wordItem: Words){
        var categoryItem:Results<Category>? = nil
        var category:Category? = nil
        let item: [String: Any]
        
        categoryItem = findCategoryItem(categoryName: categoryName)
        if categoryItem?.count != 0{
            category = Category(value: [
                "categoryId": categoryItem!.first!.categoryId,
                "categoryName": categoryItem!.first!.categoryName])
            item = ["wordId": wordItem.wordId!,
            "word": text,
            //                                       "userId": "test-user",
            "updateDate": Date(),
            "categoryId": categoryItem!.first!.categoryId,
            "categoryName": categoryItem!.first!.categoryName]
        }else{
            item = ["wordId": wordItem.wordId!,
                    "word": text,
                    //                                       "userId": "test-user",
                "categoryName": "No Category",
                "updateDate": Date()]
        }
        
        var oldCategoryItem:Results<Category>? = nil
        var removeWordItem:Category? = nil
        var removeWordItemIndex:Int? = nil
        var oldCategory:Category? = nil
        
        if wordItem.categoryId != 0{
            oldCategoryItem = findCategoryItem(categoryName: wordItem.categoryName!)
            removeWordItem = Array(oldCategoryItem!).first
            removeWordItemIndex = removeWordItem!.words.index(matching: "wordId == %@", wordItem.wordId!)
            oldCategory = Category(value: removeWordItem!)
        }
        

        let editWord = Words(value: item)
        try! realm.write(){
            realm.add(editWord, update: true)
            if category != nil{
                category!.words.append(editWord)
                realm.create(Category.self, value: category!, update: true)
            }
            if removeWordItemIndex != nil{
                oldCategory!.words.remove(at: removeWordItemIndex!)
                realm.create(Category.self, value: oldCategory!, update: true)
            }
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

//TableView Delegate
extension WordsListViewController: UITableViewDelegate{
    
    //editingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            try! realm.write {
                if let wordEntities = wordEntities{
                    print("indexPath.row: ",indexPath.row)
                    realm.delete(wordEntities[indexPath.row])
                }
            }
        }
        tableView.reloadSections(NSIndexSet(index: tableView.sectionIndexMinimumDisplayRowCount) as IndexSet, with: .none)
        tableView.reloadData()
    }
    
    //display tableview header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView()
        headerview.backgroundColor = UIColor.white

        let cell = tableView.dequeueReusableCell(withIdentifier:"WordItemCell") as! WordTableViewCell
        cell.delegate = self
        cell.dropdown.dataSource = arrayCategoryList()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        self.definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            headerview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
            cell.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:44)
            self.navigationItem.searchController = searchController
        } else {
            headerview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
            cell.frame = CGRect(x:0, y:55, width:self.view.frame.size.width, height:44)
            searchController.searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
            headerview.addSubview(searchController.searchBar)
        }
        
        headerview.addSubview(cell)
        
        return headerview
    }
    
    //tableview header height size
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if #available(iOS 11.0, *) {
            return 45
        }else{
            return 100
        }
    }
}

//TableView DataSource
extension WordsListViewController: UITableViewDataSource{
    //display cell count
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredWords.count
        } else {
            if let wordEntities = wordEntities{
                return wordEntities.count
            }
        }
        return 0
    }
    
    //display cell details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"WordItemCell") as! WordTableViewCell
        cell.delegate = self
        cell.dropdown.dataSource = arrayCategoryList()
        
        let words: Words
        
        if isFiltering(){
            words = filteredWords[indexPath.row]
        }else{
            words = wordEntities![indexPath.row]
        }
        
        cell.textfield.text = words.word
        cell.wordId = words.wordId
        cell.beforeWord = words.word
        cell.categorybutton.setTitle(words.categoryName, for: .normal)
        cell.categoryName = words.categoryName
        cell.beforecategoryName = words.categoryName

        
//        if isFiltering() {
//            cell.textfield.text = searchResults[indexPath.row].word
//            cell.wordId = searchResults[indexPath.row].wordId
//            cell.beforeWord = searchResults[indexPath.row].word
//            cell.categorybutton.setTitle(searchResults[indexPath.row].categoryName, for: .normal)
//            cell.categoryName = searchResults[indexPath.row].categoryName
//            cell.beforecategoryName = searchResults[indexPath.row].categoryName
//        }else{
//            if let wordEntities = wordEntities{
//                cell.textfield.text = wordEntities[indexPath.row].word
//                cell.wordId = wordEntities[indexPath.row].wordId
//                cell.beforeWord = wordEntities[indexPath.row].word
//                cell.categorybutton.setTitle(wordEntities[indexPath.row].categoryName, for: .normal)
//                cell.categoryName = wordEntities[indexPath.row].categoryName
//                cell.beforecategoryName = wordEntities[indexPath.row].categoryName
//            }
//        }
        return cell
    }
}

//Textfield Delegate(extension WordTableViewCell)
extension WordsListViewController: InputTextTableCellDelegate{
    //textfield has finished to edit
    func textFieldDidEndEditing(cell: WordTableViewCell, value: String) -> () {
        if value != cell.beforeWord || cell.categoryName != cell.beforecategoryName {
            saveWord(Id: cell.wordId!, text: value, category: cell.categoryName!)
        }
    }
}

//SearchController SearchResultUpdating
extension WordsListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredWords = wordList.filter({( words : Words) -> Bool in
            return words.word!.lowercased().contains(searchText.lowercased())
        })
        print(searchText)
        print(wordList)
        print(filteredWords)
        
        tableView.reloadData()
    }
}
