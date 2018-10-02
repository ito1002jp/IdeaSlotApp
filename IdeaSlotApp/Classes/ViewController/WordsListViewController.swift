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

class WordsListViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    var wordEntities:Results<Words>? = nil
    var category:Category? = nil
    var categoryEntities:Results<Category>? = nil

    let realm = try! Realm()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if category != nil {
            wordEntities = realm.objects(Words.self).filter("categoryId == %@", category!.categoryId)
        }else{
            wordEntities = realm.objects(Words.self)
            if wordEntities != nil{
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        setNavigationBarTitle(title: "Words")
//        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let wordEntities = wordEntities{
            return wordEntities.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"TodoListItemCell")!
        if let wordEntities = wordEntities{
            cell.textLabel!.text = wordEntities[indexPath.row].word
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            try! realm.write {
                if let wordEntities = wordEntities{
                    realm.delete(wordEntities[indexPath.row])
                }
            }
            tableView.reloadData()
        }
    }
    
    //segue WordItemViewController (click word cell)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            let wordsItemViewController = segue.destination as! WordsItemViewController
            if let wordEntities = wordEntities{
                let word = wordEntities[tableView.indexPathForSelectedRow!.row]
                wordsItemViewController.word = word
            }
        }
    }
    
}

