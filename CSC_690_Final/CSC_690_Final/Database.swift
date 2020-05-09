//
//  Database.swift
//  CSC_690_Final
//
//  Created by Osbaldo Martinez on 5/8/20.
//  Copyright © 2020 Osbaldo Martinez. All rights reserved.
//

import UIKit
import CoreData

//Saves a new task into database
//accepts a String with the task and the Date to complete the task by.
func saveToDatabase(nTask: String, nDate: Date) -> Void {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContex = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: managedContex)!
    let task = NSManagedObject(entity: entity, insertInto: managedContex)
    
    task.setValue(nTask, forKey: "task")
    task.setValue(false, forKey: "complete")
    task.setValue(UUID.init().uuidString, forKey: "id")
    task.setValue(nDate, forKey: "completeBy")
    
    do {
        try managedContex.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
    
}

//Function returns an array of NSManagedObjects with
//the data from the database.
func getAllFromDatabase() -> [NSManagedObject]? {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return nil
    }
    
    let managedContex = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
    
    do {
        
        let objectsToReturn = try managedContex.fetch(fetchRequest)
        return objectsToReturn
        
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return nil
    }
    
}

//Gets an object from the database
//Accepts a String with the task id.
//Returns an NSManagedObject with the information of the task.
func getFromDatabaseById(taskId:String) -> NSManagedObject? {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return nil
    }
    
    let managedContex = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
    fetchRequest.predicate = NSPredicate(format: "id = %@", taskId)
    
    do {
        
        let objs = try managedContex.fetch(fetchRequest)
        let objectToReturn = objs[0]
        return objectToReturn
        
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return nil
    }
    
}

//Function that edits the task in the database.
//Accepts a String with task id and a String with the new task.
//It updates the task in the database.
func editTaskById(taskId: String, newTask: String) -> Void {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContex = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
    fetchRequest.predicate = NSPredicate(format: "id = %@", taskId)
    
    do {
        let objs = try managedContex.fetch(fetchRequest)
        let objectToEdit = objs[0]
        objectToEdit.setValue(newTask, forKey: "task")
           
        do {
            try managedContex.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
}

//Function that edits the date of task in the database.
//Accepts a String with task id and a Date with the new date.
//It updates the task in the database.
func editTaskDateById(taskId: String, newDate: Date) -> Void {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContex = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
    fetchRequest.predicate = NSPredicate(format: "id = %@", taskId)
    
    do {
        
        let objs = try managedContex.fetch(fetchRequest)
        let objectToEdit = objs[0]
        objectToEdit.setValue(newDate, forKey: "date")
           
        do {
            try managedContex.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
}

//Marks the object as complete in database
//Takes a String with the task id.
//Updates the complete property to true in database.
func markCompleteTask(taskId: String) -> Void {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContex = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
    fetchRequest.predicate = NSPredicate(format: "id = %@", taskId)
    
    do {
        
        let objs = try managedContex.fetch(fetchRequest)
        let objectToEdit = objs[0]
        objectToEdit.setValue(true, forKey: "complete")
           
        do {
            try managedContex.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
}

//Deletes object from database.
//Accepts an String with the id of the task to be deleted.
func deleteObject(taskId: String) -> Void {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContex = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
    fetchRequest.predicate = NSPredicate(format: "id = %@", taskId)
    
    do {
        
        let objs = try managedContex.fetch(fetchRequest)
        let objectToDelete = objs[0]
        managedContex.delete(objectToDelete)
        
        do {
            try managedContex.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
}
