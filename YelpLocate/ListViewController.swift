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
    @IBOutlet weak var runner: UIActivityIndicatorView!
    @IBOutlet weak var sortButton: UIButton!
    @IBAction func sort(_ sender: UIButton) {
        YelpLocate.shared.itemsAreFromServer = false
        YelpLocate.shared.sortItems()
        sender.setTitle(YelpLocate.shared.sortedState.caption, for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController!.delegate = self
        NotificationCenter.default.addObserver(forName: Constants.ItemsDidChangeNotification, object: nil, queue: nil) {_ in
            DispatchQueue.main.async {
                if YelpLocate.shared.itemsAreFromServer && YelpLocate.shared.sortedState != .byDistance {
                    YelpLocate.shared.sortItems()
                }
                self.tableView.reloadData()
            }
        }
        performSearch()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Constants.ItemsDidChangeNotification, object: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Map":
                if let mapViewController = segue.destination.children[0] as? MapViewController {
                    let item = (sender as! ListTableViewCell).item
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
        YelpLocate.shared.itemsAreFromServer = true
        Client.shared.search(with: term1, failure: { DispatchQueue.main.async { self.runner.stopAnimating() }}) { items in
            YelpLocate.shared.getBusinesses(from: items)
            DispatchQueue.main.async{
                self.runner.stopAnimating()
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YelpLocate.shared.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as! ListTableViewCell
        cell.item = YelpLocate.shared.businesses[indexPath.row]
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
