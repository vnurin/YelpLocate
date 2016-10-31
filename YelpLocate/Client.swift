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

enum SortMode: Int {
        case bestMatched=0, distance, highestRated
    }

class Client: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
//    var parameters: [String : AnyObject] = ["term": "restaurants" as AnyObject, "limit": 10 as AnyObject]
    var parameters: [String : AnyObject] = ["limit": 10 as AnyObject]
    static let sharedInstance = Client(consumerKey: Constants.YelpConsumerKey, consumerSecret: Constants.YelpConsumerSecret, accessToken: Constants.YelpToken, accessSecret: Constants.YelpTokenSecret)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
//    func searchWithTerm(_ term: String, sort: SortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Item]?, Error?) -> Void) -> AFHTTPRequestOperation {
    func searchWithTerm(_ term: String, sort: SortMode?, completion: @escaping ([Item]?, Error?) -> Void) -> AFHTTPRequestOperation {
//        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": Constants.TorontoCoordinates as AnyObject]
        parameters["term"] = term as AnyObject
        if sort != nil {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }
/*
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject?
        }
*/
//        print(parameters)
        
//!        parameters = ["term": term as AnyObject, "ll": Constants.TorontoCoordinates as AnyObject]
//        parameters["category_filter"] = "italian" as AnyObject?
//          parameters["sort"] = sort!.rawValue as AnyObject?
//          parameters["category_filter"] = "restaurants" as AnyObject?
//          parameters["deals_filter"] = deals! as AnyObject?

        return self.get("search", parameters: parameters, success: {
            (operation: AFHTTPRequestOperation?, response: Any?) -> Void in if let response = response as? [String: Any] {
                let dictionaries = response["businesses"] as? [NSDictionary]
                if dictionaries != nil {
                    completion(Item.businesses(array: dictionaries!), nil)
                }
            }
        },
        failure: { (operation: AFHTTPRequestOperation?, error: Error?) -> Void in
//            completion(nil, error)
            print(error.debugDescription)
        })!
    }
    func searchWithTerm(_ term: String, completion: @escaping ([Item]?, Error?) -> Void) -> AFHTTPRequestOperation {
//        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, completion: completion)
        return searchWithTerm(term, sort: nil, completion: completion)
    }
}

