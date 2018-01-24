//
//  EventTableViewCell.swift
//  SchoolEvents
//
//  Created by acontass on 23/01/2018.
//  Copyright © 2018 acontass. All rights reserved.
//

import UIKit

/// Main cell type of the Home view.

class EventTableViewCell: UITableViewCell {
    
    /// The picture at left of the cell.
    
    @IBOutlet weak var pictureView: UIImageView!
    
    /// Date label at center of the cell.
    
    @IBOutlet weak var dateLabel: UILabel!
    
    /// Title label at top right of the cell.
    
    @IBOutlet weak var titleLabel: UILabel!
    
    /// Content label at bottom right of the cell.
    
    @IBOutlet weak var contentLabel: UILabel!
    
    /// The constraint at left of date label.
    
    @IBOutlet weak var dateLeftContraint: NSLayoutConstraint!
    
    /// The event dictionnary to set on the cell.

    public var event: NSDictionary? {
        didSet {
            if let urlStr = (event?["medias"] as? [NSDictionary])?.first?["url"] as? String, let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                pictureView.isHidden = false
                dateLeftContraint.constant = 158
                do {
                    let imgData = try Data(contentsOf: url)
                    pictureView.image = UIImage(data: imgData)
                }
                catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
            else {
                pictureView.isHidden = true
                dateLeftContraint.constant = 16
            }
            if let date = event?["dateStart"] as? String {
                dateLabel.text = date.utcToString(to: "dd/MM") ?? ""
            }
            titleLabel.text = (event?["title"] as? String ?? "")
            if let content = event?["content"] as? String {
                    contentLabel.text = content.htmlString
            }
        }
    }

}
