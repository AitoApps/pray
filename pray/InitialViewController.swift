//
//  InitialViewController.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit

class InitialViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar()
    
    var placemarks = [CLPlacemark]()
    
    var loadingView = LoadingView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.searchBar.delegate = self
        self.addSearchBar()
    }
}

// MARK: UITableViewDelegate
extension InitialViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadingView(present: true)
        let placemark = placemarks[indexPath.row]
        
        DataSource.placemark = placemark
        
        AladhanAPI.getCalendarTiming(placemark: placemark) { (data: [[String : AnyObject]]?, error: NSError?) in
            for item in data! {
                guard let date = item["date"] as? [String:
                AnyObject], let timestamp = date["timestamp"] as? String else {
                    return
                }
                
                guard let dictionary = item["timings"] as? [String: AnyObject] else {
                    return
                }
                
                let timings = Timings(dictionary: dictionary, timestamp: timestamp, insertInto: self.coreDataStack().context)
                
                DataSource.calendar.append(timings)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let main = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
            self.present(main, animated: true, completion: nil)
        }
    }
}


// MARK: UITableViewDataSource
extension InitialViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placemarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location's cell")!
        
        guard placemarks.count != 0 else {
            cell.textLabel?.text = ""
            return cell
        }
        
        let formattedAddressLines = placemarks[indexPath.row].addressDictionary!["FormattedAddressLines"] as! [String]
        
        var formattedAddressLinesString = String()
        
        for formattedAddressLine in formattedAddressLines {
            if formattedAddressLines[formattedAddressLines.endIndex - 1] == formattedAddressLine {
                formattedAddressLinesString += "\(formattedAddressLine)"
            } else {
                formattedAddressLinesString += "\(formattedAddressLine), "
            }
            
        }
        cell.textLabel?.text = formattedAddressLinesString
        return cell
    }
}

// MARK: UISearchBarDelegate
extension InitialViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        self.placemarks = []
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText != "" else {
            searchBar.endEditing(true)
            self.placemarks = []
            tableView.reloadData()
            return
        }
        
        CLGeocoder().geocodeAddressString(searchText) { (placemarks: [CLPlacemark]?, error: Error?) in
            
            guard error == nil else {
                print("No placemarks found: ", error!)
                return
            }
            
            self.placemarks = placemarks!
            self.tableView.reloadData()
        }
    }
}

// MARK: View Setups
extension InitialViewController {
    func addSearchBar() {
        searchBar.placeholder = "Enter your current city name"
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
    }
    
    func loadingViewFromNib() -> LoadingView {
        let nib = UINib(nibName: "LoadingView", bundle: nil)
        let instance = nib.instantiate(withOwner: nil, options: nil)[0] as! LoadingView
        let loadingViewWidth = 148.0 as CGFloat
        let loadingViewHeight = 96.0 as CGFloat
        let x = (self.view.frame.width - loadingViewWidth) / 2
        let y = (self.view.frame.height - loadingViewHeight) / 2
        instance.frame = CGRect(x: x, y: y, width: loadingViewWidth, height: loadingViewHeight)
        return instance
    }
    
    func loadingView(present: Bool) {
        if present {
            self.searchBar.isUserInteractionEnabled = false
            self.view.isUserInteractionEnabled = false
            self.loadingView = loadingViewFromNib()
            self.view.addSubview(loadingView)
        } else {
            self.searchBar.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = true
            loadingView.removeFromSuperview()
        }
        
        
    }
}
