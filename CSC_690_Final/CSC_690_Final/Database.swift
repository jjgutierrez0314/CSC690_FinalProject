//
//  Database.swift
//  CSC_690_Final
//
//  Created by Osbaldo Martinez on 5/8/20.
//  Copyright © 2020 Osbaldo Martinez. All rights reserved.
//
//  Contains the methods necessary to interface with coredata database.
//

import UIKit
import CoreData

//Saves a new task into database
//Accepts a String with the task, the Date to complete the task by,
//and the date it was created.
//Returns true on success, otherwise false
func saveToDatabase(nTask: String, completionDate: Date, createdDate: Date) -> Bool {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return false
    }
    
    let managedContex = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: managedContex)!
    let task = NSManagedObject(entity: entity, insertInto: managedContex)
    
    task.setValue(nTask, forKey: "task")
    task.setValue(false, forKey: "complete")
    task.setValue(UUID.init().uuidString, forKey: "id")
    task.setValue(completionDate, forKey: "completeBy")
    task.setValue(createdDate, forKey: "createdOn")
    
    do {
        
        try managedContex.save()
        return true
        
    } catch let error as NSError {
        
        print("Could not save. \(error), \(error.userInfo)")
        return false
        
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
//Returns true on success, otherwise false
func editTaskById(taskId: String, newTask: String) -> Bool {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return false
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
            return true
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
    } catch let error as NSError {
        
        print("Could not fetch. \(error), \(error.userInfo)")
        return false
        
    }
    
}

//Function that edits the date of task in the database.
//Accepts a String with task id and a Date with the new date.
//It updates the date in the database.
//Returns true on success, otherwise false
func editTaskDateById(taskId: String, newDate: Date) -> Bool {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return false
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
            return true
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
    } catch let error as NSError {
        
        print("Could not fetch. \(error), \(error.userInfo)")
        return false
        
    }
    
}

//Marks the object as complete in database
//Takes a String with the task id.
//Updates the complete property to true in database.
//Returns true on success, otherwise false
func markCompleteTask(taskId: String) -> Bool {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return false
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
            return true
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
            return false
            
        }
        
    } catch let error as NSError {
        
        print("Could not fetch. \(error), \(error.userInfo)")
        return false
        
    }
    
}

//Deletes object from database.
//Accepts an String with the id of the task to be deleted.
//Returns true on success, otherwise false
func deleteObject(taskId: String) -> Bool {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return false
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
            return true
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
            return false
            
        }
        
    } catch let error as NSError {
        
        print("Could not fetch. \(error), \(error.userInfo)")
        return false
        
    }
    
}
