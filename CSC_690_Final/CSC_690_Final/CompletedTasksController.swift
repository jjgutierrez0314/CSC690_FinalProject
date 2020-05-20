//
//  CompletedTasksController.swift
//  CSC_690_Final
//
//  Created by John Joshua Gutierrez on 5/19/20.
//  Copyright © 2020 Osbaldo Martinez. All rights reserved.
//

import UIKit
import CoreData


class CompletedTasksController: UIViewController{
    
    
    @IBOutlet var completeTasks: UITableView!
    var selectedRow: Int?
    var managedObjectContext: NSManagedObjectContext!
    
    var completedTasks: [NSManagedObject] = []
    override func viewWillAppear(_ animeated: Bool) {
        super.viewDidLoad()
        title = "Completed Tasks"
        completeTasks.delegate = self
        completeTasks.dataSource = self
        // Do any additional setup after loading the view.
        
        completedTasks.removeAll()
        let temp = getAllTasks()
        for element in temp {
            if (element.value(forKey: "complete") as? Bool == true) {
                completedTasks.append(element)
            }
        }
        completeTasks.reloadData()
    }
    
}

extension CompletedTasksController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTask(byId: self.completedTasks[indexPath.row].value(forKey: "id") as! String)
            completedTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension CompletedTasksController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "completed_tasks") ?? UITableViewCell()
        let selectedTask = completedTasks[indexPath.row]
        taskCell.textLabel?.text = selectedTask.value(forKeyPath: "task") as? String
        return taskCell
    }
    

}
