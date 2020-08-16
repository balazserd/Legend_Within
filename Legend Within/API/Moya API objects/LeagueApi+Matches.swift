//
//  LeagueApi+Matches.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Moya
import Alamofire

extension LeagueApi {
    enum Matches {
        case singleMatch(region: Region, matchId: Int)
        case byAccount(region: Region, encryptedAccountId: String, queryParams: ByAccountQueryParameters)
        case timeline(region: Region, matchId: Int)
    }
}

extension LeagueApi.Matches : TargetType {
    public var baseURL: URL {
        switch self {
            case .singleMatch(let region, _),
                 .byAccount(let region, _, _),
                 .timeline(let region, _):
                return LeagueApi.apiUrl(region: region)
        }
    }

    public var path: String {
        let commonPart = "/lol/match/v4"
        switch self {
            case .singleMatch(_, let matchId):
                return "\(commonPart)/matches/\(matchId)"
            case .byAccount(_, let encryptedAccountId, _):
                return "\(commonPart)/matchlists/by-account/\(encryptedAccountId)"
            case .timeline(_, let matchId):
                return "\(commonPart)/timelines/by-match/\(matchId)"
        }
    }

    public var method: Moya.Method { .get }

    public var sampleData: Data { Data() }

    public var task: Task {
        switch self {
            case .singleMatch:
                return .requestPlain
            case .byAccount(_, _, let queryParams):
                return .requestParameters(parameters: queryParams.convertToRequestParameters(), encoding: SameQueryParameterMultipleTimesEncoding())
            case .timeline:
                return .requestPlain
        }
    }

    public var headers: [String : String]? { LeagueApi.commonHeaders }

    public var validationType: ValidationType { .successCodes }
}

extension LeagueApi.Matches {
    struct ByAccountQueryParameters {
        var champions: [Int]?
        var queues: [Int]?
        var endTime: Int?
        var beginTime: Int?
        var endIndex: Int?
        var beginIndex: Int?

        func convertToRequestParameters() -> [String : Any] {
            var params = [String : Any]()

            if  self.champions != nil,
                let championsJson = try? JSONSerialization.data(withJSONObject: self.champions as Any, options: []) {
                params["champion"] = String(data: championsJson, encoding: .utf8)
            }

            if let queuesUnwrapped = self.queues {
                params["queue"] = queuesUnwrapped
            }

            if let endTimeUnwrapped = self.endTime {
                params["endTime"] = endTimeUnwrapped
            }

            if let beginTimeUnwrapped = self.beginTime {
                params["beginTime"] = beginTimeUnwrapped
            }

            if let endIndexUnwrapped = self.endIndex {
                params["endIndex"] = endIndexUnwrapped
            }

            if let beginIndexUnwrapped = self.beginIndex {
                params["beginIndex"] = beginIndexUnwrapped
            }

            return params
        }
    }
}

extension LeagueApi.Matches {
    class SameQueryParameterMultipleTimesEncoding : ParameterEncoding {
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            if let originalRequest = try? urlRequest.asURLRequest() {
                guard
                    let scheme = originalRequest.url?.scheme,
                    let host = originalRequest.url?.host,
                    let path = originalRequest.url?.path
                else { return urlRequest.urlRequest! }

                var components = URLComponents()
                components.scheme = scheme
                components.host = host
                components.path = path

                var queryItems: [URLQueryItem] = []
                for param in parameters! {
                    if param.value is [Int] {
                        //Need to add the same query parameter as many times as the number of items in the array.
                        let vals = param.value as! [Int]
                        for val in vals {
                            queryItems.append(URLQueryItem(name: param.key, value: String(val)))
                        }
                    } else {
                        queryItems.append(URLQueryItem(name: param.key, value: "\(param.value)"))
                    }
                }

                components.queryItems = queryItems
                var encodedRequest = originalRequest
                encodedRequest.url = components.url

                return encodedRequest
            }

            return urlRequest.urlRequest!
        }
    }
}
