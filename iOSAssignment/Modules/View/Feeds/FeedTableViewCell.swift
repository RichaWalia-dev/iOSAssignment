//
//  FeedTableViewCell.swift
//  iOSAssignment
//
//  Created by Richa Walia on 10/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    // MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    // MARK:- View Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK:- Public Methods
    func populateCell(articleViewModel: ArticleCellViewModel) {
        titleLabel.text = articleViewModel.title ?? Constants.titleNotAvailable
        descriptionLabel.text = articleViewModel.content ?? Constants.contentNotAvailable
        feedImageView.image = articleViewModel.thumbnail
    }
}
