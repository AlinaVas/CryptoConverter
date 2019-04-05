//
//  Result.swift
//  CryptoConverter
//
//  Created by Alina Fesyk on 4/5/19.
//  Copyright © 2019 Alina FESYK. All rights reserved.
//

import Foundation

enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
