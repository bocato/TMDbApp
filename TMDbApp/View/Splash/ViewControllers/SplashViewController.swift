//
//  SplashViewController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var timer: Timer?
    var remainingSeconds: Int = 3 {
        didSet {
            if remainingSeconds <= 0 {
                stopTimer()
                activityIndicator.stopAnimating()
                NavigationRouter().perform(segue: .home)
            }
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        startMockLoader()
    }
    
    // MARK: - Actions
    func startMockLoader () {
        activityIndicator.startAnimating()
        startTimer()
    }
    
    @objc private func onTick(_ timer: Timer?) {
        remainingSeconds -= 1
    }
    
    // MARK: - Timer
    private func startTimer() {
        if timer != nil {
            stopTimer()
        }
        timer = Timer(fireAt: Date(timeIntervalSinceNow: 0.0),
                      interval: 1.0,
                      target: self,
                      selector: #selector(onTick(_:)),
                      userInfo: nil,
                      repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    private func stopTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
}

extension SplashViewController {
    
    // MARK: - Instantiation
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> SplashViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SplashViewController
    }
    
}
