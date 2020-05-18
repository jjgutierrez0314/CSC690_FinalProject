//
//  AddTaskController.swift
//  CSC_690_Final
//
//  Created by John Joshua Gutierrez on 5/13/20.
//  Copyright © 2020 Osbaldo Martinez. All rights reserved.
//

import UIKit
import CoreData

class AddTaskController: UIViewController{


    @IBOutlet weak var newTask: UITextField!
    @IBOutlet weak var completeBy: UIDatePicker!
    
    @IBAction func submitNewTask(_ sender: UIBarButtonItem) {
        guard let task = newTask.text else {
            return
        }
        if(task == "") {
            let alert = UIAlertController(title: "", message: "Please enter a task!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }
        completeBy.datePickerMode = UIDatePicker.Mode.date

        saveNewTask(task: task, completeDate: completeBy.date)
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    
    //ToDo
    //take in input from newTask and completeDate
    //store it into Core Data
}


