//
//  Feed.swift
//  iOSAssignment
//
//  Created by Richa Walia on 10/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import Foundation

struct Feed : Codable
{
    var title : String?
    var articles : [Article]?
}

struct Article : Codable
{
    var title : String?
    var website : String?
    var authors : String?
    var date : String?
    var content : String?
    var tags : [Tag]?
    var imageUrl: String?
}

struct Tag : Codable
{
    var id : Int?
    var label : String?
}


