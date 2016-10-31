//
//  ListTableViewCell.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//
import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    var item: Item!
    
    func initialize() {
        if nameLabel.text! == "Name" {
            thumbnailImageView.layer.cornerRadius = 7.0
            thumbnailImageView.layer.masksToBounds = true
            thumbnailImageView.layer.borderWidth = 1.0
        }
        nameLabel.text = item.name
        addressLabel.text = item.shortAddress
        distLabel.text = String(format: "%.1f mi", item.distance / 1609.344)
        thumbnailImageView.downloadedFrom(url: item.thumbnailImageURL!)
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }.resume()
    }
}
