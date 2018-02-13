//
//  ErrorsEnum.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 13/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

enum ErrorCode: Int {
    case unknown = -111
    case unexpected = -999
}

enum ErrorMessage: String {
    case unknown = "An unknown error has occured. Try again later."
    case unexpected = "An unexpected error has occured. Check your internet connection and try again."
    case couldNotLoadUserData = "Could not load user data."
    case invalidEmailOrPassword = "Invalid e-mail or password."
    case couldNotLoadData = "Could not load data."
}
