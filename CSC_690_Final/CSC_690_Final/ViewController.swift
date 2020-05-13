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
    
    var unfinishedTasks: [NSManagedObject] = []
    var selectedRow: Int?
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task List"
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        unfinishedTasks = getAllTasks()
        tableView.reloadData()
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
            unfinishedTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unfinishedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "task_cell") ?? UITableViewCell()
        let selectedTask = unfinishedTasks[indexPath.row]
        taskCell.textLabel?.text = selectedTask.value(forKeyPath: "task") as? String
        taskCell.imageView?.image = UIImage(named: "uncheckedBox")
        return taskCell
    }
}

