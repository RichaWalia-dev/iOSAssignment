//
//  DetailViewModel.swift
//  iOSAssignment
//
//  Created by Richa Walia on 11/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import Foundation
import UIKit

class DetailViewModel {
    
    // MARK:- Output
    var title = ""
    var content = ""
    var imageUrl = ""
    var state = PhotoState.new
    var thumbnail = Images.placeholder
    
    // MARK:- Events
    var updateImage: ()->() = { }
    
    init(data: ArticleCellViewModel) {
        title = data.title ?? ""
        content = data.content ?? ""
        imageUrl = data.imageUrl ?? ""
        state = data.state
        thumbnail = data.thumbnail
        if state == .new, let url = URL(string: imageUrl) {
            NetworkManager.shared.downloadImage(url: url) { [weak self] (image, error) in
                if image != nil {
                    self?.thumbnail = image!
                    self?.updateImage()
                }
            }
        }
    }
}
