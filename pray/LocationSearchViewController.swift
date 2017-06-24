//
//  LocationSearchViewController.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/24/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar()
    
    var placemarks = [CLPlacemark]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.searchBar.delegate = self
        self.addSearchBar()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: UITableViewDelegate
extension LocationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let placemark = placemarks[indexPath.row]
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: placemark)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: "placemark")
        
        DataSource.currentPlacemark = placemark
        
        getCalendarFromAPIToCoreData(placemark: placemark) {
            self.presentMain()
        }
    }
}


// MARK: UITableViewDataSource
extension LocationSearchViewController: UITableViewDataSource {
    
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
extension LocationSearchViewController: UISearchBarDelegate {
    
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
extension LocationSearchViewController {
    func addSearchBar() {
        searchBar.placeholder = "Enter your current city name"
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
    }
    
    func presentMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        self.present(main, animated: true, completion: nil)
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

}

