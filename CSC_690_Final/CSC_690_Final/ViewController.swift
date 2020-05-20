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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task List"
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "task_cell")
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let temp = getAllTasks()
        for element in temp {
            if (element.value(forKey: "complete") as! Bool == false) {
                unfinishedTasks.append(element)
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        let tableCell = tableView.cellForRow(at: indexPath)
        if tableCell?.imageView?.image == UIImage(named: "uncheckedBox") {
            
            let alert = UIAlertController(title: "Edit Task", message: self.unfinishedTasks[indexPath.row].value(forKey: "task") as? String, preferredStyle: .alert)
                   
                   let saveAction = UIAlertAction(title: "Edit", style: .default) {
                        [unowned self] action in guard let textField = alert.textFields?.first, let taskToSave = textField.text else{
                        return
                    }
                    let success = editTaskById(taskId: (self.unfinishedTasks[indexPath.row].value(forKey: "id") as? String)!, newTask: taskToSave)
                    if (success) {
                        print("Edited Task.")
                    } else {
                        print("Edit task failed.")
                    }
                    self.unfinishedTasks[indexPath.row].setValue(taskToSave, forKey: "task")
                    self.tableView.reloadData()
            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: .default) {
                [unowned self] action in guard let textField = alert.textFields?.first, let taskToSave = textField.text else{
                    return
                }
                guard let t = self.unfinishedTasks[indexPath.row].value(forKey: "task") as? String else {
                    print("return error task")
                    return
                }
                guard let d = self.unfinishedTasks[indexPath.row].value(forKey: "completeBy") as? Date else {
                    print("return error date")
                    return
                }
                deleteEventFromCalendar(title: t, endDate: d)
                print(taskToSave)
                let success = deleteObject(taskId: (self.unfinishedTasks[indexPath.row].value(forKey: "id") as? String)!)
                if (success) {
                    print("Deleted Task.")
                } else {
                    print("Delete task failed.")
                }
                //remove deleted object from array
                self.unfinishedTasks.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            
            let completeTask = UIAlertAction(title: "Complete Task", style: .default) {
                [unowned self] action in guard let textField = alert.textFields?.first, let taskToSave = textField.text else{
                    return
                }
                print(taskToSave)
                let success = markCompleteTask(taskId: (self.unfinishedTasks[indexPath.row].value(forKey: "id") as? String)!)
                if (success) {
                    print("Completed Task.")
                } else {
                    print("Complete task failed.")
                }
                self.unfinishedTasks.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
                   
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                   
            alert.addTextField()
            
            alert.addAction(saveAction)
            if(self.unfinishedTasks[indexPath.row].value(forKey: "complete") as? Bool == false) {
                alert.addAction(completeTask)
            }
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
                   
            present(alert, animated: true)
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
        taskCell.textLabel?.text = "Task: \(selectedTask.value(forKeyPath: "task") as! String)  Days remaining to complete:\t\(daysToCompleteTask(finish: selectedTask.value(forKey: "completeBy") as! Date))"
        taskCell.imageView?.image = UIImage(named: "uncheckedBox")
        return taskCell
    }
}

