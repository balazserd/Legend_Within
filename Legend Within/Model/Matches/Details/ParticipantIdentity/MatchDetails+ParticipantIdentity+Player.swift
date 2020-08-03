//
//  MatchDetails+ParticipantIdentity+Player.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchDetails.ParticipantIdentity {
    final class Player: Codable {
        let platformId: String
        let accountId: String
        let summonerName: String
        let summonerId: String
        let currentPlatformId: String
        let currentAccountId: String
        let matchHistoryUri: String
        let profileIcon: Int

        private enum CodingKeys: String, CodingKey {
            case platformId = "platformId"
            case accountId = "accountId"
            case summonerName = "summonerName"
            case summonerId = "summonerId"
            case currentPlatformId = "currentPlatformId"
            case currentAccountId = "currentAccountId"
            case matchHistoryUri = "matchHistoryUri"
            case profileIcon = "profileIcon"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            platformId = try values.decode(String.self, forKey: .platformId)
            accountId = try values.decode(String.self, forKey: .accountId)
            summonerName = try values.decode(String.self, forKey: .summonerName)
            summonerId = try values.decode(String.self, forKey: .summonerId)
            currentPlatformId = try values.decode(String.self, forKey: .currentPlatformId)
            currentAccountId = try values.decode(String.self, forKey: .currentAccountId)
            matchHistoryUri = try values.decode(String.self, forKey: .matchHistoryUri)
            profileIcon = try values.decode(Int.self, forKey: .profileIcon)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(platformId, forKey: .platformId)
            try container.encode(accountId, forKey: .accountId)
            try container.encode(summonerName, forKey: .summonerName)
            try container.encode(summonerId, forKey: .summonerId)
            try container.encode(currentPlatformId, forKey: .currentPlatformId)
            try container.encode(currentAccountId, forKey: .currentAccountId)
            try container.encode(matchHistoryUri, forKey: .matchHistoryUri)
            try container.encode(profileIcon, forKey: .profileIcon)
        }
    }
}
