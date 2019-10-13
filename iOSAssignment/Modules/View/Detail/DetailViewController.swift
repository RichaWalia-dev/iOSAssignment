//
//  DetailViewController.swift
//  iOSAssignment
//
//  Created by Richa Walia on 10/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var detailViewModel: DetailViewModel?
    
    // MARK: - View Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        observeEvents()
    }
    
    // MARK: - Private Methods
    private func setUpUI() {
        guard let viewModel = self.detailViewModel else {
            return
        }
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.content
        self.articleImageView.image = viewModel.thumbnail
    }
    
    private func observeEvents() {
        detailViewModel?.updateImage = { [weak self] in
            DispatchQueue.main.async {
                self?.articleImageView.image = self?.detailViewModel?.thumbnail
            }
        }
    }
}
