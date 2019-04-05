//
//  CustomError.swift
//  CryptoConverter
//
//  Created by Alina Fesyk on 4/5/19.
//  Copyright © 2019 Alina FESYK. All rights reserved.
//

import Foundation

enum CustomError: Error, CustomStringConvertible {
    case badURLFormat
    case serverResponseIsFailure
    case responseDataUnavailable
    case badUserInput
    case custom(String)
    
    
    var description: String {
        switch self {
        case .badURLFormat:
            return "Bad URL format"
        case .serverResponseIsFailure:
            return "Server error"
        case .responseDataUnavailable:
            return "No data is available"
        case .badUserInput:
            return "Use only + or - followed by a number"
        case .custom(let msg):
            return msg
        }
    }
}
