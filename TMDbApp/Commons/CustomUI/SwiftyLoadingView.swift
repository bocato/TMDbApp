//
//  SwiftyLoadingView.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import SnapKit

// MARK: Constants
fileprivate struct Defaults {
    static let backgroundViewAlpha: CGFloat = 0.9
    static let activityIndicatorViewSquareSize = 30
    static let animationDuration = 0.35
}

class SwiftyLoadingView: UIControl {
    
    // MARK: View Elements
    private var backgroundView: UIView!
    private var activityIndicatorView: UIActivityIndicatorView!
    private var textLabel: UILabel!
    
    // MARK: Properties
    private var showBackgroundView: Bool? {
        willSet {
            if let newValue = newValue, newValue != showBackgroundView {
                self.backgroundColor = newValue ? UIColor.clear : UIColor.white
                self.backgroundView.backgroundColor = newValue ? UIColor.white : UIColor.clear
                self.backgroundView.layer.borderColor = newValue ? UIColor.groupTableViewBackground.cgColor : UIColor.clear.cgColor
                self.backgroundView.layoutSubviews()
            }
        }
    }
    private var text: String? {
        didSet {
            if let newText = text {
                self.textLabel.text = newText
                self.remakeConstraints()
                self.textLabel.layoutIfNeeded()
            }
        }
    }
    private var backGroundViewSquareSize: Int {
        guard let text = self.text, text.count > 0 else {
            return 70
        }
        return 100
    }
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private init(frame: CGRect, activityIndicatorStyle style: UIActivityIndicatorViewStyle, activityIndicatorColor color: UIColor = UIColor.lightGray) {
        super.init(frame: frame)
        self.configureViewElements(activityIndicatorStyle: style, activityIndicatorColor: color)
    }
    
    
    // MARK: - Instantiation
    fileprivate static func instantiateNew(in view: UIView!, withActivityIndicatorStyle style: UIActivityIndicatorViewStyle, activityIndicatorColor color: UIColor = UIColor.lightGray) -> SwiftyLoadingView? {
        let loadingView = SwiftyLoadingView(frame: view.frame, activityIndicatorStyle: style, activityIndicatorColor: color)
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(view)
        }
        return loadingView
    }
    
    fileprivate static func instantiateNew(in context: Any!, withActivityIndicatorStyle style: UIActivityIndicatorViewStyle, activityIndicatorColor color: UIColor = UIColor.lightGray) -> SwiftyLoadingView? {
        
        if let contextAsController = context as? UIViewController {
            return self.instantiateNew(in: contextAsController.view, withActivityIndicatorStyle: style, activityIndicatorColor: color)
        }
        else if let contextAsView = context as? UIView {
            return self.instantiateNew(in: contextAsView, withActivityIndicatorStyle: style, activityIndicatorColor: color)
        }
        
        return nil
    }
    
    // MARK: - Layout Configuration
    private func configureViewElements(activityIndicatorStyle style: UIActivityIndicatorViewStyle = .whiteLarge, activityIndicatorColor color: UIColor = UIColor.lightGray) {
        self.backgroundColor = UIColor.white
        self.isHidden = true
        self.configureActivityIndicatorBackgroundView()
        self.configureActivityIndicator(activityIndicatorStyle: style, activityIndicatorColor: color)
        self.configureTextLabel()
    }
    
    
    fileprivate func configureActivityIndicatorBackgroundView() {
        self.backgroundView = UIView()
        self.backgroundView.backgroundColor = UIColor.white
        self.backgroundView.alpha = Defaults.backgroundViewAlpha
        self.backgroundView.layer.cornerRadius = 10.0
        self.backgroundView.layer.borderColor = UIColor.clear.cgColor
        self.backgroundView.layer.borderWidth = 2.0
        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.height.width.equalTo(self.backGroundViewSquareSize)
        }
    }
    
    fileprivate func configureActivityIndicator(activityIndicatorStyle style: UIActivityIndicatorViewStyle = .whiteLarge, activityIndicatorColor color: UIColor = UIColor.lightGray) {
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: style)
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicatorView.color = color
        self.backgroundView?.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.backgroundView)
            make.height.width.equalTo(Defaults.activityIndicatorViewSquareSize)
        }
    }
    
    fileprivate func configureTextLabel() {
        self.textLabel = UILabel()
        self.textLabel.font = UIFont.systemFont(ofSize: 12)
        self.textLabel.clipsToBounds = true
        self.textLabel.textColor = UIColor.darkGray
        self.textLabel.textAlignment = NSTextAlignment.center
        self.textLabel.lineBreakMode = .byTruncatingTail
        self.textLabel.numberOfLines = 3
        self.backgroundView.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.activityIndicatorView).offset(10)
            make.centerX.equalTo(self.activityIndicatorView)
            make.left.equalTo(self.backgroundView).offset(5)
            make.right.equalTo(self.backgroundView).offset(-5)
            make.bottom.equalTo(self.backgroundView).offset(-5)
        }
    }
    
    
    // MARK: Constraints
    fileprivate func remakeConstraints() {
        self.backgroundView.snp.remakeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.height.width.equalTo(self.backGroundViewSquareSize)
        }
        self.activityIndicatorView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.backgroundView.snp.top).offset(20)
            make.centerY.lessThanOrEqualTo(self.backgroundView)
            make.centerX.equalTo(self.backgroundView)
            make.height.width.equalTo(Defaults.activityIndicatorViewSquareSize)
        }
        self.textLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self.activityIndicatorView.snp.bottom).offset(5)
            make.centerX.equalTo(self.activityIndicatorView)
            make.left.equalTo(self.backgroundView).offset(5)
            make.right.equalTo(self.backgroundView).offset(-5)
            make.bottom.equalTo(self.backgroundView.snp.bottom).offset(-5)
        }
    }
    
    // MARK: - Public Actions
    public static func hide(for context: Any!) {
        if let contextAsController = context as? UIViewController {
            self.hide(forContext: contextAsController.view)
        }
        else if let contextAsView = context as? UIView {
            self.hide(forContext: contextAsView)
        }
    }
    
    fileprivate static func hide(forContext view: UIView?){
        if let viewSubviews = view?.subviews, let currentVisibleLoadingView = viewSubviews.filter({ $0.isKind(of: SwiftyLoadingView.self) }).first as? SwiftyLoadingView {
            currentVisibleLoadingView.hide()
            currentVisibleLoadingView.removeFromSuperview()
        }
    }
    
    public static func show(in context: Any!, withText text: String? = nil, background: Bool = false, activityIndicatorStyle style: UIActivityIndicatorViewStyle = .whiteLarge, activityIndicatorColor color: UIColor? = nil) {
        if let loadingView = SwiftyLoadingView.instantiateNew(in: context, withActivityIndicatorStyle: style) {
            loadingView.text = text
            loadingView.show(withBackground: background)
        }
    }
    
    // MARK: - Behavior
    fileprivate func hide() {
        self.showBackgroundView = false
        self.alpha = 1.0
        self.backgroundView.alpha = Defaults.backgroundViewAlpha
        UIView.animate(withDuration: Defaults.animationDuration, animations: {
            self.alpha = 0.0
        }, completion: { (finished) in
            self.activityIndicatorView.stopAnimating()
            self.backgroundView.isHidden = true
            self.isHidden = true
        })
    }
    
    fileprivate func show(withBackground background: Bool = false) {
        self.showBackgroundView = background
        self.backgroundView.isHidden = !background
        self.backgroundView.alpha = 0.0
        self.isHidden = false
        self.alpha = 0.0
        self.activityIndicatorView.startAnimating()
        UIView.animate(withDuration: Defaults.animationDuration) {
            self.alpha = 1.0
            self.backgroundView.alpha = Defaults.backgroundViewAlpha
        }
    }
    
}
