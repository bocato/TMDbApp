//
//  PersistenceErrorsEnum.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 30/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

public enum PersistenceErrorCodes: Int {
    case invalidDatabase = -999
    case objectNotFound = -998
    case couldNotDeleteObject = -997
    case couldNotSaveOrUpdateObject = -996
}

public enum PersistenceErrorMessages: String {
    case invalidDatabase = "Invalid database."
    case objectNotFound = "Object not found."
    case couldNotDeleteObject = "Could not delete object."
    case couldNotSaveOrUpdateObject = "Could not save or update object."
}
