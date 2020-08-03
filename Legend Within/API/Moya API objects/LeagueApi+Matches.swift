//
//  LeagueApi+Matches.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Moya

extension LeagueApi {
    enum Matches {
        case singleMatch(region: Region, matchId: Int)
        case byAccount(region: Region, encryptedAccountId: String, queryParams: ByAccountQueryParameters)
    }
}

extension LeagueApi.Matches : TargetType {
    public var baseURL: URL {
        switch self {
            case .singleMatch(let region, _),
                 .byAccount(let region, _, _):
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
        }
    }

    public var method: Moya.Method { .get }

    public var sampleData: Data { Data() }

    public var task: Task {
        switch self {
            case .singleMatch:
                return .requestPlain
            case .byAccount(_, _, let queryParams):
                return .requestParameters(parameters: queryParams.convertToRequestParameters(), encoding: URLEncoding.default)
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

            if  self.queues != nil,
                let queuesJson = try? JSONSerialization.data(withJSONObject: self.queues as Any, options: []) {
                params["queue"] = String(data: queuesJson, encoding: .utf8)
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

