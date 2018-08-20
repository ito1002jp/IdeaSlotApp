//
//  WordsListViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/22.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift

class WordsListViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
        
    let realm = try? Realm()
    var wordEntities:Results<Words>? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wordEntities = realm?.objects(Words.self)
        if wordEntities != nil{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if wordEntities != nil{
            tableView.reloadData()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier:"TodoListItem01")!
        if let wordEntities = wordEntities{
            cell.textLabel!.text = wordEntities[indexPath.row].word
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let realm = try! Realm()
            try! realm.write {
                if let wordEntities = wordEntities{
                    realm.delete(wordEntities[indexPath.row])
                }
            }
            tableView.reloadData()
        }
    }
    
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

