//
//  BottomAlertController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class BottomAlertController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var leftButton: UIButton!
    @IBOutlet weak private var rightButton: UIButton!
    
    // MARK: Constants
    let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    
    // MARK: - Properties
    var modalTitle: String?
    var text: String?
    var leftButtonTitle: String?
    private var leftButtonActionClosure: (()->())?
    var rightButtonTitle: String?
    private var rightButtonActionClosure: (()->())?
    
    // MARK: Instantiation
    static func instantiateNew(withTitle title: String? = nil, text: String!, leftButtonTitle: String? = nil, leftButtonActionClosure: (()->())? = nil, rightButtonTitle: String? = nil, rightButtonActionClosure: (()->())? = nil) -> BottomAlertController {
        
        // Storyboard
        let storyboard = UIStoryboard(name: "Modals", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! BottomAlertController
        
        // TextLabel
        controller.modalTitle = title
        controller.text = text
        
        // Left Button
        controller.leftButtonTitle = leftButtonTitle
        controller.leftButtonActionClosure = leftButtonActionClosure
        
        // Right Button
        controller.rightButtonTitle = rightButtonTitle
        controller.leftButtonActionClosure = leftButtonActionClosure
        
        // Safety Checks...
        if leftButtonTitle == nil && rightButtonTitle == nil {
            fatalError("You need at least one button apearing! Configure right or left, prefferably with an action!")
        }
        
        return controller
    }
    
    static func instantiateNew(withTitle title: String? = nil, text: String!, buttonTitle: String? = "Ok", actionClosure: (()->())? = nil) -> BottomAlertController {
        return BottomAlertController.instantiateNew(withTitle: title, text: text, leftButtonTitle: buttonTitle, leftButtonActionClosure: actionClosure, rightButtonTitle: nil, rightButtonActionClosure: nil)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leftButton.isHidden = leftButtonTitle == nil
        rightButton.isHidden = rightButtonTitle == nil
    }
    
    // MARK: UI Configuration
    func setupUI(){
        leftButton.setTitle(leftButtonTitle, for: .normal)
        rightButton.setTitle(rightButtonTitle, for: .normal)
        setupTextLabel()
    }
    
    func setupTextLabel() {
        var attributedText: NSMutableAttributedString?
        if let title = modalTitle, let text = text {
            attributedText = NSMutableAttributedString(string: title + "\n\n", attributes: titleAttributes)
            attributedText?.append(NSAttributedString(string: text, attributes: textAttributes))
        } else if let text = text {
            attributedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        }
        textLabel.attributedText = attributedText
    }
    
    // MARK: IBActions
    @IBAction func leftButtonDidReceiveTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true) {
            self.leftButtonActionClosure?()
        }
    }
    
    @IBAction func rightButtonDidReceiveTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true) {
            self.rightButtonActionClosure?()
        }
    }
    
}
