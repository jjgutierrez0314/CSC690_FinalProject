//
//  DatabaseController.swift
//  CSC_690_Final
//
//  Created by Osbaldo Martinez on 5/8/20.
//  Copyright © 2020 Osbaldo Martinez. All rights reserved.
//
//  Contains the methods that interface with Database.swift
//

import UIKit
import CoreData

//Takes a String with the task and a Date to complete task.
//Returns the objects in the database
func saveNewTask(task: String, completeDate: Date) -> Void {
    
    let createdDate: Date = Date()
    
    let success: Bool = saveToDatabase(nTask: task, completionDate: completeDate, createdDate: createdDate)
    
    if (success) {
        addTaskToCalendar(with: createdDate, endDate: completeDate, task: task)
        
        print("Successfully saved the task.")
    } else {
        print("Failed to save the task.")
    }
    
}

//Returns all the entries in database, on fail returns empty list
func getAllTasks() -> [NSManagedObject] {
    
    let empty: [NSManagedObject] = []
    
    guard let tasks = getAllFromDatabase() else {
        return empty
    }
    
    return tasks
    
}

//Takes a String with the id of the task and returns the object
//with the given id.
func getTask(byId: String) -> NSManagedObject? {
        
    guard let task = getFromDatabaseById(taskId: byId) else {
        return nil
    }
    
    return task
}

//Accepts a String with task id and a String with the new task.
//It updates the task in the database.
func editTask(byId: String, newTask: String) -> Void {
    
    let success = editTaskById(taskId: byId, newTask: newTask)
    
    if (success) {
        print("Successfully edited the task.")
    } else {
        print("Failed to edit the task.")
    }
    
}

//Accepts a String with task id and a Date with the new date.
//It updates the date in the database.
func editDate(byId: String, newDate: Date) -> Void {
    
    let success = editTaskDateById(taskId: byId, newDate: newDate)
    
    if (success) {
        print("Successfully edited the date.")
    } else {
        print("Failed to edit the date.")
    }
    
}

//Takes a String with the task id.
//Updates the complete property to true in database.
func completeTask(byId: String) -> Void {
    
    let success = markCompleteTask(taskId: byId)
    
    if (success) {
        print("Successfully completed the task.")
    } else {
        print("Failed to complete the task.")
    }
    
}

//Deletes task.
//Accepts an String with the id of the task to be deleted.
func deleteTask(byId: String) -> Void {
    
    let success = deleteObject(taskId: byId)
    
    if (success) {
        print("Successfully deleted the task.")
    } else {
        print("Failed to delete the task.")
    }
}
