//
//  Client.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//
/*
"category_filter": term,
"limit": limit
*/
import UIKit

enum SortMode: String {
        case best_match, rating, review_count, distance
    }

class Client {
//    var parameters: [String : Any] = ["term": "restaurants" as Any, "limit": 10 as Any]
    var parameters: [String : Any] = ["limit": 10 as Any]
    static let sharedInstance = Client()
    
    func searchWithTerm(_ term: String, sort: SortMode?, completion: @escaping ([Item]?, Error?) -> Void) {
//        var parameters: [String : Any] = ["term": term as Any, "ll": Constants.TorontoCoordinates as Any]
        parameters["term"] = term as Any
        parameters["location"] = Constants.TorontoCoordinates
        var urlComponents = URLComponents(string: Constants.basePath + "businesses/search")!
        urlComponents.queryItems = [URLQueryItem(name: "limit", value: "10"), URLQueryItem(name: "term", value: term), URLQueryItem(name: "location", value: Constants.TorontoCoordinates)]
        if sort != nil {
            parameters["sort_by"] = sort!.rawValue
            urlComponents.queryItems!.append(URLQueryItem(name: "sort_by", value: sort!.rawValue))
        }
/*
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as Any?
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as Any?
        }
*/
//        print(parameters)
        
//!        parameters = ["term": term as Any, "ll": Constants.TorontoCoordinates as Any]
//        parameters["category_filter"] = "italian" as Any?
//          parameters["sort"] = sort!.rawValue as Any?
//          parameters["category_filter"] = "restaurants" as Any?
//          parameters["deals_filter"] = deals! as Any?
        
        guard let url = urlComponents.url, let parametersData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        print(url)
        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = parametersData
        request.addValue("Bearer \(Constants.Key)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    let value = try JSONSerialization.jsonObject(with: data!, options: [])
                    if let dictionaries = value as? [String: Any], let businesses = dictionaries["businesses"] as? [[String: Any]] {
                        completion(Item.businesses(array: businesses), nil)
                    }
                }
                catch {
                    debugPrint(error)
                }
            }
            else {
                debugPrint(error!)
            }
        }.resume()
    }
    func searchWithTerm(_ term: String, completion: @escaping ([Item]?, Error?) -> Void) {
//        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, completion: completion)
        return searchWithTerm(term, sort: nil, completion: completion)
    }
}

