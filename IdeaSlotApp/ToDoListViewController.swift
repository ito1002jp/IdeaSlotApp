//
//  ViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/22.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController ,UIWebViewDelegate ,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var todoEntity : [ToDo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoEntity = ToDo.mr_findAll() as? [ToDo]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoEntity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WithIdentifier")
        cell?.textLabel!.text = todoEntity[indexPath.row].item
        return cell!
    }
}

