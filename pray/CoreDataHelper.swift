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
    
    func preloadTimingFromCoreData() {
        try? fetchedResultsController().performFetch()
        let fetchRequest = fetchedResultsController().fetchRequest
        let managedObjectContext = fetchedResultsController().managedObjectContext
        let totalTimings = try! managedObjectContext.count(for: fetchRequest)
        for i in 0..<totalTimings {
            let timing = fetchedResultsController().object(at: IndexPath(row: i, section: 0)) as! Timing
            DataSource.timings.append(timing)
        }
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
