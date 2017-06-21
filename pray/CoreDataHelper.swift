//
//  CoreDataHelper.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController: NSFetchedResultsControllerDelegate {
    
    func fetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let stack = coreDataStack()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Timing")
        fetchRequest.sortDescriptors = []
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func coreDataStack() -> CoreDataStack {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack
    }
    
    func addToCoreData(of dictionary: NSDictionary) -> Timing? {
        do {
            let timing = Timing(dictionary: dictionary, context: coreDataStack().context)
            try coreDataStack().saveContext()
            return timing
        } catch {
            print("Add Core Data Failed")
            return nil
        }
    }
    
}
