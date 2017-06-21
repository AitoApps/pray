//
//  AladhanAPI.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/24/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import MapKit

class AladhanAPI: NSObject {
    
    static var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    class func getCalendarTiming(placemark: CLPlacemark, completion: @escaping (_ results: NSDictionary?, _ error: NSError?) -> Void) {
        let latitude = placemark.location!.coordinate.latitude
        let longitude = placemark.location!.coordinate.longitude
        let timezone = placemark.timeZone!.identifier
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        let currentDate = Date()
        let month = monthFormatter.string(from: currentDate)
        let year = yearFormatter.string(from: currentDate)
        
        let parameters: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
            "timezonestring": timezone,
            "method": 4,
            "month": month,
            "year": year]

        AladhanAPI.taskForGETMethod(parameters: parameters, method: "calendar") { (results: NSDictionary?, error: NSError?) in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            completion(results!, nil)
        }
    }
    
    @discardableResult static func taskForGETMethod(parameters: [String: Any], method: String, completion: @escaping (_ results: NSDictionary?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let url = self.aladhanURLFromParameters(parameters: parameters, method: method)
        
        let request = URLRequest(url: url)
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }

            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completion)

        }
        
        task.resume()
        
        return task
        
    }
    
    static func aladhanURLFromParameters(parameters: [String: Any], method: String ) -> URL {
        var components = URLComponents()
        components.scheme = AladhanAPI.Constants.ApiScheme
        components.host = AladhanAPI.Constants.ApiHost
        components.path = "/" + method
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    static func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ results: NSDictionary?, _ error: NSError?) -> Void) {
        
        var parsedResult: NSDictionary! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
}
