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

    @IBAction func addTask(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

