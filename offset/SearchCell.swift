//
//  SearchCell.swift
//  offset
//
//  Created by Logan Caracci on 3/20/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    
    @IBOutlet weak var coverArtThumbnailView: UIImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverArtThumbnailView.layer.cornerRadius = coverArtThumbnailView.frame.width / 2
        coverArtThumbnailView.layer.masksToBounds = true
    }
   
}
