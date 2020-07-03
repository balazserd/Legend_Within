//
//  LeagueApi+LeagueEntries.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Moya

extension LeagueApi {
    enum LeagueEntries {
        case byEncryptedSummonerId(region: Region, encryptedSummonerId: String)
        case byQueue(region: Region, division: String, tier: String, queue: String)
        case leagues(region: Region, leagueId: String)
    }
}

extension LeagueApi.LeagueEntries : TargetType {
    public var baseURL: URL {
        switch self {
            case .byEncryptedSummonerId(let region, _),
                 .byQueue(let region, _, _, _),
                 .leagues(let region, _):
                return LeagueApi.apiUrl(region: region)
        }
    }

    public var path: String {
        let commonPart = "/lol/league/v4"
        switch self {
            case .byEncryptedSummonerId(_, let encryptedSummonerId):
                return "\(commonPart)/entries/by-summoner/\(encryptedSummonerId)"
            case .byQueue(_, let division, let tier, let queue):
                return "\(commonPart)/entries/\(queue)/\(tier)/\(division)"
            case .leagues(_, let leagueId):
                return "\(commonPart)/leagues/\(leagueId)"
        }
    }

    public var method: Moya.Method { .get }

    public var sampleData: Data { Data() }

    public var task: Task { .requestPlain }

    public var headers: [String : String]? { LeagueApi.commonHeaders }

    public var validationType: ValidationType { .successCodes }
}
