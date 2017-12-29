//
//  OverViewTableViewCell.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class OverViewTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet private weak var overviewTextView: UITextView!
    
    // MARK: - Properties
    private var posterImageViewTapActionClosure: ((_ cell: OverViewTableViewCell) -> ())? = nil
    private var addToFavoritesButtonActionClosure: ((_ cell: OverViewTableViewCell) -> ())? = nil
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureImageViewGestureRecognizer()
    }
    
    // MARK: - Configuration
    func configure(with movie: Movie?, posterImageViewTapActionClosure: ((_ cell: OverViewTableViewCell) -> ())? = nil, addToFavoritesButtonActionClosure: ((_ cell: OverViewTableViewCell) -> ())? = nil){
        guard let posterURLString = movie?.posterURLString, let overview = movie?.overview else { return }
        posterImageView.setImage(with: posterURLString, placeholderImage: UIImage.fromResource(named: .moviePlaceholder))
        overviewTextView.text = overview
        self.posterImageViewTapActionClosure = posterImageViewTapActionClosure
        self.addToFavoritesButtonActionClosure = addToFavoritesButtonActionClosure
    }
    
    private func configureImageViewGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OverViewTableViewCell.imageViewDidReceiveTouchUpInside(_:)))
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Selectors
    @objc private func imageViewDidReceiveTouchUpInside(_ sender: UITapGestureRecognizer){
        posterImageViewTapActionClosure?(self)
    }
    
    // MARK: - IBActions
    @IBAction func addToFavoritesButtonDidReceiveTouchUpInside(_ sender: UIButton) {
        addToFavoritesButtonActionClosure?(self)
    }
    
    // MARK: KingFisher
    func cancelDownloadTask() {
        posterImageView.cancelDownloadTask()
    }

}
