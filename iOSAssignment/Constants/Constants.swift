//
//  Constants.swift
//  iOSAssignment
//
//  Created by Richa Walia on 10/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let url = "https://no89n3nc7b.execute-api.ap-southeast-1.amazonaws.com/staging/exercise"
}

struct CellIdentifiers {
    static let feed = "FeedCell"
}

struct SegueIdentifiers {
    static let detail = "DetailView"
}

struct Images {
    static let placeholder = UIImage(named: "placeholder")!
}

enum PhotoState {
    case new, downloaded, failed
}
