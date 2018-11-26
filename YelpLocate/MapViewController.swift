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
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.layer.cornerRadius = 9.0
            mapView.layer.masksToBounds = true
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .followWithHeading
            annotate()
        }
    }
    var item: Item? {
        didSet {
            if oldValue != nil {
                mapView.deselectAnnotation(oldValue, animated: true)
            }
            if item != nil {
                navigationItem.title = item!.displayAddress
                annotate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: Constants.UserLocationUpdatedNotification, object: nil, queue: nil) { _ in
            self.mapView.setCenter(UserLocationManager.instance.location.coordinate, animated: true)
        }
    }
    
    private func annotate() {
        mapView?.removeAnnotations(self.mapView.annotations)
        //!        let center = CLLocationCoordinate2D(latitude: UserLocationManager.instance.latitude, longitude: UserLocationManager.instance.latitude)
        let center = CLLocationCoordinate2D(latitude: UserLocationManager.instance.latitude, longitude: UserLocationManager.instance.longitude)
        self.mapView?.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        /*        let region = MKCoordinateRegion(center: center, span: self.mapView.region.span)
         self.mapView.setRegion(region, animated: true)*/
//        annotation.coordinate = center
        let items = YelpLocate.shared.businesses
        if !items.isEmpty {
            mapView?.addAnnotations(items)
            mapView?.showAnnotations(items, animated: true)
            if item != nil {
                mapView?.selectAnnotation(item!, animated: true)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        let annotationView = sender as? MKAnnotationView
        let item = annotationView?.annotation as? Item
        if segue.identifier == "Show Image" {
            if let vc = destination as? ImageViewController {
                if item != nil, let _ = item!.imageURL {
                    vc.item = item
                    vc.navigationItem.title = item!.shortAddress
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
        if (annotation as! Item).imageURL != nil {
            view.leftCalloutAccessoryView = UIButton(frame: Constants.ThumbnailFrame)
            let imageView = UIImageView(frame: Constants.ThumbnailFrame)
            imageView.contentMode = .scaleAspectFill
            imageView.downloadedFrom(url: (annotation as! Item).imageURL!)
            view.leftCalloutAccessoryView?.addSubview(imageView)
        }
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        if annotation === item {
            view.image = UIImage(named: "MyLocationPin")
        }
        view.canShowCallout = true
        return view
    }

    func mapView(_: MKMapView, didSelect annotationView: MKAnnotationView) {
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
