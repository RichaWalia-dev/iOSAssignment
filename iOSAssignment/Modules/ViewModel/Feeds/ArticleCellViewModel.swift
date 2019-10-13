//
//  ArticleCellViewModel.swift
//  iOSAssignment
//
//  Created by Richa Walia on 10/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import Foundation
import UIKit

class ArticleCellViewModel {
    
    // MARK:- Output
    var title: String?
    var website: String?
    var authors: String?
    var content: String?
    var imageUrl: String?
    var date = Date()
    var state = PhotoState.new
    var thumbnail = Images.placeholder
    
    private var dataSource: Article
    
    init(data: Article) {
        dataSource = data
        configureOutput()
    }
    
    private func configureOutput() {
        title = dataSource.title ?? ""
        website = dataSource.website ?? ""
        authors = dataSource.authors ?? ""
        content = dataSource.content ?? ""
        imageUrl = dataSource.imageUrl ?? ""
        date = dataSource.date?.toDate() ?? Date()
    }
}
