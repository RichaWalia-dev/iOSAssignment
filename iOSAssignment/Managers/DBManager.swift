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
    
    static let shared = DBManager()
    
    func getDataFromDB() -> Results<Article>? {
        let database = try! Realm()
        let results: Results<Article> = database.objects(Article.self)
        return results
    }
        
    func addData(feed: Feed, completion: @escaping(_ isSaved: Bool)-> Void) {
        let database = try! Realm()
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
    
    func deleteDataFromDb() {
        let database = try! Realm()
        let results: Results<Article> = database.objects(Article.self)
        if results.count > 0 {
            results.forEach { article in
                do {
                    try database.write {
                        database.delete(article)
                    }
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
