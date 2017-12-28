//
//  FavoritesController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension FavoritesViewController {
    
    // MARK: - Instantiation
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> FavoritesViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! FavoritesViewController
    }
    
}

