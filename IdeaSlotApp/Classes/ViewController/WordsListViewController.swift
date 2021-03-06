//
//  WordsListViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/22.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift

class WordsListViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var wordEntities:Results<Words>? = nil
    var category:Category? = nil
    var searchController:UISearchController!
    var filteredWords = [Words]()
    var wordList = [Words]()

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        setNavigationBarTitle(title: "Words")
        setSearchController()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if category != nil {
            wordEntities = realm.objects(Words.self).filter("categoryId == %@", category!.categoryId).sorted(byKeyPath: "updateDate", ascending: false)
        }else{
            wordEntities = realm.objects(Words.self).sorted(byKeyPath: "updateDate", ascending: false)
        }
        tableView.reloadData()
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
        var categoryItem:Category? = nil
        var category:Array<Category>? = nil
        var item: [String: Any]? = nil

        if !categoryName.isEmpty{
            category = Array(findCategoryItem(categoryName: categoryName))
            if category!.count > 0{
                categoryItem = category?.first
                item = ["word": text,
                        //                                       "userId": "test-user",
                    "categoryId": categoryItem!.categoryId,
                    "categoryName": categoryName]
            }
        }else{
            item = ["word": text,
                    "categoryId": 0,
                    "categoryName": "No Category"]
        }
        
        let newWord = Words(value: item!)
        
        try! realm.write(){
            realm.add(newWord)
            if categoryItem != nil{
                categoryItem?.words.append(newWord)
            }
        }
    }
    
    //update word
    func updateWord(text: String, categoryName: String, wordItem: Words){
        var category:Array<Category>? = nil
        var categoryItem:Category? = nil
        let item: [String: Any]
        
        category = Array(findCategoryItem(categoryName: categoryName))
        if category!.count > 0{
            categoryItem = category?.first
            item = ["wordId": wordItem.wordId!,
            "word": text,
            //                                       "userId": "test-user",
            "updateDate": Date(),
            "categoryId": category!.first!.categoryId,
            "categoryName": category!.first!.categoryName]
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
            if categoryItem != nil{
                categoryItem!.words.append(editWord)
            }
            if removeWordItemIndex != nil{
                oldCategory!.words.remove(at: removeWordItemIndex!)
            }
        }
    }
    
    //set up searchcontroller
    func setSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = UIColor.AppColor.navigationTitle

        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        }else{
            self.navigationItem.titleView = searchController.searchBar
        }
        self.definesPresentationContext = true
    }
}

/**
 TableView Delegate
 **/
extension WordsListViewController: UITableViewDelegate{
    
    //editingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            try! realm.write {
                if let wordEntities = wordEntities{
                    realm.delete(wordEntities[indexPath.row])
                }
            }
        }
        tableView.reloadData()
    }
 
    /**
     display tableview header
     **/
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView()
        headerview.backgroundColor = UIColor.AppColor.backgroundHeader

        var item = WordItemView()
        item = Bundle.main.loadNibNamed("WordItemView", owner: self, options: nil)!.first! as! WordItemView
        item.delegate = self
        item.dropdown.dataSource = arrayCategoryList()
        if category != nil{
            item.categorybutton.setTitle(category?.categoryName, for: .normal)
        }
        
        if #available(iOS 11.0, *) {
            headerview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
            item.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:44)
        } else {
//            headerview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
//            item.frame = CGRect(x:0, y:55, width:self.view.frame.size.width, height:44)
            headerview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45)
            item.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:44)
//            searchController.searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
//            headerview.addSubview(searchController.searchBar)
        }
        headerview.addSubview(item)
        
        return headerview
    }
    
    /**
     tableview header height size
     **/
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if #available(iOS 11.0, *) {
            return 45
        }else{
            return 100
        }
    }
}

/**
 TableView DataSource
 **/
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
        let words: Words
        let cell = UITableViewCell()
        var itemView = WordItemView()
        itemView = Bundle.main.loadNibNamed("WordItemView", owner: self, options: nil)!.first! as! WordItemView

        if isFiltering(){
            words = filteredWords[indexPath.row]
        }else{
            words = wordEntities![indexPath.row]
        }
        
        itemView.delegate = self
        itemView.dropdown.dataSource = arrayCategoryList()
        itemView.textfield.text = words.word
        itemView.wordId = words.wordId
        itemView.beforeWord = words.word
        itemView.categorybutton.setTitle(words.categoryName, for: .normal)
        itemView.categoryName = words.categoryName
        itemView.beforecategoryName = words.categoryName
        cell.contentView.addSubview(itemView)

        return cell
    }
}

/**
 Textfield Delegate(extension WordTableViewCell)
 **/
extension WordsListViewController: InputTextDelegate{
    //textfield has finished to edit
    func textFieldDidEndEditing(item: WordItemView, value: String) -> () {
        if value != item.beforeWord || item.categoryName != item.beforecategoryName {
            saveWord(Id: item.wordId!, text: value, category: item.categoryName!)
        }
    }
}

/**
 SearchController SearchResultUpdating
 **/
extension WordsListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        wordList = Array(wordEntities!)

        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white

        let searchtext = searchController.searchBar.text!
        filteredWords = wordList.filter({( words : Words) -> Bool in
            return words.word!.lowercased().contains(searchtext.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
