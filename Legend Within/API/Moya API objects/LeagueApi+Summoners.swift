//
//  LeagueApi+Summoners.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Moya

extension LeagueApi {
    enum Summoners {
        case byAccount(region: Region, encryptedAccountId: String)
        case byName(region: Region, name: String)
        case byPUUID(region: Region, puuid: String)
        case byEncryptedSummonerId(region: Region, encryptedSummonerId: String)
    }
}

extension LeagueApi.Summoners : TargetType {
    public var baseURL: URL {
        switch self {
            case .byAccount(let region, _),
                 .byEncryptedSummonerId(let region, _),
                 .byName(let region, _),
                 .byPUUID(let region, _):
                return LeagueApi.apiUrl(region: region)
        }
    }

    public var path: String {
        let commonPart = "/lol/summoner/v4/summoners"
        switch self {
            case let .byAccount(_, encryptedAccountId):
                return "\(commonPart)/by-account/\(encryptedAccountId)"
            case let .byName(_, name):
                return "\(commonPart)/by-name/\(name)"
            case let .byPUUID(_, puuid):
                return "\(commonPart)/by-puuid/\(puuid)"
            case let .byEncryptedSummonerId(_, encryptedSummonerId):
                return "\(commonPart)/\(encryptedSummonerId)"
        }
    }

    public var method: Moya.Method { .get }

    public var sampleData: Data { Data() }

    public var task: Task { .requestPlain }

    public var headers: [String : String]? { LeagueApi.commonHeaders }

    public var validationType: ValidationType { .successCodes }
}
