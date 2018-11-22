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
    var item: Item? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        preferredContentSize = CGSize(width: 300, height: 80)
    }
    private func updateUI() {
//        title = item?.displayAddress
        nameLabel?.text = item?.name
        infoLabel?.text = item?.displayAddress
    }
}
