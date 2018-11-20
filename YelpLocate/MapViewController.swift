//
//  ViewController.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var item: Item? {
        didSet {
            if oldValue != nil {
                mapView.deselectAnnotation(oldValue, animated: true)
            }
            if item != nil {
                navigationItem.title = item?.displayAddress
                mapView?.selectAnnotation(item! as MKAnnotation, animated: true)
            }
        }
    }
    var center: CLLocationCoordinate2D!
    var userLocation = UserLocation()
    let annotation = MKPointAnnotation()
    lazy var annotationView: MKPinAnnotationView = {
        let view = MKPinAnnotationView(annotation: self.annotation, reuseIdentifier: "BusinessAnnotation")
        view.image = UIImage(named: "MyLocationPin")
        view.pinTintColor = UIColor.blue
        view.canShowCallout = true
        view.animatesDrop = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.mapType = .satellite
        self.mapView.delegate = self
        center = self.userLocation.location.coordinate
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
        self.mapView.layer.cornerRadius = 9.0
        self.mapView.layer.masksToBounds = true
        self.mapView.isZoomEnabled = true
        self.mapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        /*        let region = MKCoordinateRegion(center: center, span: self.mapView.region.span)
         self.mapView.setRegion(region, animated: true)*/
        annotate()
    }
    
    func annotate() {
        let items = YelpLocate.shared.businesses
        if !items.isEmpty {
            mapView.removeAnnotation(annotation)
            mapView.removeAnnotations(self.mapView.annotations)
            mapView.addAnnotation(annotation)
            mapView.addAnnotations(items)
            mapView.showAnnotations([annotation]+items, animated: true)
            if item != nil {
                mapView.selectAnnotation(item!, animated: true)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination.contentViewController
        let annotationView = sender as? MKAnnotationView
        let item = annotationView?.annotation as? Item
        if segue.identifier == "Show Image" {
            if let vc = destination as? ImageViewController {
                if item != nil, let _ = item!.imageURL {
                    vc.item = item
                    vc.navigationItem.title = item!.displayAddress
                }
            }
        } else if segue.identifier == "Show Review" {
            if item != nil, let vc = destination as? ReviewViewController {
                if let pvc = vc.popoverPresentationController {
                    pvc.sourceRect = (annotationView?.frame)!
                    pvc.delegate = self
                }
                vc.item = item
            }
        }
    }
/*    func onResults(_ results: Array<Item>, total: Int, response: NSDictionary) {
        if (response["region"] as? Dictionary<String, Dictionary<String, Double>>) != nil {
        } else {
            print("error: unable to parse region in response!")
        }
        annotations = []
        for item in results {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: item.latitude!, longitude: item.longitude!)
            annotation.coordinate=coordinate
            annotation.title = item.name
            annotation.subtitle = item.displayCategories
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func onResultsCleared() {
        self.mapView.removeAnnotations(mapView.annotations)
    }
*/
//MARK: - MKMapViewDelegate
    /*
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     if !(annotation is MKPointAnnotation) {
     return nil
     }
     
     var view = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
     if view == nil {
     view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
     view!.canShowCallout = true
     view!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
     }
     return view
     }
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     if !(annotation is MKPointAnnotation) {
     return nil
     }
     
     var view = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
     if view == nil {
     view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
     view!.canShowCallout = false
     }
     return view
     }
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is Item) {
            return nil
        }
       var view: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: "BusinessAnnotation")
        if (view == nil) {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "BusinessAnnotation")
        }
        else {
            view.annotation = annotation
        }
        view.leftCalloutAccessoryView = nil
        view.rightCalloutAccessoryView = nil
        if (annotation as! Item).thumbnailImageURL != nil {
//            (view.leftCalloutAccessoryView as! UIImageView).downloadedFrom(url: (annotation as! Item).thumbnailImageURL!)
            view.leftCalloutAccessoryView = UIButton(frame: Constants.ThumbnailFrame)
            let imageView = UIImageView(frame: Constants.ThumbnailFrame)
            imageView.downloadedFrom(url: (annotation as! Item).thumbnailImageURL!)
            view.leftCalloutAccessoryView?.addSubview(imageView)
        }
        if (annotation as! Item).review != nil {
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        if annotation === item {
            view.image = UIImage(named: "MyAnnotationPin")
        }
        view.canShowCallout = true
        return view
    }

    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if center == nil {
            center = mapView.region.center
        } else {
            let before = CLLocation(latitude: center.latitude, longitude: center.longitude)
            let nowCenter = mapView.region.center
            let now = CLLocation(latitude: nowCenter.latitude, longitude: nowCenter.longitude)
        }
    }

    func mapView(_: MKMapView, didSelect annotationView: MKAnnotationView) {
/*        if item != nil {
            (annotationView.leftCalloutAccessoryView as! UIImageView).downloadedFrom(url: (item?.thumbnailImageURL!)!)
        }
*/
    }
func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            performSegue(withIdentifier: "Show Image", sender: view)
        } else if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "Show Review", sender: view)
        }
    }

    //MARK: - UIPopoverPresentationController
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        mapView.selectAnnotation(item! as MKAnnotation, animated: true)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//OO.        return traitCollection.horizontalSizeClass == .compact ? .overFullScreen : .none
        return .none//OO.
    }
    
/*OO.    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        if style == .fullScreen || style == .overFullScreen {
            let nc = UINavigationController(rootViewController: controller.presentedViewController)
            let visualEffectsView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
            visualEffectsView.frame = nc.view.bounds
            visualEffectsView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            nc.view.insertSubview(visualEffectsView, at: 0)
            return nc
        } else {
            return nil
        }
    }
*/
}
extension UIViewController {
    var contentViewController: UIViewController {
        if let nc = self as? UINavigationController {
            return nc.visibleViewController ?? nc
        } else {
            return self
        }
    }
}
