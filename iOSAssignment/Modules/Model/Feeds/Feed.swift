//
//  Feed.swift
//  iOSAssignment
//
//  Created by Richa Walia on 10/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class Feed: Object, Codable
{
    dynamic var title: String = ""
    dynamic var articles = RealmSwift.List<Article>()
}

@objcMembers class Article: Object, Codable
{
    dynamic var title: String = ""
    dynamic var website: String = ""
    dynamic var authors: String = ""
    dynamic var date: String = ""
    dynamic var content: String = ""
    dynamic var tags = RealmSwift.List<Tag>()
    dynamic var imageUrl: String = ""
}

@objcMembers class Tag: Object, Codable
{
    dynamic var id: Int = 0
    dynamic var label: String = ""
}



