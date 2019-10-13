//
//  FeedsViewModel.swift
//  iOSAssignment
//
//  Created by Richa Walia on 10/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import Foundation

class FeedsViewModel {
   
    // MARK: Events
    var reloadTable: ()->() = { }
    
    // MARK: Output
    private var originalData: [ArticleCellViewModel] = []
    private var selectedSortOption: SortBy = .date
    var tableDataSource: [ArticleCellViewModel] = []
    var title = ""
    var numberOfRows = 0
    
    enum SortBy: Int {
        case date
        case title
        case author
    }
    
    init() {
        getFeeds(completion: {
            self.reloadTable()
        })
    }
    
    // MARK: - Public Methods
    func refreshScreen() {
        self.getFeeds(completion: { [weak self] in
            self?.reloadTable()
        })
    }
    
    func sortDataAccordingTo(option: SortBy) {
        
        switch option {
        case .date:
            tableDataSource = originalData.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
            break
        case .title:
            tableDataSource = originalData.sorted { ($0.title ?? "").lowercased() < ($1.title ?? "").lowercased() }
            break
        case .author:
            tableDataSource = originalData.sorted { ($0.authors ?? "").lowercased() < ($1.authors ?? "").lowercased() }
            break
        }
        selectedSortOption = option
        reloadTable()
    }
    
    // MARK: - Api Methods
    private func getFeeds(completion: @escaping ()->()) {
        NetworkManager.shared.getFeeds { [weak self] (title, error)  in
            self?.title = title ?? "Feeds"
            self?.originalData.removeAll()
            if let articlesData = DBManager.shared.getDataFromDB() {
                articlesData.forEach({ article in
                    let articleViewModel = ArticleCellViewModel(data: article)
                    self?.originalData.append(articleViewModel)
                })
            }
            self?.sortDataAccordingTo(option: self?.selectedSortOption ?? .date)
            self?.numberOfRows = self?.originalData.count ?? 0
            completion()
        }
    }
}
