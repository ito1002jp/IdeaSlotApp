//
//  ViewController.swift
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
    var todoEntities:Results<ToDo>? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoEntities = realm?.objects(ToDo.self)
        if todoEntities != nil{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if todoEntities != nil{
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let todoEntities = todoEntities{
            return todoEntities.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"TodoListItem01")!
        if let todoEntities = todoEntities{
            cell.textLabel!.text = todoEntities[indexPath.row].item
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let realm = try! Realm()
            try! realm.write {
                if let todoEntities = todoEntities{
                    realm.delete(todoEntities[indexPath.row])
                }
            }
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            let wordsItemViewController = segue.destination as! WordsItemViewController
            if let todoEntities = todoEntities{
                let task = todoEntities[tableView.indexPathForSelectedRow!.row]
                wordsItemViewController.task = task
            }
        }
    }
        
}

