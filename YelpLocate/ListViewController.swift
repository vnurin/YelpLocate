//
//  ListViewController.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import CoreLocation
import UIKit
import MapKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var runner: UIActivityIndicatorView!
    @IBOutlet weak var sortButton: UIButton!
//    let data = Load()
    let data = Load.instance
    let client = Client.sharedInstance
    var userLocation: UserLocation!
    @IBAction func sort(_ sender: UIButton) {
        if data.items.isEmpty {
            return
        }
        data.itemsAreFromServer = false;
        if sender.tag == 0 {
            sender.setTitle(Constants.ButtonTitles[1], for: .normal)
           sender.tag = 1
            data.items = data.items.sorted{ $0.name < $1.name }
        } else {
            sender.setTitle(Constants.ButtonTitles[0], for: .normal)
            sender.tag = 0
            data.items = data.items.sorted{ $0.distance < $1.distance }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userLocation = UserLocation()
        userLocation.requestLocation()
        textField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        performSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Constants.ItemsCameNotification), object: nil, queue: nil, using: {[unowned self] _ in
                self.tableView.reloadData()
            })
//        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.performSearch), name: NSNotification.Name(rawValue: Constants.UserLocationUpdatedNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.UserLocationUpdatedNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: Constants.ItemsCameNotification), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Map":
                print(segue.destination.childViewControllers[0])
                if segue.destination.childViewControllers[0] is MapViewController {
                    if sender != nil {
                        let item = (sender as! ListTableViewCell).item
                        (segue.destination.childViewControllers[0]  as! MapViewController).item = item
                        segue.destination.childViewControllers[0].navigationItem.title = item?.displayAddress

                    }
                }
            default: break
            }
        }
    }
    
    func performSearch() {
        runner.startAnimating()
        if sortButton.tag == 1 {
            sortButton.setTitle(Constants.ButtonTitles[0], for: .normal)
            sortButton.tag = 0
        }
        var term1 = "restaurants"
        if textField.text != nil  && textField.text != "" {
            term1 += ","+textField.text!.replacingOccurrences(of: " ", with: ",", options: .literal, range: nil)
        }
/*
        client.searchWithTerm(term1, parameters: getSearchParameters(), limit: limit, success: {[unowned self]
            (operation: URLSessionDataTask?, response: Any?) -> Void in
            self.data.items = ((response as! [String: Any])["items"] as! Array).map({
                (item: NSDictionary) -> Item in
                return Item(dictionary: item)
            })
            self.data.itemsAreFromServer = true
            self.total = (response as! [String: Any])["total"] as! Int
            self.lastResponse = response as! NSDictionary
            self.runner.stopAnimating()
            }, failure: {
                (operation: URLSessionDataTask?, error: Error?) -> Void in
                print(error!.localizedDescription)
                self.runner.stopAnimating()
        })*/
/*
        var categories: String
        if textField.text != nil && textField.text != "" {
            categories = textField.text!.replacingOccurrences(of: " ", with: ",", options: .literal, range: nil)
            client.parameters["category_filter"] = categories as AnyObject
        }
        else {
            client.parameters["category_filter"] = nil//if parameters has categories from the last session, it will be removed
        }
*/
/*        var categories: [String]? = nil
        if textField.text != nil && textField.text != "" {
            categories = textField.text!.components(separatedBy: " ")
            client.parameters["categories"] = categories as AnyObject
        }
        else {
            client.parameters["categories"] = nil
        }*/

        client.parameters["ll"] = String(userLocation.latitude)+","+String(userLocation.longitude) as AnyObject
        print(client.parameters["ll"])
/*        client.parameters = ["ll": Constants.TorontoCoordinates as AnyObject]
        client.parameters["category_filter"] = "italian" as AnyObject?*/
        //        client.searchWithTerm(sort: SortMode.distance, completion: {[unowned self]
          client.searchWithTerm(term1, sort: .distance, completion: {[unowned self]
//        client.searchWithTerm("restaurant", completion: {[unowned self]
            (items, error) -> Void in
            if error == nil {
                self.data.itemsAreFromServer = true
                self.data.items = items!
                self.runner.stopAnimating()
            }
            else {
                print(error!.localizedDescription)
            }
        })

    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as! ListTableViewCell
        cell.item = self.data.items[(indexPath as NSIndexPath).row]
        cell.initialize()
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Map", sender: tableView.cellForRow(at: indexPath))
//        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSearch()
        return true
    }
}
