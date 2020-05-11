//
//  CalendarController.swift
//  CSC_690_Final
//
//  Created by Osbaldo Martinez on 5/11/20.
//  Copyright © 2020 Osbaldo Martinez. All rights reserved.
//

import UIKit
import EventKit

func daysToCompleteTask(start: Date, finish: Date) -> Int {
    let currentCalendar: Calendar = Calendar.current
    
    guard let remainingDays: Int = currentCalendar.dateComponents([.day], from: start, to: finish).day else {
        print("Could not calculate remaining days")
        return 0
    }
    
    print("There are \(remainingDays) days remaining.")
    return remainingDays
}

func addTaskToCalendar(with startDate: Date, endDate: Date, task: String) {
    
    let taskStore: EKEventStore = EKEventStore()
    
    taskStore.requestAccess(to: .event) { (isGranted, err) in
        
        guard  let error = err else {
            if(isGranted) {
                
                let taskToSave:EKEvent = EKEvent(eventStore: taskStore)
                
                taskToSave.title = "Task To Complete"
                taskToSave.startDate = startDate
                taskToSave.endDate = endDate
                taskToSave.notes = task
                taskToSave.calendar = taskStore.defaultCalendarForNewEvents
                
                do {
                    try taskStore.save(taskToSave, span: .thisEvent)
                } catch let nsErr as NSError {
                    print("Failed to save task to calendar: \(nsErr)")
                }
            }
            
            return
        }
        
        print("Could not save task to calendar: \(error)");
        
    }
}
