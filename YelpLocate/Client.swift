//
//  Client.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//
import UIKit

enum SortMode: String {
        case best_match, rating, review_count, distance
    }

class Client {
    static let shared = Client()
    
    func searchWithTerm(_ term: String, sort: SortMode? = nil, failure: @escaping () -> (), success: @escaping ([[String: Any]]) -> ()) {
        var urlComponents = URLComponents(string: Constants.basePath + "businesses/search")!
        urlComponents.queryItems = [URLQueryItem(name: "limit", value: "10"), URLQueryItem(name: "term", value: term), URLQueryItem(name: "location", value: String(UserLocationManager.instance.latitude) + "," + String(UserLocationManager.instance.longitude))]
        if sort != nil {
            urlComponents.queryItems!.append(URLQueryItem(name: "sort_by", value: sort!.rawValue))
        }
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(Constants.Key)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    let value = try JSONSerialization.jsonObject(with: data!, options: [])
                    if let dictionaries = value as? [String: Any], let businesses = dictionaries["businesses"] as? [[String: Any]] {
                        success(businesses)
                    }
                    else {
                        failure()
                    }
                }
                catch {
                    debugPrint(error)
                    failure()
                }
            }
            else {
                debugPrint(error!)
                failure()
            }
        }.resume()
    }
    private init(){}
}

