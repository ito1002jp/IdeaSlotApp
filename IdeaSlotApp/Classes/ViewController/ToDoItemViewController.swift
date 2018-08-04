//
//  TodoItemViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/29.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoItemViewController: UIViewController {
    @IBOutlet weak var todoField: UITextField!

    var task:ToDo? = nil
    let realm = try! Realm()
    
    @IBAction func cansel(_ sender: UIBarButtonItem) {
        navigationController!.popViewController(animated:true)
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
//        if task != nil{
//            editTask()
//        }else{
//            createTask()
//        }

        navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let taskToDo = task{
            todoField.text = taskToDo.item
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createTask() {
        let newTask = ToDo()
        newTask.item = todoField.text
        try! realm.write(){
            realm.add(newTask)
        }
    }
    
    func editTask() {
        if let task = task{
            try! realm.write(){
                task.item = todoField.text
                realm.add(task)
            }
        }
    }
}
