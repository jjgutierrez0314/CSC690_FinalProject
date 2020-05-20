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
    
    override func viewDidLoad() {
           super.viewDidLoad()
           title = "Completed Tasks List"
           completeTasks.delegate = self
           completeTasks.dataSource = self
           // Do any additional setup after loading the view.
           
           completeTasks.register(UITableViewCell.self, forCellReuseIdentifier: "completed_tasks")
           completeTasks.dataSource = self
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
            let temp = getAllTasks()
            for element in temp {
                if (element.value(forKey: "complete") as! Bool == true) {
                    completedTasks.append(element)
                }
            }
        }
    
}

extension CompletedTasksController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let t = self.completedTasks[indexPath.row].value(forKey: "task") as? String else {
                print("return error task")
                return
            }
            guard let d = self.completedTasks[indexPath.row].value(forKey: "completeBy") as? Date else {
                print("return error date")
                return
            }
            deleteEventFromCalendar(title: t, endDate: d)
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
        taskCell.accessoryType = .checkmark
        taskCell.textLabel?.text = selectedTask.value(forKeyPath: "task") as? String
        return taskCell
    }
    

}
