//
//  AladhanClient.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/24/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation

class AladhanClient: NSObject {
    
    static var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    @discardableResult static func taskForGETMethod(parameters: [String: AnyObject], method: String, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
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
    
    static func aladhanURLFromParameters(parameters: [String: AnyObject], method: String ) -> URL {
        var components = URLComponents()
        components.scheme = AladhanClient.Constants.ApiScheme
        components.host = AladhanClient.Constants.ApiHost
        components.path = "/" + method
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }

        print(components.debugDescription)
        
        print(components.url ?? "no components url")
        
        return components.url!
    }
    
    static func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
}
