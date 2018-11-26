//
//  ReviewViewController.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-29.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 300, height: 80)
        nameLabel.text = item?.name
        infoLabel.text = item?.displayAddress
    }
}
