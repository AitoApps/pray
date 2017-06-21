//
//  InitialViewController.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.addSearchBar()
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
}

extension UINavigationItem {
    func addSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter your current city"
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        self.titleView = searchBar
    }
}
