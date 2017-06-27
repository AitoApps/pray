//
//  CoreDataHelper.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit
import CoreData

extension UIViewController: NSFetchedResultsControllerDelegate {
    
    func dayFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let stack = coreDataStack()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        fetchRequest.sortDescriptors = []
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    //Fetch Results
    func timingFetchedResultsController(for day: Day) -> NSFetchedResultsController<NSFetchRequestResult> {
        let stack = coreDataStack()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Timing")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "day = %@", argumentArray: [day])
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func coreDataStack() -> CoreDataStack {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack
    }
    
    func getCalendarFromAPIToCoreData(placemark: CLPlacemark, completion: @escaping () -> Void) {
        AladhanAPI.getCalendarTiming(placemark: placemark) { (data: [[String : AnyObject]]?, error: NSError?) in
            
            var calendar = [Day]()
            
            for item in data! {
                guard let date = item["date"] as? [String:
                    AnyObject], let unixTime = date["timestamp"] as? String else {
                        return
                }
                
                guard let dictionary = item["timings"] as? [String: AnyObject] else {
                    return
                }
                
                let day = Day(unixTime: unixTime, insertInto: self.coreDataStack().context)
                let context = self.coreDataStack().context
                
                let imsakTime = dictionary["Imsak"] as! String
                Timing(stringTime: imsakTime, for: .Imsak, at: day, insertInto: context)
                
                let fajrTime = dictionary["Fajr"] as! String
                Timing(stringTime: fajrTime, for: .Fajr, at: day, insertInto: context)
                
                let sunriseTime = dictionary["Sunrise"] as! String
                Timing(stringTime: sunriseTime, for: .Sunrise, at: day, insertInto: context)
                
                let dhuhrTime = dictionary["Dhuhr"] as! String
                Timing(stringTime: dhuhrTime, for: .Dhuhr, at: day, insertInto: context)
                
                let asrTime = dictionary["Asr"] as! String
                Timing(stringTime: asrTime, for: .Asr, at: day, insertInto: context)
                
                let maghribTime = dictionary["Maghrib"] as! String
                Timing(stringTime: maghribTime, for: .Maghrib, at: day, insertInto: context)
                
                let ishaTime = dictionary["Isha"] as! String
                Timing(stringTime: ishaTime, for: .Isha, at: day, insertInto: context)
                
                calendar.append(day)
                
            }
            
            do {
                try self.coreDataStack().saveContext()
                DataSource.calendar.append(contentsOf: calendar)
                completion()
            } catch {
                fatalError("Failed to save to core data")
            }
        }
    }
    
    func preloadDaysFromCoreData() {
        let fetchedResultController = dayFetchedResultsController()
        do {
            try fetchedResultController.performFetch()
            let totalDays = try! fetchedResultController.managedObjectContext.count(for: fetchedResultController.fetchRequest)
            print(totalDays)
            for i in 0..<totalDays {
                let day = fetchedResultController.object(at: IndexPath(row: i, section: 0)) as! Day
                DataSource.calendar.append(day)
            }
        } catch {
            fatalError()
        }
    }
    
    func preloadTimingsFromCoreData(for day: Day) -> [Timing] {
        var timings = [Timing]()
        let fetchedResultController = timingFetchedResultsController(for: day)
        do {
            try fetchedResultController.performFetch()
            let totalTimings = try! fetchedResultController.managedObjectContext.count(for: fetchedResultController.fetchRequest)
            for i in 0..<totalTimings {
                let timing = fetchedResultController.object(at: IndexPath(row: i, section: 0)) as! Timing
                timings.append(timing)
            }
            return timings
        } catch {
            fatalError()
        }
    }
    
    func updateCompletionDate(timing: Timing, completedAt: Date) {
        timing.completionDate = completedAt as NSDate
        let readableDate = completedAt.formatTimeToReadableTime()
        timing.readableCompletionDate = readableDate
        try? coreDataStack().context.save()
    }
    
}
