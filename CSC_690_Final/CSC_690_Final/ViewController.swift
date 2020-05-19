//
//  ViewController.swift
//  CSC_690_Final
//
//  Created by Osbaldo Martinez on 5/8/20.
//  Copyright © 2020 Osbaldo Martinez. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var unfinishedTasks: [NSManagedObject] = []
    var selectedRow: Int?
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        title = "Task List"
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        unfinishedTasks.removeAll()
        let temp = getAllTasks()
        for element in temp {
            if (element.value(forKey: "complete") as? Bool == false) {
                unfinishedTasks.append(element)
            }
        }
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        let tableCell = tableView.cellForRow(at: indexPath)
        if tableCell?.imageView?.image == UIImage(named: "uncheckedBox") {
            tableCell?.imageView?.image = UIImage(named: "checkedBox")
            completeTask(byId: self.unfinishedTasks[indexPath.row].value(forKey: "id") as! String)
        } else {
            tableCell?.imageView?.image = UIImage(named: "uncheckedBox")
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTask(byId: self.unfinishedTasks[indexPath.row].value(forKey: "id") as! String)
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

