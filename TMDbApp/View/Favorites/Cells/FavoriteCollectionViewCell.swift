//
//  FavoriteCollectionViewCell.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import CoreMotion

fileprivate struct ViewConstants {
    static let shadowInnerMargin: CGFloat = 20.0
}

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var roundedContentView: UIView!
    @IBOutlet fileprivate weak var movieLabel: UILabel!
    @IBOutlet fileprivate weak var backdropImageView: UIImageView!
    
    // MARK: Constants
    let genresAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24), NSAttributedStringKey.foregroundColor: UIColor.black]
    let dateAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    
    // MARK: Computed Properties
    var invalidInfoAttributedTitleAndYear: NSAttributedString {
        return NSAttributedString(string: "Unknown", attributes: titleAttributes)
    }
    
    // MARK: Properties
    fileprivate weak var shadowView: UIView?
    fileprivate let motionManager = CMMotionManager()
    fileprivate var longPressGestureRecognizer: UILongPressGestureRecognizer? = nil
    fileprivate var isCellBeingPressed: Bool = false
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedContentView.configureRoundedBorders(with: 1.0, cornerRadius: 14.0, borderColor: UIColor.lightGray.cgColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    // MARK: - Configuration
    private func createMovieLabelAttributedString(for movie: Movie!) -> NSAttributedString {
        guard let title = movie.title, let year = Date.new(from: movie.releaseDate!, format: "yyyy-MM-dd")?.stringWithFormat("yyyy"), let genresString = movie.genresString else { return invalidInfoAttributedTitleAndYear }
        let attributedString = NSMutableAttributedString(string: genresString + "\n", attributes: genresAttributes)
        attributedString.append(NSAttributedString(string: title, attributes: titleAttributes))
        attributedString.append(NSAttributedString(string: " (\(year))", attributes: dateAttributes))
        return attributedString
    }
    
    private func configureBackdrop(for movie: Movie!){
        guard let backdropPathURLString = movie.backdropPathURLString else {
            backdropImageView.image = UIImage.fromResource(named: .noBackdrop)
            backdropImageView.contentMode = .scaleAspectFit
            backdropImageView.layoutSubviews()
            return
        }
        backdropImageView.setImage(with: backdropPathURLString, imageForError: UIImage.fromResource(named: .noBackdrop), downloadedImageContentMode: .scaleToFill)
        backdropImageView.layoutSubviews()
    }
    
    func configure(with movie: Movie?) {
        guard let movie = movie else { return }
        configureBackdrop(for: movie)
        movieLabel.attributedText = createMovieLabelAttributedString(for: movie)
    }
    
    // MARK: - Dinamic Shadow
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: ViewConstants.shadowInnerMargin,
                                              y: ViewConstants.shadowInnerMargin,
                                              width: bounds.width - (2 * ViewConstants.shadowInnerMargin),
                                              height: bounds.height - (2 * ViewConstants.shadowInnerMargin)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        
        // Roll/Pitch Dynamic Shadow
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
                if let motion = motion {
                    let pitch = motion.attitude.pitch * 10 // x-axis
                    let roll = motion.attitude.roll * 10 // y-axis
                    self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
                }
            })
        }
    }
    
    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.configureShadow(withShadowOffset: CGSize(width: width, height: height), shadowRadius: 8.0, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.45, shadowPath: shadowPath.cgPath)
        }
    }
    
    // MARK: - Gesture Recognizers
    private func configureGestureRecognizer() {
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(FavoriteCollectionViewCell.didRecognizeLongPressGesture(_:)))
        longPressGestureRecognizer?.minimumPressDuration = 0.1
        addGestureRecognizer(longPressGestureRecognizer!)
    }
    
    @objc private  func didRecognizeLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            longPressGestureDidBegan(sender)
        } else if sender.state == .ended || sender.state == .cancelled {
            longPressGestureDidEnd(sender)
        }
    }
    
    private func longPressGestureDidBegan(_ sender: UILongPressGestureRecognizer) {
        guard !isCellBeingPressed else { return }
        isCellBeingPressed = true
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    private func longPressGestureDidEnd(_ sender: UILongPressGestureRecognizer) {
        guard isCellBeingPressed else { return }
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform.identity
        }, completion: { (finished) in
            self.isCellBeingPressed = false
        })
    }
    
    // MARK: - KingFisher
    func cancelDownloadTask() {
        backdropImageView.cancelDownloadTask()
    }
    
}
