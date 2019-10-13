//
//  DBManager.swift
//  iOSAssignment
//
//  Created by Richa Walia on 14/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    
    private var database: Realm
    static let shared = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    func getDataFromDB() -> Results<Article>? {
        let results: Results<Article> = database.objects(Article.self)
        return results
    }
        
    func addData(feed: Feed, completion: @escaping(_ isSaved: Bool)-> Void) {
        do {
            for article in feed.articles {
                try database.write {
                    database.add(article)
                }
            }
            completion(true)
        } catch {
            print("Error: \(error.localizedDescription)")
            completion(false)
        }
    }
}
