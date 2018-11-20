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
    
    @IBAction func dismiss(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    private func updateUI() {
//        title = item?.displayAddress
        nameLabel?.text = item?.name
        infoLabel?.text = item?.review
    }
}
