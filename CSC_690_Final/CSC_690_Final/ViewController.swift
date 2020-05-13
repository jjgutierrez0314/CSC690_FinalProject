//
//  ViewController.swift
//  CSC_690_Final
//
//  Created by Osbaldo Martinez on 5/8/20.
//  Copyright © 2020 Osbaldo Martinez. All rights reserved.
//

import UIKit
import CoreData

struct Task {
    let task: String
//    let createdOn: Date
//    let completeBy: Date
//    let complete: Bool
    
    init(task: String
//        , createdOn: Date, completeBy: Date, complete: Bool
    ) {
        self.task = task
//        self.createdOn = createdOn
//        self.completeBy = completeBy
//        self.complete = complete
    }
    
    init?(managedObject: NSManagedObject) {
        guard let task = managedObject.value(forKey: "task") as? String else {
            return nil
        }
        self.task = task
//        self.createdOn = createdOn
//        self.completeBy = completeBy
//        self.complete = complete
    }
}

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var task: [Task] = []
    var selectedRow: Int?
    //var databaseFunc = DatabaseController()
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        //task = databaseFunc.getAllTask()
        tableView.reloadData()
    }
    
    @IBAction func addTask(_ sender: Any) {
        print("Adding a task")
        let alert = UIAlertController(title: "New Task",message: "" ,preferredStyle: .alert)
        
        let done = UIAlertAction(title: "Add a New Task", style: .default) { _ in
                   guard let taskName = alert.textFields?.first?.text else {
                       return
                   }
                   let task = Task(task: taskName)

                   self.task.append(task)
                   //self.store.store(task: task)

                   self.tableView.beginUpdates()
                   
                   let indexPath = IndexPath(row: self.task.count - 1, section: 0)
                   
                   self.tableView.insertRows(at: [indexPath], with: .automatic)
                   
                   self.tableView.endUpdates()
                   print(taskName)
                   
               }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(done)
        alert.addAction(cancel)
        alert.addTextField { textField in
            textField.placeholder = "Add a task"
        }
        present(alert, animated: true, completion: nil)
    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        let tableCell = tableView.cellForRow(at: indexPath)
        if tableCell?.imageView?.image == UIImage(named: "uncheckedBox") {
            tableCell?.imageView?.image = UIImage(named: "checkedBox")
        } else {
            tableCell?.imageView?.image = UIImage(named: "uncheckedBox")
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //store.delete(position: indexPath.row)
            task.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "task_cell") ?? UITableViewCell()
        let task = self.task[indexPath.row]
        taskCell.textLabel?.text = task.task
        taskCell.imageView?.image = UIImage(named: "uncheckedBox")
        return taskCell
    }
}

