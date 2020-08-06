//
//  NetworkRequestError.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 06..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Moya
import Combine

enum NetworkRequestError : Error {
    case decodingError
    case requestFailedError(error: MoyaError)
    case other

    static func transformDecodableNetworkErrorStream(error: Error) -> NetworkRequestError {
        switch error {
            case is DecodingError: return NetworkRequestError.decodingError
            case let moyaError as MoyaError: return NetworkRequestError.requestFailedError(error: moyaError)
            default: return NetworkRequestError.other
        }
    }
}
