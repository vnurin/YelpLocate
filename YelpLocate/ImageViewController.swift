//
//  ImageViewController.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import Foundation
import MapKit

class ImageViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var imageVIew: UIImageView!
    
    @IBOutlet weak var scrollVIew: UIScrollView!
    var item: Item!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollVIew.contentSize = imageVIew.frame.size
        imageVIew.downloadedFrom(url: item.imageURL!)
    }
}
