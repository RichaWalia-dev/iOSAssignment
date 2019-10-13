//
//  FeedsViewController.swift
//  iOSAssignment
//
//  Created by Richa Walia on 10/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import UIKit

class FeedsViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var feedsTableView: UITableView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(FeedsViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    private var viewModel = FeedsViewModel()
    private lazy var downloadsInProgress = [OperationModel]()
    private lazy var downloadQueue:OperationQueue = OperationQueue()
    
    // MARK:- View Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        observeEvents()
    }
    
    // MARK:- Private Methods
    private func setUpUI() {
        self.title = "Feeds"
        feedsTableView.tableFooterView = UIView()
        feedsTableView.estimatedRowHeight = 200
        feedsTableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 10.0, *) {
            feedsTableView.refreshControl = refreshControl
        } else {
            feedsTableView.addSubview(refreshControl)
        }
        
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortFeedsData))
        self.navigationItem.rightBarButtonItem  = sortButton
    }
    
    private func observeEvents() {
        viewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.title = self?.viewModel.title
                self?.feedsTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Sort Action Methods
    @objc func sortFeedsData() {
        let actionSheet = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let dateOptionAction = UIAlertAction(title: "Date", style: .default) { action in
            actionSheet.dismiss(animated: true)
            self.viewModel.sortDataAccordingTo(option: .date)
        }
        let titleOptionAction = UIAlertAction(title: "Title", style: .default) { action in
            actionSheet.dismiss(animated: true)
            self.viewModel.sortDataAccordingTo(option: .title)
        }
        let authorOptionAction = UIAlertAction(title: "Author", style: .default) { action in
            actionSheet.dismiss(animated: true)
            self.viewModel.sortDataAccordingTo(option: .author)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            actionSheet.dismiss(animated: true)
        }
        actionSheet.addAction(dateOptionAction)
        actionSheet.addAction(titleOptionAction)
        actionSheet.addAction(authorOptionAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true)
    }
    
    // MARK: - Pull to Refresh Method
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
           self?.viewModel.refreshScreen()
        }
    }
}

// MARK: - Operation & Queue Methods
extension FeedsViewController {
    func startDownloadForRecord(article: ArticleCellViewModel, indexPath: IndexPath){
        let result = downloadsInProgress.filter { (model) -> Bool in
            return (model.item == indexPath.row)
        }
        if result.count > 0 {
            return
        }

        let operation = BlockOperation(block: {
            guard let imageUrlPath = article.imageUrl, let url = URL(string: imageUrlPath) else {
                return
            }
            NetworkManager.shared.downloadImage(url: url, completion: { [weak self] (image, error) in
                guard let sSelf = self else {
                    return
                }
                OperationQueue.main.addOperation({
                    if image != nil {
                        sSelf.viewModel.tableDataSource[indexPath.row].thumbnail = image!
                        sSelf.viewModel.tableDataSource[indexPath.row].state = .downloaded
                    }
                    else {
                        sSelf.viewModel.tableDataSource[indexPath.item].state = .failed
                        sSelf.viewModel.tableDataSource[indexPath.item].thumbnail = Images.placeholder
                    }
                    sSelf.feedsTableView.reloadRows(at: [indexPath], with: .none)
                    let index = sSelf.downloadsInProgress.firstIndex(where: { (model) -> Bool in
                        (model.item == indexPath.row)
                    })
                    if index != nil && sSelf.downloadsInProgress.indices.contains(index!){
                        sSelf.downloadsInProgress.remove(at: index!)
                    }
                })
            })
        })

        downloadQueue.addOperation(operation)
        let model = OperationModel(item: indexPath.item, operation: operation)
        downloadsInProgress.append(model)
    }

    func suspendAllOperations () {
        downloadQueue.isSuspended = true
    }

    func resumeAllOperations () {
        downloadQueue.isSuspended = false
    }

    func loadImagesForOnscreenCells () {
        let pathArray = feedsTableView.indexPathsForVisibleRows ?? []
        let allPendingOperations = Set(downloadsInProgress.map({ (model)  in
            return model.item
        }))

        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathArray.map({ (model)  in
            return model.item
        }))
        toBeCancelled.subtract(visiblePaths)

        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
        toBeStarted = toBeStarted.filter({ (item) -> Bool in
            let articlesVM = self.viewModel.tableDataSource[item]
            return ( articlesVM.state == .new )
        })

        for index in toBeCancelled {
            let result = downloadsInProgress.filter { (model) -> Bool in
                return (model.item == index)
            }
            if result.count > 0 {
                result[0].operation.cancel()
            }
            let index = downloadsInProgress.firstIndex(where: { (model) -> Bool in
                (model.item == index)
            })
            if index != nil {
                self.downloadsInProgress.remove(at: index!)
            }
        }

        for index in toBeStarted {
            let indexPath = IndexPath(item: index, section: 0)
            let articleVM = self.viewModel.tableDataSource[indexPath.row]
            startDownloadForRecord(article: articleVM, indexPath: indexPath)
        }
    }
}

// MARK:- UITableView Delegate Methods
extension FeedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.feed) as? FeedTableViewCell else {
            return UITableViewCell()
        }
        cell.populateCell(articleViewModel: viewModel.tableDataSource[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let feedCell = cell as? FeedTableViewCell else {
            return
        }
        let articleViewModel = viewModel.tableDataSource[indexPath.row]
        switch (articleViewModel.state){
        case .failed:
            break
        case .new:
            if !tableView.isDragging && !tableView.isDecelerating {
                startDownloadForRecord(article: articleViewModel, indexPath: indexPath)
            }
            break
        case .downloaded:
            feedCell.populateCell(articleViewModel: articleViewModel)
            break
        }
    }
}

// MARK:- ScrollView Delegate Methods
extension FeedsViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            resumeAllOperations()
            loadImagesForOnscreenCells()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resumeAllOperations()
        loadImagesForOnscreenCells()
    }
}

// MARK: - Navigation
extension FeedsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = feedsTableView.indexPathForSelectedRow else {
            return
        }
        if segue.identifier == SegueIdentifiers.detail, let detailViewController = segue.destination as? DetailViewController {
            let detailViewModel = DetailViewModel(data: viewModel.tableDataSource[indexPath.row])
            detailViewController.detailViewModel = detailViewModel
        }
    }
}


