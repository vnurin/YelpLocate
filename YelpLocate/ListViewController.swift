//
//  ListViewController.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//
import UIKit
import MapKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var runner: UIActivityIndicatorView!
    let runner = UIActivityIndicatorView()
    @IBOutlet weak var sortButton: UIButton!
    var userLocation: UserLocation!
    @IBAction func sort(_ sender: UIButton) {
        if YelpLocate.shared.businesses.isEmpty {
            return
        }
        YelpLocate.shared.itemsAreFromServer = false;
        if sender.tag == 0 {
            sender.setTitle(Constants.ButtonTitles[1], for: .normal)
            sender.tag = 1
            YelpLocate.shared.businesses.sort{ $0.name < $1.name }
        } else {
            sender.setTitle(Constants.ButtonTitles[0], for: .normal)
            sender.tag = 0
            YelpLocate.shared.businesses.sort{ $0.distance < $1.distance }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    override func viewDidLoad() {
        splitViewController!.delegate = self
        super.viewDidLoad()
        userLocation = UserLocation()
        userLocation.requestLocation()
        performSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Constants.ItemsDidChangeNotification), object: nil, queue: nil, using: {[unowned self] _ in
                self.tableView.reloadData()
                if YelpLocate.shared.itemsAreFromServer && self.sortButton.tag == 1 {
                    self.sortButton.setTitle(Constants.ButtonTitles[0], for: .normal)
                    self.sortButton.tag = 0
                }

            })
//        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.performSearch), name: NSNotification.Name(rawValue: Constants.UserLocationUpdatedNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.UserLocationUpdatedNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: Constants.ItemsDidChangeNotification), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Map":
//                print(segue.destination.childViewControllers[0])
                if let mapViewController = segue.destination.children[0] as? MapViewController {
                    let item = (sender as! ListTableViewCell).item
//                    mapViewController.items = YelpLocate.shared.businesses
                    mapViewController.item = item
                    mapViewController.navigationItem.title = item?.name
                }
            default: break
            }
        }
    }
    
    func performSearch() {
        runner.startAnimating()
        var term1 = "restaurants"
        if textField.text != nil  && textField.text != "" {
            term1 += ","+textField.text!.replacingOccurrences(of: " ", with: ",", options: .literal, range: nil)
        }
        Client.shared.searchWithTerm(term1, sort: .distance, success: {
            items in
            YelpLocate.shared.itemsAreFromServer = true
            YelpLocate.shared.getBusinesses(from: items)
            DispatchQueue.main.async(execute: {
                self.runner.stopAnimating()
                self.runner.removeFromSuperview()
            })

        })

    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YelpLocate.shared.businesses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as! ListTableViewCell
        cell.item = YelpLocate.shared.businesses[(indexPath as NSIndexPath).row]
        cell.initialize()
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "Show Map", sender: tableView.cellForRow(at: indexPath))
        
        if let mapViewController = splitViewController?.viewControllers.last as? MapViewController {
            mapViewController.item=YelpLocate.shared.businesses[indexPath.row];
        }
        else {
            performSegue(withIdentifier: "Show Map", sender: tableView.cellForRow(at: indexPath))
        }
        
//        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSearch()
        return true
    }
}

//MARK: - UISplitViewControllerDelegate

extension ListViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
