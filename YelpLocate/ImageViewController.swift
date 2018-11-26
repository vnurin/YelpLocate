//
//  ImageViewController.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import Foundation
import MapKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var item: Item!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.downloadedFrom(url: item.imageURL!)
    }
}
