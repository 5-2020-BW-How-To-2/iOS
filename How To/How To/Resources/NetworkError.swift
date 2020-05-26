//
//  NetworkError.swift
//  How To
//
//  Created by Chris Dobek on 5/26/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case badUrl
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}
